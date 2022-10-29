
import Surreal from 'surrealdb.js';

async function initDB() {
		const db = new Surreal('http://127.0.0.1:8000/rpc');
		const user = await db.signin({
			NS: 'test',
			DB: 'test',
			SC: 'allusers',
			user: 'testuser',
			pass: 'testuser',
		}).catch(err => {
			throw new Error("登录失败");
		});

		await db.use('test', 'test');

		return db;
}

export const db = await initDB();

export type Todo = {
	id: string,
	title: string,
	desc: string,
	done: boolean	
}

export type user = {
  id: string,
  user: string,
  pass: string,
  settings: object,
}