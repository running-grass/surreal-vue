import { createRouter, createWebHistory } from 'vue-router'

import HomeVue from './views/Home.vue'
import LoginVue from './views/Login.vue'


const routes = [
  { path: '/', component: HomeVue },
  { path: '/login', component: LoginVue }
]

export const router = createRouter({
  // 4. 内部提供了 history 模式的实现。为了简单起见，我们在这里使用 hash 模式。
  history: createWebHistory(),
  routes, // `routes: routes` 的缩写
})
