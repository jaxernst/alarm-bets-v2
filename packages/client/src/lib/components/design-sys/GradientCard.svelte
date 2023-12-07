<script>
	export let klass = ''
	export let gradientDirection = 'bg-gradient-to-r'
</script>

<div class={`${klass} ${gradientDirection} from-cyan-400 to-cyan-500 rounded-xl p-2 text-cyan-100`}>
	<slot />
</div>
