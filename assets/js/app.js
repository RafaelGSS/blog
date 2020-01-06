import Vue from 'vue'

import css from '../css/app.scss'

import HeaderLayout from '../components/layout/HeaderLayout'
import FooterLayout from '../components/layout/FooterLayout'
import Home from '../components/pages/Home'

window.Vue = Vue
const app = new Vue({
  el: '#app',
  components: {
    HeaderLayout, FooterLayout, Home
  }
})
