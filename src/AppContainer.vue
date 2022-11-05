<template>
  <Suspense>
    <!-- 具有深层异步依赖的组件 -->
    <RouterView />
    <!-- 在 #fallback 插槽中显示 “正在加载中” -->
    <template #fallback> 页面正在加载中... </template>
  </Suspense>
</template>
