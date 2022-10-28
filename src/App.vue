<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://vuejs.org/api/sfc-script-setup.html#script-setup
import HelloWorld from './components/HelloWorld.vue'

import Surreal from 'surrealdb.js';

const db = new Surreal('http://127.0.0.1:8000/rpc');

async function main() {

	try {
		// Signin to a scope from the browser

		let data = "no";


		data = await db.signin({
			NS: 'test',
			DB: 'test',
			SC: 'allusers',
			user: 'grass',
			pass: 'grass',
		});

		// await db.authenticate("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2NjY5NDY3MDYsIm5iZiI6MTY2Njk0NjcwNiwiZXhwIjoxNjY4MTU2MzA2LCJpc3MiOiJTdXJyZWFsREIiLCJOUyI6InRlc3QiLCJEQiI6InRlc3QiLCJTQyI6ImFsbHVzZXJzIiwiSUQiOiJ1c2VyOnphenZ4cmczenEwMmxndWVwOWRnIn0.X8FyrHvvfrT1LYgaF00tCnQ6oTgcq7r179AIve4wIj0cqI012k-3AUgON2auj-zdgpvqv899sf0n1DemckFFdA")
		console.log(data);

		await db.use('test', 'test');

		let [user]: any = await db.select("user");
		if (!user) {
			throw new Error('未登录');
		}
		console.log('res', user);

		await db.change(user.id, {
			settings: {
				marketing: "cn",
			},
			tags: ["tag","age", "test"]
		})
		let [user2]: any = await db.select("user");

		console.log(user2);
		window.db = db;

		// data = await db.query("select * from config;");
		db.create("thing", {
			title: "234"
		});


		// Select a specific namespace / database
		//  await db.use('test', 'test');

		// Create a new person with a random id
		//  let created = await db.create("person", {
		// 	 title: 'Founder & CEO',
		// 	 name: {
		// 		 first: 'Tobie',
		// 		 last: 'Morgan Hitchcock',
		// 	 },
		// 	 marketing: true,
		// 	 identifier: Math.random().toString(36).substr(2, 10),
		//  });

		//  // Update a person record with a specific id
		//  let updated = await db.change("person:jaime", {
		// 	 marketing: true,
		//  });

		//  // Select all people records
		//  let people = await db.select("person");

		//  // Perform a custom advanced query
		//  let groups = await db.query('SELECT marketing, count() FROM type::table($tb) GROUP BY marketing', {
		// 	 tb: 'person',
		//  });

	} catch (e) {

		console.error('ERROR', e);

	}

}

main();

</script>

<template>
	<div>
		<a href="https://vitejs.dev" target="_blank">
			<img src="/vite.svg" class="logo" alt="Vite logo" />
		</a>
		<a href="https://vuejs.org/" target="_blank">
			<img src="./assets/vue.svg" class="logo vue" alt="Vue logo" />
		</a>
	</div>
	<HelloWorld msg="Vite + Vue" />
</template>

<style scoped>
.logo {
	height: 6em;
	padding: 1.5em;
	will-change: filter;
}

.logo:hover {
	filter: drop-shadow(0 0 2em #646cffaa);
}

.logo.vue:hover {
	filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
