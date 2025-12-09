<template>
    <div>
        <div class="header">进行中任务 (处理中)</div>
        <div class="body">
            <el-table :data="tableData" border>
                <el-table-column prop="borrow_id" label="借阅编号" width="100" align="center"/>
                <el-table-column prop="book_title" label="书名" min-width="120" align="center"/>
                <el-table-column prop="borrower_phone" label="用户电话" width="150" align="center"/>
                <el-table-column prop="librarian_id" label="负责人" width="100" align="center"/>
                <el-table-column prop="assign_time" label="分配时间" width="180" align="center"/>
                
                <el-table-column label="操作" width="150" align="center">
                    <template slot-scope="scope">
                        <!-- 这里的按钮变成了“确认完成” -->
                        <el-button size="small" type="primary" @click="finishTask(scope.row)">确认已送达/取走</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </div>
    </div>
</template>

<script>
export default {
    created(){ this.load(); },
    data(){
        return{
            tableData:[]
        };
    },
    methods:{
        load(){
            // 调用我们刚写的新接口，获取 status=1 的数据
            this.$axios.get("/api/manager/processing_tasks").then(res=>{
                if(res.data.status===200){
                    this.tableData=res.data.tabledata;
                }
            });
        },
        finishTask(row){
            this.$confirm('确认该图书已交付给用户？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                // 调用完成接口
                this.$axios.post("/api/manager/finish_task", {borrow_id: row.borrow_id}).then(res=>{
                    if(res.data.status===200){
                        this.$message.success(res.data.msg);
                        this.load(); // 刷新列表
                    }
                })
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
    width: 80%;
    margin: auto;
    margin-top: 30px;
}
</style>