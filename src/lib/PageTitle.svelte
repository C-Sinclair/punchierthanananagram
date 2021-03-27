<h1><slot /></h1>

<style lang="scss">
  @use "../styles/text" as text;

  h1 {
    @include text.title(3.5em);
    text-decoration: underline;
  }
</style>
