<template>
  <footer>
    <span>© Rafael Gonzaga, Brasil - SP</span>
  </footer>
</template>

<script>
export default {

}
</script>

<style>
footer {
  max-width: 45em;
  margin: 0 auto;
  padding: 2.5em 0 2.5em 0;
  height: 1.8em;
}

footer span {
  float: right;
}

@media (max-width: 46.875em) {
  footer {
    padding: 1em 0;
  }

  footer span {
    padding-right: 1em;
  }
}
</style>
