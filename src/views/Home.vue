<script setup lang="ts">
import { ElInput } from 'element-plus';
import { ref } from 'vue';
import { db, Todo } from '../utils/db';

async function fetchTodos() {
	return await db.select<Todo>('todo');
}
const todoList = ref(await fetchTodos());

async function refreshTodos() {
	todoList.value = await fetchTodos();
}

const searchKeyword = ref('');
async function onCreate() {
	if (searchKeyword.value === "") return
	await db.create<Todo>("todo", {
		id: "",
		title: searchKeyword.value,
		desc: '',
		done: false,
	})
	refreshTodos();
	searchKeyword.value = "";
}

</script>

<template>
	<div class="w-[600px] p-4">

		<el-input class="mb-2" v-model="searchKeyword" placeholder="请输入新的待办事项" @keypress.enter="onCreate" />
		<div class="list">
			<el-checkbox class="!flex lh-1" v-for="todo in todoList" :key="todo.id" :value="todo.done" :label="todo.title"
				size="large" />
		</div>
	</div>
</template>

<style scoped>

</style>
