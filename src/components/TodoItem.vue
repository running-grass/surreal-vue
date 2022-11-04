<template>
	<li class="hover:bg-gray-100 flex items-center">
		<el-checkbox class="!mr-2" v-model="todo.done" size="large" @change="onDone" />
		<el-date-picker v-model="todo.deadline" value-format="YYYY-MM-DDTHH:mm:ssZ[Z]" type="datetime" @change="changeDue"
			placeholder="Select date and time" :shortcuts="shortcuts" />
		<div class="flex-1">{{ todo.title }}</div>
		<el-button class="!text-base !w-6 !h-6" type="danger" :icon="Delete" circle @click="deleteTodo" />
	</li>
</template>
<script setup lang="ts">
import { defineProps } from 'vue';
import { Delete } from '@element-plus/icons-vue'

import { db, Todo } from '../utils/db';

interface Props {
	todo: Todo
}

interface Emits {
	(e: 'change', id: string): void
	(e: 'delete', id: string): void
	(e: 'done', id: string): void
}
const { todo } = defineProps<Props>();
const emit = defineEmits<Emits>()

const shortcuts = [
	{
		text: '今天',
		value: new Date(),
	},
	{
		text: '明天',
		value: () => {
			const date = new Date()
			date.setTime(date.getTime() + 3600 * 1000 * 24)
			return date
		},
	},
	{
		text: '一周后',
		value: () => {
			const date = new Date()
			date.setTime(date.getTime() + 3600 * 1000 * 24 * 7)
			return date
		},
	},
]

async function changeDue(d: string) {
	await db.change(todo.id, {
		dueTime: d
	});
	emit('change', todo.id)
}


// 删除todo
async function deleteTodo() {
	await db.query(`delete ${todo.id}`);
	emit('delete', todo.id)
	emit('change', todo.id)

}


async function onDone(done: any) {
	if (typeof done !== 'boolean') {
		throw new Error('多选框的值类型错误');
	}
	await db.change(todo.id, {
		done,
	})

	emit('done', todo.id)
	emit('change', todo.id)


}


</script>