<template>
  <header>
    <h1>
      <a href="#"><strong>Rafael Gonzaga</strong> blog</a>
    </h1>
    <hr>
    <ul>
      <li>
        <a href="/about">About</a>
      </li>
      <li>
        <a href="/publications">Publications</a>
      </li>
      <li>
        <a href="/contact">Contact</a>
      </li>
      <li>
        <a href="/">Blog</a>
      </li>
    </ul>
  </header>
</template>

<script>
export default {

}
</script>

<style>
header {
  max-width: 45em;
  margin: 0 auto 4em auto;
  padding-top: 3em;
  text-align: center;
}

header h1 {
  font-size: 2em;
  letter-spacing: 0.2em;
  margin: 0;
}

header hr {
  border-top: 1px solid #000;
  border-right: none;
  border-bottom: none;
  border-left: none;
  margin: 1em 0;
}

header ul {
  list-style: none;
  float: right;
}

header ul li {
  float: left;
  margin-right: 0.8em;
  padding: 0 0.8em 0 0;
  border-right: 1px solid #a6ceef;
}

header ul li:last-child {
  border: none;
  padding: 0;
  margin: 0;
}

@media (max-width: 46.875em) {
  header {
    margin-bottom: 1em;
    padding-top: 1em;
  }

  header h1 {
    font-size: 1.5em;
  }

  header ul {
    float: none;
  }

  header ul li {
    display: inline;
    float: none;
  }
}

@media (max-width: 26.25em) {
  header h1 strong {
    display: block;
  }
}
</style>
