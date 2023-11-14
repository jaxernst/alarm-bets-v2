<script>
	export let klass = ''
</script>

<div class={`${klass} bg-gradient-to-r from-cyan-400 to-cyan-500 rounded-xl p-2 text-cyan-100`}>
	<slot />
</div>
