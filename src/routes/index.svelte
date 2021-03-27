<script lang="ts">
  import PageTitle from '$lib/PageTitle.svelte'

  const links = [{ 
    name: 'Bibblin',
    path: 'bibblin',
    id: 'YctTVbP99nU',
  }, {
    name: 'Poor Fingerless Urchins',
    path: 'poor-fingerless-urchins',
    id: 'Re8b69pPTjs',
  }, {
    name: 'Catalogued',
    path: 'catalogued',
    id: 'dvvemBl3p4A',
  }, {
    name: "Films We Haven't Seen",  
    path: 'films-we-no-see',
    id: 'r0H0g5qL2I0'
  }]
</script>

<svelte:head>
  <title>PunchierThanAnAnagram</title>
</svelte:head>

<PageTitle>Punchier Than An Anagram</PageTitle>

<p>A comedy duo of epic proportions</p>

<div>
  <h2>You've probably heard of their hilarious projects, here's some notable highlights</h2>
  <ul>
    {#each links as { name, id, path }}
    <li>
      <a sveltekit:preload href={`/${path}`}>
        <h4>{name}</h4>
        <img src={`http://i.ytimg.com/vi/${id}/hqdefault.jpg`} />
      </a>
    </li>
    {/each}
  </ul>
</div>

<style lang="scss">
  @use "../styles/text" as text;

  h1 {
    @include text.title(3.5em);
    text-decoration: underline;
  }

  ul {
    list-style: none;
    padding: 0;
  }

  li {
    background-color: var(--palette-3);
    border-radius: .5em;
    padding: 1em 2em;
    margin-bottom: 2em;
    height: 8em;

    a {
      position: relative;
      text-decoration: none;
      color: white;
      width: 100%;
      height: 100%;
      display: block;
    }

    h4 {
      margin: 0;
      padding-left: 6em;
      font-size: 1.5em;
    }

    img {
      width: 10em;
      height: 10em;
      object-fit: cover;
      position: absolute;
      border-radius: 1em;
      left: -3em;
      top: 0;
      border: 3px solid var(--palette-10);
    }
  }
</style>
