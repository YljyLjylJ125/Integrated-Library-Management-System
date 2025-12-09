<template>
    <div class="shop-container">
        <div class="header">
            欢迎借阅图书
        </div>
        <div class="body">
            <el-table 
                :data="tableData" 
                style="width: 100%" 
                border 
                height="100%"
            >
                <el-table-column prop="book_title" label="书名" width="220" align="center" />
                <el-table-column prop="author" label="作者" width="200" align="center" />
                <el-table-column prop="price" label="价格" width="100" align="center" />
                <el-table-column prop="total_borrowed" label="借阅次数" width="120" align="center" />
                

                <el-table-column prop="description" label="简介" min-width="200" show-overflow-tooltip align="center" />
                
                <el-table-column label="操作" width="150" align="center">
                    <template slot-scope="scope">
                        <el-button icon="el-icon-plus" size="small" type="success" @click="showdia(scope.row)">
                            借阅
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>

            <el-dialog title="借阅申请" :visible.sync="dialog" class="dialog" width="40%">
                <div>
                    <el-form ref="form" :model="form" label-width="100px">
                        <el-form-item label="书名：">
                            <span>{{ form.book_title }}</span>
                        </el-form-item>
                        <el-form-item label="作者：">
                            <span>{{ form.author }}</span>
                        </el-form-item>
                        <el-form-item label="借阅方式：">
                            <el-select v-model="form.borrow_method" placeholder="请选择借阅方式">
                                <el-option label="On-site" value="On-site" />
                                <el-option label="Online Reservation" value="Online Reservation" />
                            </el-select>
                        </el-form-item>
                        <el-form-item label="姓名：">
                            <el-input v-model="form.borrower_name" />
                        </el-form-item>
                        <el-form-item label="地址：">
                            <el-input v-model="form.borrower_address" />
                        </el-form-item>
                    </el-form>
                    <div style="text-align: center;">
                        <el-button type="primary" @click="add">
                            提交借阅申请
                        </el-button>
                    </div>
                </div>
            </el-dialog>
        </div>
    </div>
</template>

<script>
export default {
    created() {
        this.getdata();
    },
    data() {
        return {
            tableData: [],
            dialog: false,
            form: {
                book_title: '',
                author: '',
                borrow_method: '',
                borrower_name: '',
                borrower_address: '',
            }
        }
    },
    methods: {
        getdata() {
            this.$axios.get("/api/user/books").then(res => {
                if (res.data.status === 200) {
                    this.tableData = res.data.tabledata;
                }
            });
        },
        showdia(row) {
            this.form.book_title = row.book_title;
            this.form.author = row.author;
            this.form.borrow_method = '';
            this.form.borrower_name = '';
            this.form.borrower_address = '';
            this.dialog = true;
        },
        add() {
            this.$axios.post("/api/user/borrow", this.form).then(res => {
                if (res.data.status === 200) {
                    this.$message.success("借阅申请已提交");
                    this.dialog = false;
                    this.getdata();
                }
            });
        }
    }
}
</script>

<style scoped>
.shop-container {
    height: 100%;
    display: flex;
    flex-direction: column;
}
.header {
    width: 100%;
    height: 64px; 
    text-align: center;
    line-height: 64px;
    font-size: 20px;
    font-weight: 800;
    color: #263540;
    border-bottom: 1px solid #e3e3e3;
    flex-shrink: 0; 
}
.body {
    flex: 1; /* 占据剩余的所有垂直空间 */
    width: 96%; /* 左右留一点白边，替代 margin */
    margin: 20px auto; /* 上下留白 */
    overflow: hidden; /* 禁止 wrapper 滚动，只让 table 内部滚动 */
}
</style>
