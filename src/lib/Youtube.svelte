<script>
  export let id

  let showVideo = false

  const showClick = () => { showVideo = true }
</script>

{#if showVideo}
  <img on:click={onClick} src={`http://i.ytimg.com/vi/${id}/hqdefault.jpg`} />
{#else}
  <iframe src={`https://www.youtube.com/embed/${id}?autoplay=1&autohide=1&border=0&wmode=opaque&enablejsapi=1`} />
{/if}

