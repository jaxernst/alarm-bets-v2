import "./app.css";
import PreApp from "./PreApp.svelte";

const app = new PreApp({
  target: document.getElementById("app"),
});

export default app;
