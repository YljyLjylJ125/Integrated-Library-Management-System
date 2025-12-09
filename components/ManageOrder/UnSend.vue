<template>
  <div class="contain">
    <div class="header">待处理借阅</div>

    <el-table :data="tableData" border style="width: 70%; margin:auto;">
      <el-table-column prop="borrow_id" label="借阅编号" width="120" align="center"/>
      <el-table-column prop="book_title" label="书名" min-width="120" align="center"/>
      <el-table-column prop="borrower_phone" label="用户电话" width="180" align="center"/>

      <el-table-column label="分配处理" width="200" align="center">
        <template slot-scope="scope">
          <el-button type="success" size="small" @click="openAssign(scope.row)">分配处理人</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分配对话框 -->
    <el-dialog title="分配图书管理员" :visible.sync="dialogAssign">
      <el-select v-model="assignName" placeholder="请选择管理员" style="width: 200px;">
        <el-option
          v-for="item in librarianList"
          :key="item.librarian_id"
          :label="item.librarian_name"
          :value="item.librarian_id"
        />
      </el-select>

      <div style="margin-top:20px; text-align:center;">
        <el-button type="primary" @click="assign">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tableData: [],
      dialogAssign: false,
      assignName: "",
      assignRow: null,
      librarianList: []
    }
  },

  created() {
    this.getPending();
    this.getLibrarian();
  },

  methods: {
    getPending() {
      this.$axios.get("/api/manager/pending_borrow").then(res => {
        if(res.data.status === 200){
          this.tableData = res.data.tabledata;
        }
      });
    },

    getLibrarian() {
      this.$axios.get("/api/manager/librarian").then(res => {
        if (res.data.status === 200) {
          this.librarianList = res.data.tabledata;
        }
      });
    },

    openAssign(row) {
      this.assignRow = row;
      this.dialogAssign = true;
    },

    assign() {
      let params = {
        borrow_id: this.assignRow.borrow_id,
        librarian_id: this.assignName,
        process_time: new Date().toLocaleString()
      };

      this.$axios.post("/api/manager/assign_borrow", params).then(res => {
        if (res.data.status === 200) {
          this.$message.success("分配成功");
          this.dialogAssign = false;
          this.getPending();
        }
      });
    }
  }
}
</script>

<style scoped>
.header {
  width: 100%;
  text-align: center;
  font-size: 22px;
  font-weight: bold;
  margin: 20px 0;
}
</style>
