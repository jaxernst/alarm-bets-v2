<script>
  import { mud } from "./mudStore";
  import MockApp from "./MockApp.svelte";
  import App from "./App.svelte";
</script>

{#if $mud}
  <App />
{:else}
  <MockApp />
{/if}
