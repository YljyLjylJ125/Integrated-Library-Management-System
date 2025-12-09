<template>
    <div>
        <div class="header">
            个人信息
        </div>
        <div class="body">
            <el-form ref="form" :model="form" label-width="30%" id="selectForm">
                <el-form-item label="用户名：" prop="dispatcher_id">
                    <span>{{ form.user_name }}</span>
                    <!-- <el-input v-model="form.user_name"></el-input> -->
                </el-form-item>
                <el-form-item label="真实姓名：" prop="dispatcher_name">
                    <span>{{ form.real_name }}</span>
                    <!-- <el-input v-model="form.real_name"></el-input> -->
                </el-form-item>
                <el-form-item label="年龄：" prop="dispatcher_phone">
                    <span>{{ form.age }}</span>
                    <!-- <el-input v-model="form.age"></el-input> -->
                </el-form-item>
                <el-form-item label="性别：" prop="dispatcher_phone">
                    <span>{{ form.sex }}</span>
                    <!-- <el-input v-model="form.sex"></el-input> -->
                </el-form-item>
                <el-form-item label="电话：" prop="dispatcher_phone">
                    <span>{{ form.phone }}</span>
                    <!-- <el-input v-model="form.phone"></el-input> -->
                </el-form-item>
                <el-form-item label="邮箱：" prop="dispatcher_phone">
                    <span>{{ form.mail }}</span>
                    <!-- <el-input v-model="form.mail"></el-input> -->
                </el-form-item>
            </el-form>
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
            form: {
                real_name: '',
                sex: '',
                age: '',
                mail: '',
                phone: '',
                user_name: '',
            }
        }
    },
    methods: {
        getdata() {
            const loading = this.$loading({
                lock: true,
                text: '正在获取个人信息...',
                spinner: 'el-icon-loading',
                background: 'rgba(0, 0, 0, 0.7)'
            });

            this.$axios.get("/api/user/usermsg").then((res) => {
                console.log(res.data);
                loading.close();
                if (res.data.status == 200) {
                    this.form = {
                        age: res.data.data.age,
                        mail: res.data.data.mail,
                        phone: res.data.data.phone,
                        real_name: res.data.data.real_name,
                        sex: res.data.data.sex,
                        user_name: res.data.data.user_name
                    };
                }else{
                    this.$message.error('获取信息失败：' + (res.data.message || '未知错误'));
                }

            })
            .catch((error) => {
                // 6. 网络请求失败（如超时、断网、CORS错误等）
                loading.close();
                
                // 根据错误类型给出具体提示
                if (error.response) {
                    // 服务器有响应但状态码不是2xx
                    const status = error.response.status;
                    switch(status) {
                        case 401:
                            this.$message.error('登录已过期，请重新登录');
                            // 可选：跳转到登录页
                            // this.$router.push('/login');
                            break;
                        case 403:
                            this.$message.error('没有权限访问个人信息');
                            break;
                        case 404:
                            this.$message.error('接口不存在');
                            break;
                        case 500:
                            this.$message.error('服务器内部错误');
                            break;
                        default:
                            this.$message.error('请求失败：' + status);
                    }
                } else if (error.request) {
                    // 请求已发出但没有响应（网络问题）
                    this.$message.error('网络连接失败，请检查网络');
                } else {
                    // 请求配置出错
                    this.$message.error('请求配置错误：' + error.message);
                }
                
                // 开发环境下打印错误详情
                if (process.env.NODE_ENV === 'development') {
                    console.error('请求详情：', error.config);
                }
                console.error('完整错误：', error);
            });
        }
    },
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
    width: 40%;
    /* margin: auto; */
    margin-top: 30px;
    margin-left: 30px;

}

#selectForm>>>.el-form-item__label {
    font-size: 18px;
}

span {
    font-size: 18px;
}
</style>