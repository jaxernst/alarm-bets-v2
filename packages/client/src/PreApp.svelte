<script>
  import { mud } from "./mudStore"
  import App from "./App.svelte"
</script>

{#if $mud}
  <App />
{:else}
  Loading Alarm Bets...
{/if}
