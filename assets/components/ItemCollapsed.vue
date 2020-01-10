<template>
  <div class="teaser">
    <h2>
      <a :href="link">{{ title }}</a>
    </h2>
    <span>{{ subtitle }}</span>

    <p>
      {{ text }}
      <br>
      <a class="more" :href="link">read more</a>
    </p>
  </div>
</template>

<script>
export default {
  props: {
    link: String,
    title: String,
    subtitle: String,
    text: String
  }
}
</script>

<style scoped>
.teaser {
    border-bottom: 1px solid #ddd;
    padding: 1.5em 0;
}

.teaser span, span.date {
    font-size: 0.9em;
    display: block;
    margin-bottom: 1.4em;
    color: #7595a4;
}

.teaser p {
    margin: 0;
}

p {
  font-size: small;
}

.more {
  font-weight: bold;
}
</style>
