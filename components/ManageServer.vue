<template>
    <div>
        <div class="header">
            馆内工作人员管理
        </div>
        <div class="body">
            <el-table :data="tableData" style="width: 95%" class="table">
                <el-table-column prop="staff_id" label="员工编号" width="200" align="center" />
                <el-table-column prop="staff_name" label="姓名" min-width="120" align="center" />
                <el-table-column prop="assigned_section" label="负责区域" width="200" align="center" />
                <el-table-column label="操作" width="200" align="center">
                    <template slot-scope="scope">
                        <el-button size="small" type="danger" @click="showdia_dlt(scope.row)">删除</el-button>
                    </template>
                </el-table-column>
                <el-table-column width="160" align="center">
                    <template slot="header">
                        <el-button icon="el-icon-plus" size="small" type="success" @click="showdia_add()">
                            添加工作人员
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>

            <!-- 添加工作人员 -->
            <el-dialog title="添加工作人员" :visible.sync="dia_add" width="30%">
                <el-form ref="add_form" :model="add_form" label-width="120px" :rules="add_form_rules">
                    <el-form-item label="员工编号：" prop="staff_id">
                        <el-input v-model="add_form.staff_id" />
                    </el-form-item>
                    <el-form-item label="员工姓名：" prop="staff_name">
                        <el-input v-model="add_form.staff_name" />
                    </el-form-item>
                    <el-form-item label="负责区域：" prop="assigned_section">
                        <el-input v-model="add_form.assigned_section" placeholder="如：History, Science Fiction 等" />
                    </el-form-item>
                </el-form>
                <div style="text-align: center;">
                    <el-button type="primary" @click="addStaff">添加</el-button>
                </div>
            </el-dialog>

            <!-- 删除工作人员 -->
            <el-dialog title="删除工作人员" :visible.sync="dia_dlt" width="30%">
                <div>确定删除此工作人员吗？</div>
                <div style="text-align: center;margin-top:20px;">
                    <el-button type="primary" @click="deleteStaff">确定</el-button>
                </div>
            </el-dialog>
        </div>
    </div>
</template>

<script>
export default {
    created() {
        this.getdata()
    },
    data() {
        return {
            tableData: [],
            dia_add: false,
            dia_dlt: false,
            add_form: {
                staff_id: '',
                staff_name: '',
                assigned_section: '',
            },
            want_delete: '',
            add_form_rules: {
                staff_id: [{ required: true, message: '必填项', trigger: 'blur' }],
                staff_name: [{ required: true, message: '必填项', trigger: 'blur' }],
                assigned_section: [{ required: true, message: '必填项', trigger: 'blur' }]
            }
        }
    },
    methods: {
        getdata() {
            this.$axios.get("/api/manager/staff").then(res => {
                if (res.data.status === 200) {
                    this.tableData = res.data.tabledata;
                }
            })
        },
        showdia_add() {
            this.dia_add = true;
        },
        addStaff() {
            this.$refs.add_form.validate(valid => {
                if (!valid) return;
                this.$axios.post("/api/manager/staff", this.add_form).then(res => {
                    if (res.data.status === 200) {
                        this.$message.success("添加成功");
                        this.dia_add = false;
                        this.getdata();
                    } else {
                        this.$message.error(res.data.msg || '添加失败');
                    }
                });
            });
        },
        showdia_dlt(row) {
            this.want_delete = row.staff_id;
            this.dia_dlt = true;
        },
        deleteStaff() {
            this.$axios.delete("/api/manager/staff", {
                data: { want_delete: this.want_delete }
            }).then(res => {
                if (res.data.status === 200) {
                    this.$message.success(res.data.msg || '删除成功');
                    this.getdata();
                    this.dia_dlt = false;
                }
            });
        }
    }
}
</script>

<style scoped>
.header {
    width: 100%;
    height: 10%;
    text-align: center;
    line-height: 64px;
    font-size: 20px;
    font-weight: 800;
    color: #263540;
    border-bottom: 1px solid #e3e3e3;
}
.body {
    width: 90%;
    margin: auto;
    margin-top: 30px;
}
</style>
