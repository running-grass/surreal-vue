import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import { router } from './router'
import 'element-plus/dist/index.css'
import './style.css'

import AppContainer from './AppContainer.vue'
const app = createApp(AppContainer)
const pinia = createPinia()

app.use(pinia)
app.use(ElementPlus)
app.use(router)

app.mount('#app')
