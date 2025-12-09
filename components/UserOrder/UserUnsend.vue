<template>
    <div>
        <div class="header">未处理借阅</div>
        <div class="body">
            <el-table :data="tabledata" style="width: 100%" border>
                <el-table-column prop="book_title" label="书名" width="200" align="center"/>
                <el-table-column prop="borrow_method" label="借阅方式" min-width="120" align="center"/>
                <el-table-column prop="borrow_time" label="借阅时间" width="200" align="center"/>
                <el-table-column prop="borrower_name" label="借阅人姓名" width="120" align="center"/>
                <el-table-column prop="borrower_address" label="地址" width="100" align="center"/>
                
                <el-table-column label="操作" width="220" align="center">
                    <template slot-scope="scope">
                        <el-button size="small" type="success" @click="edit(scope.row)">修改</el-button>
                        <el-button size="small" type="danger" @click="remove(scope.row)">取消</el-button>
                    </template>
                </el-table-column>
            </el-table>

            <el-dialog title="修改借阅信息" :visible.sync="dialog_edit" width="30%">
                <el-form :model="form_edit" label-width="100px">
                    <el-form-item label="借阅人姓名">
                        <el-input v-model="form_edit.borrower_name"/>
                    </el-form-item>
                    <el-form-item label="借阅地址">
                        <el-input v-model="form_edit.borrower_address"/>
                    </el-form-item>
                </el-form>

                <div style="text-align:center;">
                    <el-button type="primary" @click="doEdit">确认修改</el-button>
                </div>
            </el-dialog>

            <el-dialog title="取消借阅" :visible.sync="dialog_delete" width="30%">
                <div>确认取消该借阅申请？</div>
                <div style="text-align:center;">
                    <el-button type="primary" @click="doDelete">确定</el-button>
                </div>
            </el-dialog>
        </div>
    </div>
</template>

<script>
export default {
    created() { this.getData(); },
    data() {
        return {
            tabledata: [],
            dialog_edit: false,
            dialog_delete: false,
            form_edit: {
                borrow_id: '',
                borrower_name: '',
                borrower_address: ''
            },
            delete_id: ''
        }
    },
    methods: {
        getData() {
            this.$axios.get("/api/user/pending_borrow").then(res => {
                if (res.data.status === 200) this.tabledata = res.data.tabledata;
            });
        },
        edit(row) {
            this.form_edit.borrow_id = row.borrow_id;
            this.form_edit.borrower_name = row.borrower_name;
            this.form_edit.borrower_address = row.borrower_address;
            this.dialog_edit = true;
        },
        doEdit() {
            this.$axios.post("/api/user/pending_borrow", this.form_edit).then(res => {
                if (res.data.status === 200) {
                    this.$message.success(res.data.msg);
                    this.dialog_edit = false;
                    this.getData();
                }
            })
        },
        remove(row) {
            this.delete_id = row.borrow_id;
            this.dialog_delete = true;
        },
        doDelete() {
            this.$axios.delete("/api/user/pending_borrow", {data:{delete_id:this.delete_id}}).then(res=>{
                if(res.data.status===200){
                    this.$message.success(res.data.msg);
                    this.dialog_delete=false;
                    this.getData();
                }
            })
        }
    }
}
</script>

<style scoped>
.header {
    text-align:center;font-size:20px;font-weight:800;padding:20px;border-bottom:1px solid #e3e3e3;
}
.body { width:85%; margin:auto; margin-top:30px; }
</style>
