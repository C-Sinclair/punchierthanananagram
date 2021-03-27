<script lang="ts">
  import PageTitle from '$lib/PageTitle.svelte'

</script>

<svelte:head>
  <title>PunchierThanAnAnagram</title>
</svelte:head>

<PageTitle>Punchier Than An Anagram</PageTitle>

<p>A comedy duo of epic proportions</p>

<div>
  <h2>You've probably heard of their hilarious projects, here's some notable highlights</h2>
  <ul>
    <li>
      <a href='/bibblin'>Bibblin</a>
    </li>
  </ul>
</div>

<style lang="scss">
  @use "../styles/text" as text;

  h1 {
    @include text.title(3.5em);
    text-decoration: underline;
  }
</style>
