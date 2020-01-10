<template>
  <main>
    <section v-for="post in posts" :key="post.link">
      <item-collapsed :link="post.link" :title="post.title" :subtitle="post.subtitle" :text="post.text" />
    </section>
  </main>
</template>

<script>
import ItemCollapsed from '../ItemCollapsed';

export default {
  components: {
    ItemCollapsed
  },
  data: () => ({
    posts: [
      {
        link: '#',
        title: 'Video course on efficient enterprise testing',
        subtitle: 'thursday, january 09, 2020',
        text: `
          I’ve created a few videos on the topic of effective enterprise testing.
          I still see a huge importance in this topic in real-world projects.
          Here are my experiences in testing Enterprise Java projects together with some examples. 
        `
      }
    ]
  })
};
</script>

<style>
main {
  color: #333;
  max-width: 45em;
  margin: 0 auto;
  padding: 1em;
}

main a {
  font-family: 'Monospaced', monospace;
  font-size: 0.9em;
}

main ul {
  padding-left: 1em;
}

main ul li p {
  margin: 0;
  vertical-align: text-top;
  text-align: left;
}

main h3:first-child {
  margin-top: 1em;
}

main h2 a, main h3 a {
  font-family: 'SourceSerifPro', serif;
  font-size: 1em;
}
</style>
