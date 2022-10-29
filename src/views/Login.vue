<template>
  <div class="w-[300px] m-auto h-full flex flex-col items-center justify-center">

    <el-input v-model="username" class="mb-2" placeholder="请输入用户名" />
    <el-input v-model="password" class="mb-2" placeholder="请输入密码" type="password" />
    <div class="flex justify-between">
      <ElButton type="primary" @click="login">登录</ElButton>
      <ElButton @click="register">注册</ElButton>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ElButton, ElMessage } from 'element-plus';
import { ref } from 'vue';
import { onBeforeRouteUpdate, useRouter } from 'vue-router';
import { useUserStore } from '../utils/db';


const username = ref('')
const password = ref('')

const userStore = useUserStore()

const router = useRouter()

async function login() {
  await userStore.login(username.value, password.value).then(() => {
    router.replace('/')
  }).catch(err => {
    ElMessage.error(err.message);
  })
}

async function register() {
  await userStore.register(username.value, password.value).then(() => {
    router.replace('/')
  }).catch(err => {
    ElMessage.error(err.message);
  })
}

</script>