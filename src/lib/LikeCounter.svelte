<script lang="ts">
	let count: number = 0;

	const increment = () => {
		count += 1;
	};
</script>

<button on:click={increment}>
	Likes {count}
</button>

<style lang="scss">
  @use '../styles/buttons' as btn;

  button {
    background-color: var(--palette-7);
    @include btn.button-border;
    position: absolute;
    right: 2em;
    top: -10px;
	}

	button:hover {
		background-color: var(--palette-9);
    cursor: pointer;
	}
</style>
