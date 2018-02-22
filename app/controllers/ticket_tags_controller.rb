class TicketTagsController < ApplicationController
  def create
    ticket = Ticket.find(params[:ticket_id])
    ticket_tag = TicketTag.new(ticket_tag_params)
    if ticket_tag.save
      render json: ticket.as_json(include: {ticket_tags: {methods: :tag_name}, ticket_line_items: {} }), status: 200
    else
      render json: {errors: ticket_tag.errors.full_messages}, status: 422
    end
  end

  def destroy
    ticket_tag = TicketTag.find_by_id(params[:id])
    ticket = ticket_tag.ticket
    if ticket_tag && ticket_tag.destroy
      render json: ticket.as_json(include: {ticket_tags: {methods: :tag_name}, ticket_line_items: {} }), status: 200
    else
      render json: {errors: ticket_tag.errors.full_messages}, status: 422
    end
  end

  private

  def ticket_tag_params
    params.require(:ticket_tag).permit(:ticket_id, :client_id, :amount)
  end
end
