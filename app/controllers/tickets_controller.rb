class TicketsController < ApplicationController
  def index
    limit = params[:limit] || 20
    scope = Ticket.limit(limit).sorted
    if params[:client_id]
      scope = scope.joins(:ticket_tags).where("ticket_tags.client_id = ?", params[:client_id])
    end

    @tickets = scope
  end

  def untagged
    @tickets = Ticket.untagged
  end

  def show
    # This is a hack to get the vuejs template to work
    # Need @tickets array to get the view to work
    @tickets = Ticket.where(id: params[:id])
    @ticket = @tickets.first
  end

  def sync
    sb = SB::SportsbookData.new(ENV['SB_USERNAME'], ENV['SB_PASSWORD'])
    tickets = sb.recent_tickets(Date.today)
    render json: {success: true}, status: 200
  end
end

