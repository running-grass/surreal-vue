<script setup lang="ts">
import { ElInput, ElCheckbox, ElButton } from "element-plus";
import { computed, ref } from "vue";
import { db, Todo, useUserStore } from "../utils/db";
import { nanoid } from "nanoid";
import TodoItem from "../components/TodoItem.vue";
import TodoDetail from "../components/TodoDetail.vue";

const { user, refreshUserInfo, logout } = useUserStore();

// 详情
const selectedTodoId = ref<String>();

async function fetchTodos() {
  return await db.select<Todo>("todo");
}
const todoList = ref(await fetchTodos());

async function refreshTodos() {
  todoList.value = await fetchTodos();
}

const newTodo = ref("");
async function onCreate() {
  if (newTodo.value === "") return;

  const newId = nanoid();
  await db.create<Todo>("todo", {
    id: newId,
    title: newTodo.value,
    desc: "",
    done: false,
  });
  newTodo.value = "";
  selectedTodoId.value = "todo:" + newId;
  await refreshTodos();
}

// 过滤列表
const showDone = ref(user.settings.showDone);

const filteredTodoList = computed(() => {
  if (showDone.value) {
    return todoList.value;
  } else {
    return todoList.value.filter((todo) => !todo.done);
  }
});

async function changeShowDone(showDone: any) {
  if (typeof showDone !== "boolean") {
    throw new Error("多选框的值类型错误");
  }

  await db.change(user.id, {
    settings: {
      showDone: showDone,
    },
  });

  refreshUserInfo();
}

// 删除todo
async function deleteTodo(todo: Todo) {
  const idx = todoList.value.indexOf(todo);
  if (idx !== -1) {
    todoList.value.splice(idx, 1);
  }
  await db.delete(todo.id);
}

async function saveTodoChange(todo: Todo) {
  await db.change(todo.id, todo);
}

const currentTodo = computed(() => {
  if (!selectedTodoId.value) {
    return undefined;
  }

  return filteredTodoList.value.find(
    (todo) => todo.id === selectedTodoId.value
  );
});

function onTodoClick(todo: Todo) {
  selectedTodoId.value = todo.id;
}

function clearSelected() {
  selectedTodoId.value = undefined;
}
</script>

<template>
  <div class="w-full h-full flex">
    <div class="flex-1 p-4">
      <div>
        {{ user.user }}
        <ElButton class="ml-4" @click="logout">退出</ElButton>
      </div>
      <div class="flex">
        <ElCheckbox
          label="显示已完成"
          v-model="showDone"
          @change="changeShowDone"
        />
      </div>
      <el-input
        class="mb-2"
        v-model="newTodo"
        placeholder="请输入新的待办事项"
        @keypress.enter="onCreate"
      />
      <ol class="list">
        <TodoItem
          v-for="todo in filteredTodoList"
          :key="todo.id"
          :todo="todo"
          @change="refreshTodos"
          :active="todo.id === currentTodo?.id"
          @select="onTodoClick"
        />
      </ol>
    </div>

    <TodoDetail
      class="flex-1"
      v-if="currentTodo"
      :todo="currentTodo"
      @change="saveTodoChange"
      @delete="deleteTodo"
    />
    <section v-else class="flex-1 p-4 flex flex-col"></section>
  </div>
</template>
