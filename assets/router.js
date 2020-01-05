import Vue from 'vue'
import Router from 'vue-router'

import Home from './components/pages/Home.vue'

Vue.use(Router)

const routes = [
  {
    path: '/',
    component: Home
  },
  {
    path: '/home',
    component: Home
  }
]

export default new Router({
  routes
})
