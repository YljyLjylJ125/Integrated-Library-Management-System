<template>
  <div class="container">
    <div class="header">
      图书管理
    </div>

    <div class="body">
      <el-button type="primary" @click="dialog_add = true" style="margin-bottom: 15px;">
        新增图书
      </el-button>

      <el-table 
        :data="tableData" 
        border 
        style="width: 100%;"
        height="80%"
      >
        <el-table-column prop="book_title" label="书名" width="220" align="center"/>
        <el-table-column prop="author" label="作者" width="200" align="center"/>
        <el-table-column prop="price" label="价格" width="100" align="center"/>
        <el-table-column prop="total_borrowed" label="借阅次数" width="120" align="center"/>

        <el-table-column prop="description" label="简介" min-width="200" show-overflow-tooltip align="center" />

        <el-table-column label="操作" width="160" align="center">
          <template slot-scope="scope">
            <el-button type="warning" size="small" @click="show_edit(scope.row)">修改</el-button>
            <el-button type="danger" size="small" @click="del(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 图书对话框 -->
    <el-dialog title="新增图书" :visible.sync="dialog_add" width="30%">
      <el-form :model="add_form" label-width="100px">
        <el-form-item label="书名">
          <el-input v-model="add_form.book_title"></el-input>
        </el-form-item>

        <el-form-item label="作者">
          <el-input v-model="add_form.author"></el-input>
        </el-form-item>

        <el-form-item label="价格">
          <el-input v-model="add_form.price"></el-input>
        </el-form-item>

        <el-form-item label="借阅次数">
          <el-input v-model="add_form.total_borrowed"></el-input>
        </el-form-item>

        <el-form-item label="简介">
          <el-input type="textarea" :rows="4" v-model="add_form.description"></el-input>
        </el-form-item>
      </el-form>

      <div style="text-align:center;">
        <el-button type="primary" @click="add">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 修改图书 -->
    <el-dialog title="修改图书信息" :visible.sync="dialog_edit" width="30%">
      <el-form :model="edit_form" label-width="100px">
        <el-form-item label="书名">
          <el-input v-model="edit_form.book_title" disabled></el-input>
        </el-form-item>

        <el-form-item label="作者">
          <el-input v-model="edit_form.author"></el-input>
        </el-form-item>

        <el-form-item label="价格">
          <el-input v-model="edit_form.price"></el-input>
        </el-form-item>

        <el-form-item label="借阅次数">
          <el-input v-model="edit_form.total_borrowed"></el-input>
        </el-form-item>

        <el-form-item label="简介">
          <el-input type="textarea" :rows="4" v-model="edit_form.description"></el-input>
        </el-form-item>
      </el-form>

      <div style="text-align:center;">
        <el-button type="primary" @click="edit">确 定</el-button>
      </div>
    </el-dialog>
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

      dialog_add: false,
      dialog_edit: false,

      add_form: {
        book_title: "",
        author: "",
        price: "",
        total_borrowed: "",
        description: "",
      },

      edit_form: {
        book_title: "",
        author: "",
        price: "",
        total_borrowed: "",
        description: "",
      },
    };
  },

  methods: {
    // ==================== 获取图书列表 ====================
    getdata() {
      this.$axios.get("/api/manager/book").then((res) => {
        if (res.data.status == 200) {
          this.tableData = res.data.tabledata;
        }
      });
    },

    // ==================== 新增 ====================
    add() {
      const params = {
        action: "add",
        ...this.add_form,
        price: Number(this.add_form.price),
        total_borrowed: Number(this.add_form.total_borrowed),
      };

      this.$axios.post("/api/manager/book", params).then((res) => {
        if (res.data.status == 200) {
          this.$message.success(res.data.msg);
          this.dialog_add = false;
          this.getdata();
        }
      });
    },

    // ==================== 显示修改窗口 ====================
    show_edit(row) {
      this.dialog_edit = true;
      this.edit_form = JSON.parse(JSON.stringify(row));
    },

    // ==================== 修改 ====================
    edit() {
      const sql = `UPDATE book SET 
        author="${this.edit_form.author}",
        price=${Number(this.edit_form.price)},
        total_borrowed=${Number(this.edit_form.total_borrowed)},
        description="${this.edit_form.description}"
        WHERE book_title="${this.edit_form.book_title}"
      `;

      this.$axios.post("/api/manager/sql", { sql }).then((res) => {
        if (res.data.status == 200) {
          this.$message.success("修改成功");
          this.dialog_edit = false;
          this.getdata();
        }
      });
    },

    // ==================== 删除 ====================
    del(row) {
      this.$axios
        .delete("/api/manager/book", { data: { book_title: row.book_title } })
        .then((res) => {
          if (res.data.status == 200) {
            this.$message.success(res.data.msg);
            this.getdata();
          }
        });
    },
  },
};
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
