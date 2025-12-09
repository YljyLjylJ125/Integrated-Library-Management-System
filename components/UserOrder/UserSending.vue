<template>
    <div>
        <div class="header">处理中借阅</div>
        <div class="body">
            <el-table :data="tableData" style="width: mid-width" border>
                <el-table-column prop="book_title" label="书名" min-width="120" align="center"/>
                <el-table-column prop="borrow_method" label="方式" width="180" align="center"/>
                <el-table-column prop="librarian_id" label="处理人编号" width="140" align="center"/>
                <el-table-column prop="process_time" label="预计处理时间" width="200" align="center"/>
            </el-table>
        </div>
    </div>
</template>

<script>
export default {
    created(){ this.getData(); },
    data(){ return{ tableData:[] }; },
    methods:{
        getData(){
            this.$axios.get("/api/user/processing_borrow").then(res=>{
                if(res.data.status===200) this.tableData=res.data.tabledata;
            });
        }
    }
}
</script>

<style scoped>
.header{text-align:center;font-size:20px;font-weight:800;padding:20px;border-bottom:1px solid #e3e3e3;}
.body{width:60%;margin:auto;margin-top:30px;}
</style>
