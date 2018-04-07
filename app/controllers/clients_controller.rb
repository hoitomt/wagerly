class ClientsController < ApplicationController
  before_action :authenticate_user!

  def audit
    @client = Client.find(params[:client_id])

    scope = Ticket.where("wager_date > ? and wager_date < ?", start_date, stop_date).sorted
    scope = scope.joins(:ticket_tags).where("ticket_tags.client_id = ?", @client.id)

    @tickets = scope
  end

  def index
    @clients = current_user.clients.order(:last_name)
    @untagged_tickets = Ticket.untagged
  end

  def show
    @client = Client.find(params[:id])

    limit = params[:limit] || 20
    scope = Ticket.limit(limit).sorted
    scope = scope.joins(:ticket_tags).where("ticket_tags.client_id = ?", @client.id)

    @tickets = scope
  end

  def new
    @client = Client.new
  end

  def create
    @client = current_user.clients.create(client_params)
    if @client.valid?
      redirect_to clients_path
    else
      render :new
    end
  end

  def destroy
    @client = Client.find(params[:id])
    unless @client.destroy
      flash[:error] = "There was a problem deleting #{@client.full_name}"
    end
    redirect_to clients_path
  end

  private

  def client_params
    params.require(:client).permit(:first_name, :last_name, :email)
  end
end
