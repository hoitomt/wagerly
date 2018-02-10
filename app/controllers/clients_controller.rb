class ClientsController < ApplicationController
  def index
    @clients = current_user.clients.order(:last_name)
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.create(client_params)
    if @client.valid?
      redirect_to clients_path
    else
      render :new
    end
  end

  private

  def client_params
    params.require(:client).permit(:first_name, :last_name, :email)
  end
end
