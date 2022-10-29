import { createApp } from 'vue'
import './style.css'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

import AppContainer from './AppContainer.vue'
const app = createApp(AppContainer)
app.use(ElementPlus)
app.mount('#app')
