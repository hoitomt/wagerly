<template>
  <div class="card">
    <div :class="'card-header ' + resultClass(ticket)" :id="'heading-' + ticket.id">
      <a class="accordian-link" :href="'#collapse-' + ticket.id" data-toggle="collapse" :data-target="'#collapse-' + ticket.id" aria-expanded="false" :aria-controls="'collapse_' + ticket.id">
        {{ description(ticket) }}<span v-if="untaggedAmount != 0"> - ({{untaggedAmount | currency}})</span>
      </a>
      <div style="margin-top: 5px;">
        <p class="white small small-list" v-for="desc in ticket.description">
          {{ desc }}
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
                  style="margin: 0 5px 5px 0;"
                  v-on:click="tagWithClient(ticket, client)">
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
        <transition v-on:after-enter="focusInput">
          <div v-if="showCustomTagAmount" class="custom-tag-amount-container" style="margin-top: 5px;">
            <form role="form" class="form-inline" v-on:submit="submitCustomTag">
              <input type="number" step="0.01" v-model="formCustomTagAmount" ref="customTagAmountInput" class="form-control" id="tag-amount"pattern="\d*">
              <button class="btn btn-success" style="margin-left: 5px;">Submit</button>
            </form>
          </div>
        </transition>
        <p class="small float-right" style="margin: 10px 0 0 0;">
          <em>{{ticket.sb_bet_id}}</em>
        </p>
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
        formCustomTagAmount: null,
        selectedClient: {},
        showEditTagsPanel: false,
        showCustomTagAmount: false,
        showTagAmount: false,
        ticket: {}
      }
    },
    computed: {
      clients: function() {
        return this.initClients
      },
      untaggedAmount: function() {
        return (this.ticket.amount_wagered - this.amountTagged())
      }
    },
    created: function() {
      this.ticket = this.initTicket
    },
    methods: {
      amountTagged: function() {
        return this.ticket.ticket_tags.reduce(function(sum, ticketTag) {
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
        // this.$nextTick(function() {
        //   if(this.showCustomTagAmount) {
        //     card.querySelectorAll("#tag-amount")[0].focus()
        //   }
        // })
      },
      financialStatement: function(ticket) {
        if(!this.isTagged(ticket)) {
          return this.untaggedAmount(ticket)
        }
        return 0;
      },
      focusInput: function() {
        // This function is required
        // We have to wait until the DOM is updated before trying to select the input
        this.$refs.customTagAmountInput.focus()
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
      push: function(ticket) {
        return /no action/i.test(ticket.outcome)
      },
      overtagged: function(){
        return this.untaggedAmount < 0
      },
      resultClass: function(ticket) {
        if( this.won(ticket) )
          return 'bg-success'
        else if ( this.lost(ticket) )
          return 'bg-danger'
        else if ( this.push(ticket) )
          return 'bg-info'
        else
          return 'bg-warning'
      },
      submitCustomTag: function(event) {
        console.log(this.selectedClient.full_name)
        console.log(this.formCustomTagAmount)
        console.log(this.ticket.id)
        event.preventDefault();

        HTTP.post(`ticket_tags`, {
          ticket_id: this.ticket.id,
          amount: this.formCustomTagAmount,
          client_id: this.selectedClient.id
        })
        .then(response => {
          this.ticket = response.data
          this.showTagAmount = false
          this.showCustomTagAmount = false
        })
        .catch(e => {
          console.log(e)
        })
      },
      tagWithClient: function(ticket, client) {
        this.showCustomTagAmount = false
        if(this.selectedClient.id === client.id) {
          // Re-clicking the selected client, therefore unselect it
          this.selectedClient = {}
          this.showTagAmount = false
        } else {
          this.showTagAmount = true
          this.selectedClient = client
        }
      },
      undertagged: function() {
        return this.untaggedAmount > 0
      },
      won: function(ticket) {
        return /won/i.test(ticket.outcome)
      },
    }
  }
</script>
