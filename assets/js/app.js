import Vue from 'vue'

import css from '../css/app.scss'
import App from '../App.vue'
import router from '../router'

document.addEventListener('DOMContentLoaded', () => {
  let el = document.querySelector('#app')
  const app = new Vue({
    router,
    el: el,
    render: h => h(App)
  })
})
