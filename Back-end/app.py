from flask import Flask, jsonify, request
from sqlalchemy import text
from config import BaseConfig
from flask_sqlalchemy import SQLAlchemy
import auth
import json
import random
import datetime
from redis import StrictRedis
from flask_cors import CORS, cross_origin

# Redis
redis_store = StrictRedis(
    host=BaseConfig.REDIS_HOST, port=BaseConfig.REDIS_PORT, decode_responses=True
)

# Flask 初始化
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)   # ⭐ 全局 CORS

# 数据库
app.config.from_object(BaseConfig)
db = SQLAlchemy(app)

# 测试数据库连接
with app.app_context():
    with db.engine.connect() as conn:
        rs = conn.execute(text("select 1"))
        print(rs.fetchone())


# ============================================================
#                      工具函数
# ============================================================
def get_token_phone(token):
    data = auth.decode_func(token)
    return data["telephone"]


# ============================================================
#                      用户端接口
# ============================================================

# 登录
@app.route("/api/user/login", methods=["POST"])
@cross_origin()
def user_login():
    rq = request.json
    userortel = rq.get("userortel").strip()
    password = rq.get("password").strip()

    sql = (
        'select * from user where telephone="{0}" and password="{1}"'
    ).format(userortel, password)
    data = db.session.execute(text(sql)).first()

    if data:
        user = {
            "id": data[0],
            "username": data[1],
            "password": data[2],
            "telephone": data[3],
        }
        token = auth.encode_func(user)
        return jsonify({"code": 200, "msg": "登录成功", "token": token, "role": data[4]})
    else:
        return jsonify({"code": 1000, "msg": "用户名或密码错误"})


# 用户查看书籍
@app.route("/api/user/books", methods=["GET"])
@cross_origin()
def user_get_books():
    rows = db.session.execute(text("select * from book")).fetchall()
    Data = []
    for r in rows:
        Data.append(
            dict(
                book_title=r[0],
                author=r[1],
                price=r[2],
                total_borrowed=r[3],
                description=r[4],
            )
        )
    return jsonify(status=200, tabledata=Data)


# 用户申请借阅
@app.route("/api/user/borrow", methods=["POST"])
@cross_origin()
def user_borrow():
    rq = request.json
    borrower_phone = get_token_phone(request.headers.get("token"))

    sql = '''insert into borrow_order(book_title, borrow_method, borrower_phone, borrower_name, borrower_address, status, borrow_time)
             value("%s","%s","%s","%s","%s",0,"%s")''' % (
        rq.get("book_title"),
        rq.get("borrow_method"),
        borrower_phone,
        rq.get("borrower_name"),
        rq.get("borrower_address"),
        datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    )

    db.session.execute(text(sql))
    db.session.commit()
    return jsonify(status=200, msg="借阅申请已提交")


# 用户查看待处理借阅
@app.route("/api/user/pending_borrow", methods=["GET"])
@cross_origin()
def user_pending_borrow():
    phone = get_token_phone(request.headers.get("token"))

    rows = db.session.execute(
        text('select * from borrow_order where status=0 and borrower_phone="%s"' % phone)
    ).fetchall()

    Data = []
    for r in rows:
        Data.append(
            dict(
                borrow_id=r[0],
                book_title=r[1],
                borrow_method=r[2],
                borrower_phone=r[3],
                borrower_name=r[4],
                borrower_address=r[5],
                status=r[6],
                borrow_time=r[7],
            )
        )

    return jsonify(status=200, tabledata=Data)


# 用户查看处理中借阅
@app.route("/api/user/processing_borrow", methods=["GET"])
@cross_origin()
def user_processing_borrow():
    phone = get_token_phone(request.headers.get("token"))

    rows = db.session.execute(
        text('select * from processing_borrow where borrower_phone="%s"' % phone)
    ).fetchall()

    Data = []
    for r in rows:
        Data.append(
            dict(
                borrow_id=r[0],
                book_title=r[1],
                borrow_method=r[2],
                librarian_id=r[6],
                process_time=r[7],
            )
        )
    return jsonify(status=200, tabledata=Data)


# 用户查看已完成借阅
@app.route("/api/user/completed_borrow", methods=["GET"])
@cross_origin()
def user_completed_borrow():
    phone = get_token_phone(request.headers.get("token"))

    rows = db.session.execute(
        text('select * from completed_borrow where borrower_phone="%s"' % phone)
    ).fetchall()

    Data = []
    for r in rows:
        Data.append(
            dict(
                borrow_id=r[0],
                book_title=r[1],
                borrow_method=r[2],
                librarian_id=r[6],
                process_time=r[7],
            )
        )
    return jsonify(status=200, tabledata=Data)


# 用户信息接口（给 IndiMsg.vue 用）
@app.route("/api/user/usermsg", methods=["GET"])
@cross_origin()
def user_usermsg():
    phone = get_token_phone(request.headers.get("token"))

    sql = """
        SELECT u.username, u.telephone, p.real_name, p.age, p.sex, p.email 
        FROM user u 
        LEFT JOIN user_profile p ON u.telephone = p.phone 
        WHERE u.telephone = :phone
    """
    
    row = db.session.execute(text(sql), {"phone": phone}).first()

    if row:
        return jsonify(
            status=200,
            data=dict(
                user_name=row[0],
                phone=row[1],
                real_name=row[2] if row[2] else "未填写",
                age=row[3] if row[3] else "未填写",
                sex=row[4] if row[4] else "未填写",
                mail=row[5] if row[5] else "未填写", 
            ),
        )
    else:
        return jsonify(status=404, msg="用户不存在")


# 修改密码
@app.route("/api/user/pwd_chg", methods=["POST"])
@cross_origin()
def user_pwd_change():
    rq = request.json
    phone = get_token_phone(request.headers.get("token"))

    old = rq.get("old_pwd")
    new = rq.get("new_pwd")

    row = db.session.execute(
        text(
            'select * from user where telephone="%s" and password="%s"'
            % (phone, old)
        )
    ).fetchall()

    if not row:
        return jsonify(status=1000, msg="原密码错误")

    db.session.execute(
        text('update user set password="%s" where telephone="%s"' % (new, phone))
    )
    db.session.commit()

    return jsonify(status=200, msg="密码修改成功")


# ============================================================
#                      管理端接口
# ============================================================

# 图书管理
@app.route("/api/manager/book", methods=["GET", "POST", "DELETE"])
@cross_origin()
def manager_book():
    if request.method == "GET":
        rows = db.session.execute(text("select * from book")).fetchall()
        Data = []
        for r in rows:
            Data.append(
                dict(
                    book_title=r[0],
                    author=r[1],
                    price=r[2],
                    total_borrowed=r[3],
                    description=r[4],
                )
            )
        return jsonify(status=200, tabledata=Data)

    if request.method == "POST":
        rq = request.json
        if rq.get("action") == "add":
            db.session.execute(
                text(
                    'insert into book(book_title, author, price, total_borrowed, description) '
                    'value("%s","%s",%d,%d,"%s")'
                    % (
                        rq["book_title"],
                        rq["author"],
                        rq["price"],
                        rq["total_borrowed"],
                        rq["description"],
                    )
                )
            )
            db.session.commit()
            return jsonify(status=200, msg="添加成功")

    if request.method == "DELETE":
        title = request.json.get("book_title")
        db.session.execute(text('delete from book where book_title="%s"' % title))
        db.session.commit()
        return jsonify(status=200, msg="删除成功")


# 管理端：馆内工作人员
@app.route("/api/manager/staff", methods=["GET", "POST", "DELETE"])
@cross_origin()
def manager_staff():
    if request.method == "GET":
        rows = db.session.execute(text("select * from library_staff")).fetchall()
        Data = []
        for r in rows:
            Data.append(
                dict(
                    staff_id=r[0],
                    staff_name=r[1],
                    assigned_section=r[2],
                )
            )
        return jsonify(status=200, tabledata=Data)

    if request.method == "POST":
        rq = request.json
        db.session.execute(
            text(
                'insert into library_staff(staff_id, staff_name, assigned_section) '
                'value("%s","%s","%s")'
                % (rq["staff_id"], rq["staff_name"], rq["assigned_section"])
            )
        )
        db.session.commit()
        return jsonify(status=200, msg="添加成功")

    if request.method == "DELETE":
        staff_id = request.json.get("want_delete")
        db.session.execute(
            text('delete from library_staff where staff_id="%s"' % staff_id)
        )
        db.session.commit()
        return jsonify(status=200, msg="删除成功")


# 管理端：图书管理员
@app.route("/api/manager/librarian", methods=["GET", "POST", "DELETE"])
@cross_origin()
def manager_librarian():
    if request.method == "GET":
        rows = db.session.execute(text("select * from librarian")).fetchall()
        Data = []
        for r in rows:
            Data.append(
                dict(
                    librarian_id=r[0],
                    librarian_name=r[1],
                    librarian_phone=r[2],
                )
            )
        return jsonify(status=200, tabledata=Data)

    if request.method == "POST":
        rq = request.json
        db.session.execute(
            text(
                'insert into librarian(librarian_id, librarian_name, librarian_phone) '
                'value("%s","%s","%s")'
                % (
                    rq["librarian_id"],
                    rq["librarian_name"],
                    rq["librarian_phone"],
                )
            )
        )
        db.session.commit()
        return jsonify(status=200, msg="添加成功")

    if request.method == "DELETE":
        librarian_id = request.json.get("want_delete")
        db.session.execute(
            text('delete from librarian where librarian_id="%s"' % librarian_id)
        )
        db.session.commit()
        return jsonify(status=200, msg="删除成功")


# 管理端：待处理借阅
@app.route("/api/manager/pending_borrow", methods=["GET"])
@cross_origin()
def manager_pending_borrow():
    rows = db.session.execute(
        text("select * from borrow_order where status=0")
    ).fetchall()

    Data = []
    for r in rows:
        Data.append(
            dict(
                borrow_id=r[0],
                book_title=r[1],
                borrow_method=r[2],
                borrower_phone=r[3],
                borrower_name=r[4],
                borrower_address=r[5],
                status=r[6],
                borrow_time=r[7],
            )
        )

    return jsonify(status=200, tabledata=Data)


# 管理端：借阅处理分配
@app.route("/api/manager/assign_borrow", methods=["POST"])
@cross_origin()
def manager_assign_borrow():
    rq = request.json
    borrow_id = rq.get("borrow_id")
    librarian_id = rq.get("librarian_id")
    process_time = rq.get("process_time")

    phone = db.session.execute(
        text("select borrower_phone from borrow_order where borrow_id=%d" % borrow_id)
    ).first()[0]

    db.session.execute(
        text(
            'insert into borrow_log(borrow_id, borrower_phone, librarian_id, process_time) '
            'value(%d,"%s","%s","%s")'
            % (borrow_id, phone, librarian_id, process_time)
        )
    )

    db.session.execute(
        text("update borrow_order set status=1 where borrow_id=%d" % borrow_id)
    )

    db.session.commit()
    return jsonify(status=200, msg="分配成功")


# 管理端：借阅日志（处理中 / 已完成）
@app.route("/api/manager/borrow_log", methods=["GET"])
@cross_origin()
def manager_borrow_log():
    finished = request.args.get("finished", "0")

    table = "processing_borrow" if finished == "0" else "completed_borrow"

    rows = db.session.execute(text(f"select * from {table}")).fetchall()

    Data = []
    for r in rows:
        Data.append(
            dict(
                borrow_id=r[0],
                book_title=r[1],
                borrow_method=r[2],
                borrower_phone=r[3],
                borrower_name=r[4],
                borrower_address=r[5],
                librarian_id=r[6],
                process_time=r[7],
                librarian_phone=r[8],
            )
        )
    return jsonify(status=200, tabledata=Data)

# 管理端：获取“处理中”的任务 (status=1)
@app.route("/api/manager/processing_tasks", methods=["GET"])
@cross_origin()
def manager_processing_tasks():
    sql = """
        SELECT bo.borrow_id, bo.book_title, bo.borrower_phone, bl.librarian_id, bl.process_time
        FROM borrow_order bo
        JOIN borrow_log bl ON bo.borrow_id = bl.borrow_id
        WHERE bo.status = 1
    """
    rows = db.session.execute(text(sql)).fetchall()
    
    Data = []
    for r in rows:
        Data.append(dict(
            borrow_id=r[0],
            book_title=r[1],
            borrower_phone=r[2],
            librarian_id=r[3], 
            assign_time=r[4]   
        ))
    return jsonify(status=200, tabledata=Data)

# 管理端：完成任务 
@app.route("/api/manager/finish_task", methods=["POST"])
@cross_origin()
def manager_finish_task():
    rq = request.json
    borrow_id = rq.get("borrow_id")
    
    db.session.execute(text("UPDATE borrow_order SET status=2 WHERE borrow_id=:bid"), {"bid": borrow_id})
 
    db.session.execute(text("UPDATE borrow_log SET finished=1 WHERE borrow_id=:bid"), {"bid": borrow_id})
    
    db.session.commit()
    return jsonify(status=200, msg="操作成功，借阅已完成")

# 管理端：图书归还（将状态置为3，代表归档/已还）
@app.route("/api/manager/return_book", methods=["POST"])
@cross_origin()
def manager_return_book():
    rq = request.json
    borrow_id = rq.get("borrow_id")
    
    sql = "UPDATE borrow_order SET status=3 WHERE borrow_id=:bid"
    db.session.execute(text(sql), {"bid": borrow_id})
    
    db.session.commit()
    return jsonify(status=200, msg="归还成功，记录已归档")


# ============================================================
#                     启动服务
# ============================================================

if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)
