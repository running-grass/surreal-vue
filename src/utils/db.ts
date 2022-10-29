import Surreal from 'surrealdb.js';
import { defineStore } from 'pinia'
import { ref } from 'vue';

const TOKEN_KEY = 'surreal_token';

const token = localStorage.getItem(TOKEN_KEY);

async function initDB() {
		const db = new Surreal('http://127.0.0.1:8000/rpc');
		// 等待连接成功
		await db.wait()

		// 如果已经登录，使用token认证，否则登录拿token
		if (token) {
			await db.authenticate(token).catch(() => {
				throw Error("登录已过期");
			})
		} else {
			const newToken = await db.signin({
				NS: 'test',
				DB: 'test',
				SC: 'allusers',
				user: 'testuser',
				pass: 'testuser',
			}).catch(err => {
				throw new Error("登录失败");
			});
			localStorage.setItem(TOKEN_KEY, newToken)		}

		await db.use('test', 'test');
		return db;
}

export const db = await initDB();

// 获取初始状态下的用户信息
async function getUserInfo () {
	const [_user] = await db.select<User>('user');
	return _user;
}
const _user = await getUserInfo();

export const useUserStore = defineStore('user', () => {
	const user = ref<User>(_user);

	const refreshUserInfo = async () => {
		user.value = await getUserInfo()
	}
  
  return { user , refreshUserInfo }
})

export type Todo = {
	id: string,
	title: string,
	desc: string,
	done: boolean	
}

export type User = {
  id: string,
  user: string,
  pass: string,
  settings: {
		showDone: boolean,
	},
}