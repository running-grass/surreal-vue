import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import { router } from './router'
import './style.css'
import 'element-plus/dist/index.css'

import AppContainer from './AppContainer.vue'
import { useUserStore } from './utils/db'
const app = createApp(AppContainer)
const pinia = createPinia()

app.use(pinia)
app.use(ElementPlus)


const userStore = useUserStore()
await userStore.tryAutoLogin()
router.beforeEach((to, from) => {
  // 未登录
  if (userStore.isLogin) {
    if (to.path === '/login') {
      return '/'
    }
  } else {
    if (to.path !== '/login') {
      return '/login'
    }
  }


})

app.use(router)
app.mount('#app')
