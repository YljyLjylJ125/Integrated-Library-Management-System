<template>
    <div class="container">
        <div class="header">
            &nbsp;&nbsp; 香港城市大学（东莞）图书借阅系统
        </div>
        <div class="body">
            <!-- 左侧导航栏 -->
            <div class="liner">
                <el-menu
                    default-active="1"
                    class="el-menu-vertical-demo"
                    background-color="#283641"
                    text-color="#fff"
                    active-text-color="#ffd04b"
                    @select="handleselect"
                >
                    <el-menu-item index="1">
                        <i class="el-icon-menu"></i>
                        <span slot="title">浏览图书</span>
                    </el-menu-item>

                    <el-submenu index="2">
                        <template slot="title">
                            <i class="el-icon-reading"></i>
                            <span>我的借阅</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="3">已完成借阅</el-menu-item>
                            <el-menu-item index="4">处理中借阅</el-menu-item>
                            <el-menu-item index="5">待处理借阅</el-menu-item>
                        </el-menu-item-group>
                    </el-submenu>

                    <el-submenu index="6">
                        <template slot="title">
                            <i class="el-icon-user"></i>
                            <span>个人中心</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="7">个人信息</el-menu-item>
                            <el-menu-item index="8">修改密码</el-menu-item>
                        </el-menu-item-group>
                    </el-submenu>
                </el-menu>
            </div>

            <div class="main">
                <div v-show="active == 1" style="height: 100%;"><usershop /></div>
                <div v-show="active == 3"><userfinished /></div>
                <div v-show="active == 4"><usersending /></div>
                <div v-show="active == 5"><userunsend /></div>
                <div v-show="active == 7"><indimsg /></div>
                <div v-show="active == 8"><changepwd /></div>
            </div>
        </div>
    </div>
</template>

<script>
import usershop from '@/components/UserShop.vue'
import userfinished from '@/components/UserOrder/UserFinished.vue'
import usersending from '@/components/UserOrder/UserSending.vue'
import userunsend from '@/components/UserOrder/UserUnsend.vue'
import indimsg from '@/components/UserMsg/IndiMsg.vue'
import changepwd from '@/components/UserMsg/ChPwd.vue'

export default {
    components: {
        usershop,
        userfinished,
        usersending,
        userunsend,
        indimsg,
        changepwd,
    },
    data() {
        return { 
            active: 1 
        };
    },
    methods: {
        handleselect(index) {
            this.active = Number(index); 
        }
    },
}
</script>

<style scoped>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box; 
}
.container {
    height: 100vh;
    display: flex;
    flex-direction: column;
    overflow: hidden; 
}
.header {
    width: 100%;
    height: 60px;
    line-height: 60px;
    font-size: 25px;
    font-weight: 800;
    color: white;
    background: linear-gradient(90deg, #e76e0c, #7d0877);
    flex-shrink: 0;
}
.body {
    width: 100vw;
    flex: 1;
    display: flex;
    overflow: hidden; 
}
.liner {
    width: 250px;
    height: 100%;
    font-size: 18px;
    background-color: #283641;
    overflow-y: auto;
}
.main {
    flex: 1; 
    height: 100%;
    overflow-y: hidden; 
    background-color: #fff; 
    position: relative;
    padding: 0; 
    box-sizing: border-box; 
}

::v-deep .el-menu-item.is-active {
    background-color: #ffffff !important;
    color: #0779b6 !important;
    font-size: 16px;
}
</style>
