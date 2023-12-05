<script lang="ts">
	import { slide } from 'svelte/transition'

	export let open = false

	// Open the card when clicked inside, close when clicked outside
	function openOnChildClick(node: HTMLElement) {
		const handleFocusIn = (e: MouseEvent) => {
			open = node.contains(e.target as Node)
		}

		document.addEventListener('click', handleFocusIn)
		return {
			destroy: () => {
				document.removeEventListener('click', handleFocusIn)
			}
		}
	}
</script>

<div use:openOnChildClick class="p-3 flex flex-col text-lg bg-zinc-100 text-zinc-400 rounded-lg">
	<div class="cursor-pointer">
		<slot name="header" />
	</div>

	{#if open}
		<div transition:slide>
			<div class="py-2 w-full">
				<div class="border-[.5px] w-full border-zinc-200" />
			</div>
			<div class="flex flex-col gap-2 p-1">
				<div class="p-2">
					<div class="p-2 rounded-lg bg-zinc-200 whitespace-normal">
						<slot name="description" />
					</div>
				</div>
				<slot name="details" />
			</div>
		</div>
	{/if}
</div>
