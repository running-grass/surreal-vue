<script setup lang="ts">
import ContextProvider from './ContextProvider.vue'
import HomeVue from './views/Home.vue';
</script>

<template>
	<Suspense>
		<!-- 具有深层异步依赖的组件 -->
		<RouterView />
		<!-- 在 #fallback 插槽中显示 “正在加载中” -->
		<template #fallback>
			正在加载中...
		</template>
	</Suspense>
</template>