<script>
	import { page } from '$app/stores'

	$: selected = $page.route
	console.log(selected, $page)
</script>

<div class="flex justify-center p-4">
	<ul class="flex bg-cyan-500 rounded-full text-cyan-50 font-semibold shadow-inner">
		<li
			class={`${
				$page.route.id === '/' ? 'bg-cyan-400' : ''
			} px-4 py-2 rounded-full transition-all duration-500`}
		>
			<a href="/">Dashboard</a>
		</li>
		<li
			class={`${
				$page.route.id === '/leaderboard' ? 'bg-cyan-400' : ''
			} px-4 py-2 rounded-full transition-all duration-500`}
		>
			<a href="/leaderboard">Leaderboard</a>
		</li>
	</ul>
</div>
