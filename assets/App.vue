<template>
  <div>
    <header-layout/>
    <div>
      <router-view />
    </div>
    <footer-layout/>
  </div>
</template>

<script>
import HeaderLayout from './components/layout/HeaderLayout'
import FooterLayout from './components/layout/FooterLayout'

export default {
  components: {
    HeaderLayout, FooterLayout
  }
}
</script>

<style scoped>
.full-width {
  width: 100%;
}
.center-content {
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
