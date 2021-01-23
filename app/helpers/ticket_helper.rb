module TicketHelper
  def ticket_financial_statement(ticket)
    if !ticket.is_tagged?
      "($#{ticket.untagged_amount} untagged)"
    end
  end

  # use parantheses for negative amounts
  # use "-" for 0 amounts
  def ticket_amount_display(amount)
    if amount == 0
      return '-'
    elsif amount < 0
      return "(#{number_to_currency(amount * -1)})"
    else
      return "#{number_to_currency(amount)}"
    end
  end
end
