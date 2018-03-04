import Vue from 'vue'
import Tickets from '../tickets.vue'
import moment from 'moment'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('ticket-container')
  const app = new Vue({
    el,
    render: h => h(Tickets)
  })
})

Vue.filter('formatDate', function(value) {
  if (value) {
    return moment(String(value)).format('M/D/YYYY')
  }
})

Vue.filter('currency', function(value) {
  try {
    var decimalValue = parseFloat(Math.round(value * 100) / 100).toFixed(2)
    return "$" + decimalValue
  } catch(error) {
    return "Unparseable"
  }
})

