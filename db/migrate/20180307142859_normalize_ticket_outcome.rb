class NormalizeTicketOutcome < ActiveRecord::Migration[5.1]
  def change
    Ticket.where(outcome: 'Cashed Out').update_all(outcome: 'cashed out')
    Ticket.where(outcome: 'Wager Lost').update_all(outcome: 'lost')
    Ticket.where(outcome: 'Wager Won').update_all(outcome: 'won')
    Ticket.where(outcome: 'Won').update_all(outcome: 'won')
    Ticket.where(outcome: 'Lost').update_all(outcome: 'lost')
    Ticket.where(outcome: 'No Action').update_all(outcome: 'no action')
    Ticket.where(outcome: 'Action').update_all(outcome: 'no action')
  end
end
