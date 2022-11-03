import Surreal from 'surrealdb.js';
import { defineStore } from 'pinia'
import { computed, ref } from 'vue';

const TOKEN_KEY = 'surreal_token';

export const db = new Surreal( location.origin + '/rpc');

// window.__db = db;


async function initDB() {
	// 等待连接成功
	await db.wait()
	await db.use('test', 'test');
	return db;
}

export const initDBWating = initDB();	


// 获取初始状态下的用户信息
async function getUserInfo() {
	const _user : User = await db.info() //<User>('user');
	return _user || null;
}

export const useUserStore = defineStore('user', () => {
	const mock = {
		id: "unlogin",
		pass: "mock",
		user: 'mock',
		settings: {
			showDone: true,
		},
	};

	const user = ref<User>(mock);

	const isLogin = computed(() => {
		return user.value.id !== 'unlogin';
	})
	// 刷新登录信息
	const refreshUserInfo = async () => {
		user.value = await getUserInfo()
	}

	const tryAutoLogin = async () => {
		const token = localStorage.getItem(TOKEN_KEY);
		// 如果已经登录，使用token认证，否则登录拿token
		if (!token) {
			return false
		}
		await db.authenticate(token).then(async () => {
			await refreshUserInfo()
			return true
		}).catch(() => {
			console.warn("登录已过期");
			return false
		})
	}

	const logout = async () => {
		db.close()
		user.value = mock
		localStorage.removeItem(TOKEN_KEY)

		location.reload()
	}

	const login = async (username: string, password: string) => {
		const newToken = await db.signin({
			NS: 'test',
			DB: 'test',
			SC: 'allusers',
			user: username,
			pass: password,
		}).catch(err => {
			throw new Error("登录失败");
		});
		localStorage.setItem(TOKEN_KEY, newToken)
		await refreshUserInfo()
	}

	async function register(username: string, password: string){
		const newToken = await db.signup({
			NS: 'test',
			DB: 'test',
			SC: 'allusers',
			user: username,
			pass: password,
		}).catch(err => {
			throw new Error("注册失败");
		});
		localStorage.setItem(TOKEN_KEY, newToken)
		await refreshUserInfo()
	}

	return {
		user,
		isLogin,
		refreshUserInfo,
		logout,
		login,
		register,
		tryAutoLogin
	}
})

export type Todo = {
	id: string,
	title: string,
	desc: string,
	done: boolean,
	dueTime?: string,
}

export type User = {
	id: string,
	user: string,
	pass: string,
	settings: {
		showDone: boolean,
	},
}