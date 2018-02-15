class TicketsController < ApplicationController
  def index
    limit = params[:limit] || 20
    scope = Ticket.includes(:ticket_line_items).limit(limit).order('wager_date DESC')
    if params[:client_id]
      scope = scope.joins(:ticket_tags).where("ticket_tags.client_id = ?", params[:client_id])
    end

    @tickets = scope
  end
end

