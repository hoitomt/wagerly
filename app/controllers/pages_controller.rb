class PagesController < ApplicationController
  def index
    @untagged_tickets = Ticket.untagged
  end

  def todos
  end
end
