<template>
  <div class="changepwd-container">
    <el-card class="box-card">
      <h2>修改密码</h2>
      <el-form :model="form" :rules="form_rules" ref="form" label-width="100px">
        
        <el-form-item label="原密码" prop="old_pwd">
          <el-input v-model="form.old_pwd" show-password></el-input>
        </el-form-item>

        <el-form-item label="新密码" prop="new_pwd">
          <el-input v-model="form.new_pwd" show-password></el-input>
        </el-form-item>

        <el-form-item label="确认密码" prop="check_pwd">
          <el-input v-model="form.check_pwd" show-password></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="change">确定修改</el-button>
        </el-form-item>

      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        old_pwd: "",
        new_pwd: "",
        check_pwd: "",
      },
      form_rules: {
        old_pwd: [{ required: true, message: "请输入原密码", trigger: "blur" }],
        new_pwd: [{ required: true, message: "请输入新密码", trigger: "blur" }],
        check_pwd: [{ required: true, message: "请确认密码", trigger: "blur" }],
      },
    };
  },

  methods: {
    change() {
      this.$refs.form.validate((valid) => {
        if (!valid) return;

        if (this.form.new_pwd !== this.form.check_pwd) {
          this.$message.error("两次输入的新密码不一致");
          return;
        }

        this.$axios.post("/api/user/pwd_chg", this.form).then((res) => {
          if (res.data.status === 200) {
            this.$message.success("密码修改成功");
          } else {
            this.$message.error(res.data.msg);
          }
        });
      });
    },
  },
};
</script>

<style scoped>
.changepwd-container {
  width: 60%;
  margin: 30px auto;
}
.box-card {
  padding: 20px;
}
</style>
