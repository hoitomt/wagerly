<template>
  <div id="accordion">
    <ticket v-for="ticket in initTickets" :key="ticket.id" :initTicket="ticket" :initClients="initClients"></ticket>
  </div>
</template>

<script>
import Ticket from './components/ticket'

export default {

  components: {
    'ticket': Ticket
  },
  data: function () {
    return {
      message: "Tickets",
      showEditTagsPanel: false,
      showTagAmount: false,
      showCustomTagAmount: false,
    }
  },
  computed: {
    initTickets: function() {
      let domTickets = $('#ticket-container').data('tickets')
      console.log(domTickets)
      return domTickets
    },
    initClients: function() {
      let domClients = $('#ticket-container').data('clients')
      console.log(domClients)
      return domClients
    }
  }
}
</script>
