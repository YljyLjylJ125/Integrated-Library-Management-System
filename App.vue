<template>
  <div id="app">
    <!-- 路由占位符 -->
    <router-view></router-view>
  </div>
</template>

<script>


export default {
  name: 'App'
}
</script>

<style>
#app {
  width: 100%;
  height: 100%;
}
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  overflow: hidden; /* 禁止浏览器默认的滚动行为 */
}
</style>
