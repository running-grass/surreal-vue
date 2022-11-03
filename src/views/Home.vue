<script setup lang="ts">
import { ElInput, ElCheckbox, ElButton } from 'element-plus';
import { Delete } from '@element-plus/icons-vue'
import { computed, ref } from 'vue';
import { db, Todo, useUserStore, User } from '../utils/db';
import { nanoid } from 'nanoid';


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

// 更改时间


const shortcuts = [
	{
		text: 'Today',
		value: new Date(),
	},
	{
		text: 'Yesterday',
		value: () => {
			const date = new Date()
			date.setTime(date.getTime() - 3600 * 1000 * 24)
			return date
		},
	},
	{
		text: 'A week ago',
		value: () => {
			const date = new Date()
			date.setTime(date.getTime() - 3600 * 1000 * 24 * 7)
			return date
		},
	},
]

async function changeDue(todo: Todo, d: string) {
	await db.change(todo.id, {
		dueTime: d
	});

	console.log((d));
}


// 删除todo
async function deleteTodo(todo: Todo) {
	await db.query(`delete ${todo.id}`);
	refreshTodos();
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
				<li class="hover:bg-gray-100 flex items-center" v-for="todo in filteredTodoList" :key="todo.id">
					<el-checkbox class="!mr-2" v-model="todo.done" size="large" @change="done => onDone(done, todo)" />
					<el-date-picker v-model="todo.dueTime" value-format="YYYY-MM-DDTHH:mm:ssZ[Z]" type="datetime"
						@change="(d: string) => changeDue(todo, d)" placeholder="Select date and time" :shortcuts="shortcuts" />
					<div class="flex-1">{{ todo.title }}</div>
					<el-button class="!text-base !w-6 !h-6" type="danger" :icon="Delete" circle @click="() => deleteTodo(todo)" />
				</li>

			</ol>
		</div>
	</div>
</template>