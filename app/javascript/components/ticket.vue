<template>
  <div class="card">
    <div :class="'card-header ' + resultClass(ticket)" :id="'heading-' + ticket.id">
      <a class="accordian-link" :href="'#collapse-' + ticket.id" data-toggle="collapse" :data-target="'#collapse-' + ticket.id" aria-expanded="false" :aria-controls="'collapse_' + ticket.id">
        {{ description(ticket) }}
      </a>
      <div style="margin-top: 5px;">
        <p class="white small small-list" v-for="ticketLineItem in ticket.ticket_line_items">
          {{ ticketLineItem.description}}
        </p>
      </div>
    </div>
    <div :id="'collapse-' + ticket.id" class="collapse" :aria-labelledby="'heading-' + ticket.id" data-parent="#accordion">
      <div class="card-body">
        <h4 class="float-left">
          {{ ticket.amount_wagered | currency }}
        </h4>
        <span style="margin: 2px 0 0 5px; vertical-align: center;">
          <small v-if="won(ticket)">won {{ ticket.amount_paid | currency }} - includes the amount wagered</small>
        </span>
        <button class="float-right btn btn-danger" v-on:click="showEditTagsPanel = !showEditTagsPanel">Edit</button>
        <div class="clearfix"></div>
        <p class="small">
          <span >Tags: </span>
          <span class="small" v-for="ticketTag in ticket.ticket_tags">
            ({{ticketTag.tag_name}} {{ticketTag.amount | currency}})
          </span>
        </p>
        <div style="margin-bottom: 5px;" v-if="showEditTagsPanel">
          <button v-for="ticketTag in ticket.ticket_tags"
                  v-on:click="deleteTag(ticketTag, ticket)"
                  class="btn btn-danger"
                  style="margin: 0 5px 5px 0;">
            {{ticketTag.tag_name}} {{ticketTag.amount | currency}}
          </button>
        </div>
        <div>
          <button v-for="client in clients"
                  :class="'btn ' + isSelectedClient(ticket, client)"
                  style="margin-right: 5px;"
                  v-on:click="tagWithClient(ticket, client)"
                  ng-class=" ? 'btn-danger' : ' btn-primary' ">
            {{client.full_name}}
          </button>
        </div>
        <div :id="'collapse-tag-amount-' + ticket.id" class="tag-amount-panel" v-if="showTagAmount" style="margin-top: 5px;">
          <button class="btn btn-success" v-on:click="createTicketTag(ticket, 5.0)">$5</button>
          <button class="btn btn-success" v-on:click="createTicketTag(ticket, 10.0)">$10</button>
          <button class="btn btn-success" v-on:click="createTicketTag(ticket, 15.0)">$15</button>
          <button class="btn btn-success" v-on:click="createTicketTag(ticket, 20.0)">$20</button>
          <button class="btn btn-success" v-on:click="enterCustomTagAmount(ticket, 0)">Custom</button>
        </div>
        <div v-if="showCustomTagAmount" class="custom-tag-amount-container" style="margin-top: 5px;">
          <form role="form" class="form-inline">
            <input class="form-control" id="tag-amount" type="text" pattern="\d*">
            <button class="btn btn-success" ng-click="submitCustomTag(ticket, $event)" style="margin-left: 5px;">Submit</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import {HTTP} from '../utils/http-common'

  export default {
    props: ['initTicket', 'initClients'],
    data: function () {
      return {
        showEditTagsPanel: false,
        showTagAmount: false,
        showCustomTagAmount: false,
        selectedClient: {},
        ticket: {}
      }
    },
    computed: {
      clients: function() {
        return this.initClients
      }
    },
    created: function() {
      this.ticket = this.initTicket
    },
    methods: {
      amountTagged: function(ticket) {
        return ticket_tags.reduce(function(sum, ticketTag) {
          return sum + ticketTag.amount
        }, 0)
      },
      createTicketTag: function(ticket, amount) {
        HTTP.post(`ticket_tags`, {
          ticket_id: ticket.id,
          amount: amount,
          client_id: this.selectedClient.id
        })
        .then(response => {
          this.ticket = response.data
          this.showTagAmount = false
        })
        .catch(e => {
          console.log(e)
        })
      },
      deleteTag: function(ticketTag, ticket) {
        HTTP.delete(`ticket_tags/` + ticketTag.id)
        .then(response => {
          console.log("Response", response)
          this.ticket = response.data
        })
        .catch(e => {
          console.log(e)
        })
      },
      description: function(ticket) {
        return ticket.wager_type +  " on " +  this.$options.filters.formatDate(ticket.wager_date)
      },
      enterCustomTagAmount: function(ticket) {
        this.showCustomTagAmount = !this.showCustomTagAmount
      },
      financialStatement: function(ticket) {
        if(!this.isTagged(ticket)) {
          return this.untaggedAmount(ticket)
        }
        return 0;
      },
      isSelectedClient: function(ticket, client) {
        var clientMatch = ticket.ticket_tags.findIndex(function(ticketTag){
          return ticketTag.client_id == client.id
        })
        if(clientMatch > -1) {
          return "btn-danger"
        } else {
          return "btn-primary"
        }
      },
      isTagged: function(ticket) {
        return this.untaggedAmount(ticket) == 0
      },
      lost: function(ticket) {
        return /lost/i.test(ticket.outcome)
      },
      resultClass: function(ticket) {
        if( this.won(ticket) )
          return 'bg-success'
        else if ( this.lost(ticket) )
          return 'bg-danger'
        else
          return 'bg-dark'
      },
      tagWithClient: function(ticket, client) {
        this.showTagAmount = !this.showTagAmount
        this.selectedClient = client
        console.log(this.selectedClient)
      },
      untaggedAmount: function(ticket) {
        return (ticket.amount_wagered - this.amountTagged(ticket))
      },
      won: function(ticket) {
        return /won/i.test(ticket.outcome)
      },
    }
  }
</script>
