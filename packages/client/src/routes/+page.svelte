<script lang="ts">
	import { mud } from '$lib/mud/mudStore';
	import MockApp from '$lib/MockApp.svelte';
	$: console.log($mud);
</script>

<MockApp />
