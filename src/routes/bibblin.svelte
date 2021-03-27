<script>
  import PageTitle from '$lib/PageTitle.svelte'

  const episodes = []
</script>

<svelte:head>
  <title>Bibblin</title>
</svelte:head>

<PageTitle>Bibblin</PageTitle>

<h6>Listen to the podcast!</h6>

<ul>
  {#each episodes as episode}
    <li>{episode}</li>
  {/each}
</ul>
