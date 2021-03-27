<script>
  import LikeCounter from '$lib/LikeCounter.svelte'

  let termsHover = false

  $: termsText = termsHover ? 'erm' : ''
  $: condsText = termsHover ? 'ondition' : ''
</script>

<nav>
  <a sveltekit:prefetch href='/'>Home</a>
  <a sveltekit:prefetch href="/podcasts">Podcasts</a>
  <a sveltekit:prefetch href="/videos">Videos</a>
</nav>

<main>
  <slot />
</main>

<footer>
  <LikeCounter />
  <div>
    <h1 on:mouseover={() => { termsHover = true }} on:mouseleave={() => { termsHover = false }}>T{termsText}s & C{condsText}s</h1>
    <p>Property of Conor & Joe.</p>
    <p>Yours to watch</p>
    <p>Any hilarity which follows watching our content belongs solely to us.</p>
    <p>Any future laughter in your life is also ours.</p>
  </div>
</footer>

<style lang="scss">
  @use "../styles/fonts";
  @use "../styles/colours";
  @use "../styles/text" as text;

  :global(body) {
    background-color: var(--palette-1);
    font-family: var(--font-main);
  }

  :global(main) {
    padding: 0 4em;
  }

  footer {
    position: fixed;
    bottom: 0;
    left: 0;
    background-color: var(--palette-4);
    width: calc(100vw - 8em);
    margin: 0;
    padding: 1em 4em;
  }

  h1 {
    @include text.title();
  }
</style>
