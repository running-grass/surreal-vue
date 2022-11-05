<template>
  <li :class="containerClass" @click="emit('select', todo)">
    <el-checkbox
      class="!mr-2"
      v-model="todo.done"
      size="large"
      @change="onDone"
    />
    <div class="flex-1">{{ todo.title }}</div>
  </li>
</template>
<script setup lang="ts">
import { computed, defineProps } from "vue";
import { db, Todo } from "../utils/db";

interface Props {
  todo: Todo;
  active?: boolean;
}

interface Emits {
  (e: "change", todo: Todo): void;
  (e: "delete", todo: Todo): void;
  (e: "select", todo: Todo): void;
  (e: "done", todo: Todo): void;
}
const props = defineProps<Props>();
const emit = defineEmits<Emits>();

const containerClass = computed(() => {
  let append = "";
  if (props.active) {
    append = " bg-gray-200";
  }
  return "hover:bg-gray-100 flex items-center cursor-pointer" + append;
});

async function onDone(done: any) {
  if (typeof done !== "boolean") {
    throw new Error("多选框的值类型错误");
  }
  await db.change(props.todo.id, {
    done,
  });

  emit("done", props.todo);
  emit("change", props.todo);
}
</script>
