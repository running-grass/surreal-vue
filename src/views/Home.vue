<script setup lang="ts">
import { ElInput, ElCheckbox, ElButton } from 'element-plus';
import { Delete } from '@element-plus/icons-vue'
import { computed, ref } from 'vue';
import { db, Todo, useUserStore, User } from '../utils/db';
import { nanoid } from 'nanoid';
import TodoItem from '../components/TodoItem.vue';


const { user, refreshUserInfo, logout } = useUserStore()

async function fetchTodos() {
	return await db.select<Todo>('todo');
}
const todoList = ref(await fetchTodos());

async function refreshTodos() {
	todoList.value = await fetchTodos();
}

const newTodo = ref('');
async function onCreate() {
	if (newTodo.value === "") return
	await db.create<Todo>("todo", {
		id: nanoid(),
		title: newTodo.value,
		desc: '',
		done: false,
	})
	refreshTodos();
	newTodo.value = "";
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
	<div class="w-full">

		<div class="w-[600px] p-4">
			<div>
				{{ user.user }}
				<ElButton class="ml-4" @click="logout">退出</ElButton>
			</div>
			<div class="flex">
				<ElCheckbox label="显示已完成" v-model="showDone" @change="changeShowDone" />
			</div>
			<el-input class="mb-2" v-model="newTodo" placeholder="请输入新的待办事项" @keypress.enter="onCreate" />
			<ol class="list">
				<TodoItem v-for="todo in filteredTodoList" :key="todo.id" :todo="todo" @change="refreshTodos" />
			</ol>
		</div>
	</div>
</template>