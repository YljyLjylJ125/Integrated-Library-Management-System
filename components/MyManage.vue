<template>
    <div class="container">
        <div class="header">
            &nbsp;&nbsp; 香港城市大学（东莞）图书借阅系统 — 后台管理
        </div>
        <div class="body">
            <!-- 左侧导航栏 -->
            <div class="liner">
                <el-menu
                    default-active="1"
                    class="el-menu-vertical-demo"
                    background-color="#283641"
                    text-color="#ffffffff"
                    active-text-color="#f6c94cff"
                    @select="handleselect"
                >
                    <el-menu-item index="1">
                        <i class="el-icon-s-management"></i>
                        <span slot="title">图书管理</span>
                    </el-menu-item>

                    <el-menu-item index="2">
                        <i class="el-icon-user-solid"></i>
                        <span slot="title">馆内工作人员</span>
                    </el-menu-item>

                    <el-menu-item index="3">
                        <i class="el-icon-s-custom"></i>
                        <span slot="title">图书管理员</span>
                    </el-menu-item>

                    <el-submenu index="10">
                        <template slot="title">
                            <i class="el-icon-s-promotion"></i>
                            <span>借阅处理</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="4">已完成处理</el-menu-item>
                            <el-menu-item index="5">处理中</el-menu-item>
                        </el-menu-item-group>
                    </el-submenu>

                    <el-submenu index="100">
                        <template slot="title">
                            <i class="el-icon-s-order"></i>
                            <span>借阅记录</span>
                        </template>
                        <el-menu-item-group>
                            <el-menu-item index="6">已完成借阅</el-menu-item>
                            <el-menu-item index="7">处理中借阅</el-menu-item>
                            <el-menu-item index="8">待处理借阅</el-menu-item>
                        </el-menu-item-group>
                    </el-submenu>
                </el-menu>
            </div>

            <div class="main">
                <div v-show="active == 1"><manageshop /></div>
                <div v-show="active == 2"><manageserver /></div>
                <div v-show="active == 3"><managedispatcher /></div>
                <div v-show="active == 4"><wuliuended /></div>
                <div v-show="active == 5"><wuliuunended /></div>
                <div v-show="active == 6"><ordersended /></div>
                <div v-show="active == 7"><ordersending /></div>
                <div v-show="active == 8"><orderunsend /></div>
            </div>
        </div>
    </div>
</template>

<script>
import manageshop from '@/components/ManageShop.vue'
import manageserver from '@/components/ManageServer.vue'
import managedispatcher from '@/components/ManageDispatcher.vue'
import wuliuended from '@/components/ManageWuliu/WuliuEnded.vue'
import wuliuunended from '@/components/ManageWuliu/WuliuUnended.vue'
import ordersended from '@/components/ManageOrder/BeSended.vue'
import ordersending from '@/components/ManageOrder/BeSending.vue'
import orderunsend from '@/components/ManageOrder/UnSend.vue'

export default {
    components: {
        manageshop,
        manageserver,
        managedispatcher,
        wuliuended,
        wuliuunended,
        ordersended,
        ordersending,
        orderunsend
    },
    data() {
        return {
            active: 1,
        }
    },
    methods: {
        handleselect(index) {
            this.active = Number(index);   // ⭐ 必须强制转数字，否则所有子页面不显示
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
