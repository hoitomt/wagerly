module TicketHelper
  def ticket_financial_statement(ticket)
    if !ticket.is_tagged?
      "($#{ticket.untagged_amount} untagged)"
    end
  end
end
