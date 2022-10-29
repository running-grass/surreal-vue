<script setup lang="ts">
import { ElInput, ElCheckbox } from 'element-plus';
import { computed, ref } from 'vue';
import { db, Todo, useUserStore, User } from '../utils/db';

const { user, refreshUserInfo } = await useUserStore()

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

async function onDone(done: any, todo: Todo) {
	if (typeof done !== 'boolean') {
		throw new Error('多选框的值类型错误');
	}
	db.change(todo.id, {
		done,
	})
}

// 过滤列表
const showDone = ref(user.settings.showDone);

const filteredTodoList = computed(() => {
	if (showDone.value) {
		return todoList.value
	} else {
		return todoList.value.filter(todo => !todo.done)
	}
})


async function changeShowDone(showDone: any) {
	if (typeof showDone !== 'boolean') {
		throw new Error('多选框的值类型错误');
	}

	await db.change(user.id, {
		settings: {
			showDone: showDone
		}
	});

	refreshUserInfo();
}
</script>

<template>
	<div class="w-[600px] p-4">
		<div>
			{{ user?.user }}
		</div>
		<div class="flex">
			<ElCheckbox label="显示已完成" v-model="showDone" @change="changeShowDone" />
		</div>
		<el-input class="mb-2" v-model="searchKeyword" placeholder="请输入新的待办事项" @keypress.enter="onCreate" />
		<div class="list">
			<el-checkbox class="!flex lh-1 hover:bg-gray-100" v-for="todo in filteredTodoList" :key="todo.id"
				v-model="todo.done" :label="todo.title" size="large" @change="done => onDone(done, todo)" />
		</div>
	</div>
</template>