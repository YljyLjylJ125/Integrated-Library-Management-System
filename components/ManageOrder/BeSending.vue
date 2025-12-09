<template>
  <div class="contain">
    <div class="header">处理中借阅</div>

    <el-table :data="tableData" border style="width: 70%; margin:auto;">
      <el-table-column prop="borrow_id" label="借阅编号" width="120" align="center"/>
      <el-table-column prop="book_title" label="书名" min-width="120" align="center"/>
      <el-table-column prop="borrower_phone" label="用户电话" width="180" align="center"/>
      <el-table-column prop="librarian_id" label="处理人ID" width="120" align="center"/>
      <el-table-column prop="process_time" label="处理时间" width="200" align="center"/>
    </el-table>
  </div>
</template>

<script>
export default {
  data(){
    return {
      tableData: []
    }
  },

  created() {
    this.getProcessing();
  },

  methods: {
    getProcessing() {
      this.$axios.get("/api/manager/borrow_log?finished=0").then(res => {
        if (res.data.status === 200) {
          this.tableData = res.data.tabledata;
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
