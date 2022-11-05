<template>
  <section class="flex flex-col p-4">
    <header class="flex items-center mb-2">
      <el-checkbox
        class="!mr-2"
        v-model="todo.done"
        size="large"
        @change="onTodoChange"
      />
      <el-date-picker
        v-model="todo.deadline"
        value-format="YYYY-MM-DDTHH:mm:ssZ[Z]"
        type="datetime"
        @change="onTodoChange"
        placeholder="截止时间"
        :shortcuts="shortcuts"
      />

      <el-dropdown class="ml-auto" @command="handleChangePriority">
        <span class="ml-auto">
          {{ priorityToText(todo.priority) }}
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item :command="undefined">无优先级</el-dropdown-item>
            <el-dropdown-item :command="1">低优先级</el-dropdown-item>
            <el-dropdown-item :command="2">高优先级</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </header>
    <header class="mb-2">
      <ElInput v-model="todo.title" @change="onTodoChange" />
    </header>
    <article class="flex-1">
      <ElInput
        type="textarea"
        :autosize="{ minRows: 4, maxRows: 20 }"
        v-model="todo.desc"
        @change="onTodoChange"
        placeholder="这里写描述"
      />
    </article>
    <footer class="flex border-t items-center pt-2">
      <div class="flex-1"></div>

      <el-button
        class="!text-base !w-6 !h-6"
        type="danger"
        :icon="Delete"
        @click="deleteTodo"
      />
    </footer>
  </section>
</template>

<script setup lang="ts">
import { Delete } from "@element-plus/icons-vue";
import { ElCheckbox, ElDatePicker, ElButton, ElInput } from "element-plus";
import { Todo, } from "../utils/db";
import { priorityToText } from '../utils/string';

interface Props {
  todo: Todo;
}

interface Emits {
  (e: "change", todo: Todo): void;
  (e: "delete", todo: Todo): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

// 选择日期的快捷方式
const shortcuts = [
  {
    text: "今天",
    value: new Date(),
  },
  {
    text: "明天",
    value: () => {
      const date = new Date();
      date.setTime(date.getTime() + 3600 * 1000 * 24);
      return date;
    },
  },
  {
    text: "一周后",
    value: () => {
      const date = new Date();
      date.setTime(date.getTime() + 3600 * 1000 * 24 * 7);
      return date;
    },
  },
];

function onTodoChange() {
  emit("change", props.todo);
}

function deleteTodo() {
  emit("delete", props.todo);
}

function handleChangePriority(priority: Todo['priority']) {
  props.todo.priority = priority
  emit("change", props.todo);
}
</script>
