import Vue from 'vue'

import css from '../css/app.css'

import Home from '../components/pages/Home'

window.Vue = Vue
const app = new Vue({
  el: '#app',
  components: {
    Home
  }
})
