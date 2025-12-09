<template>
    <div>
        <div class="header">已完成借阅处理 (待归还)</div>
        <div class="body">
            <el-table :data="tableData" border>
                <el-table-column prop="borrow_id" label="借阅编号" width="100" align="center"/>
                <el-table-column prop="book_title" label="书名" min-width="120" align="center"/>
                <el-table-column prop="borrower_phone" label="用户电话" width="150" align="center"/>
                <el-table-column prop="librarian_id" label="处理人" width="100" align="center"/>
                <el-table-column prop="process_time" label="处理时间" width="180" align="center"/>

                <el-table-column label="操作" width="150" align="center">
                    <template slot-scope="scope">
                        <el-button 
                            type="danger" 
                            size="small" 
                            icon="el-icon-finished" 
                            @click="handleReturn(scope.row)">
                            确认归还
                        </el-button>
                    </template>
                </el-table-column>

            </el-table>
        </div>
    </div>
</template>

<script>
export default {
    created(){ this.getData(); },
    data(){ 
        return{ 
            tableData:[] 
        }; 
    },
    methods:{
        getData(){
            this.$axios.get("/api/manager/borrow_log?finished=1").then(res=>{
                if(res.data.status===200) this.tableData=res.data.tabledata;
            });
        },
        handleReturn(row) {
            this.$confirm(`确认书籍《${row.book_title}》已归还？`, '归还确认', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$axios.post("/api/manager/return_book", {
                    borrow_id: row.borrow_id
                }).then(res => {
                    if (res.data.status === 200) {
                        this.$message.success(res.data.msg);
                        this.getData(); 
                    }
                });
            }).catch(() => {});
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
.body {
    width: 85%; 
    margin: auto;
    margin-top: 30px;
}
</style>
