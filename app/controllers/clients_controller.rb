class ClientsController < ApplicationController
  before_action :authenticate_user!

  def audit
    @client = Client.find(params[:client_id])

    scope = Ticket.order('wager_date ASC')
    scope = scope.joins(:ticket_tags).where("ticket_tags.client_id = ?", @client.id)

    financial_transactions = @client.transactions

    @tickets = []
    balance = 0
    financial_transactions.each do |trans|
      balance += trans.amount
      @tickets << {
        'id' => nil,
        'wager_date' => trans.created_at,
        'sb_bet_id' => 'Cash',
        'outcome' => '',
        'amount' => trans.amount,
        'balance' => balance
      }
    end

    # For each ticket: create 2 transactions
    # 1. the debit transaction for the wager
    # 2. the credit/nothing transaction for the result
    scope.each do |ticket|
      ticket_amount = ticket.amount_wagered
      responsible_amount = ticket.amount_tagged_by(@client)
      summary = ticket.amount_paid.to_f * (responsible_amount.to_f/ticket_amount.to_f)

      balance -= responsible_amount
      transaction_wager = ticket.attributes
      transaction_wager['outcome'] = nil
      transaction_wager['amount'] = responsible_amount * -1
      transaction_wager['balance'] = balance
      @tickets << transaction_wager

      if ticket.outcome
        balance += summary
        transaction_result = ticket.attributes
        transaction_result['amount'] = summary
        transaction_result['balance'] = balance
        @tickets << transaction_result
      end
    end
    @tickets.reverse!
  end

  def index
    @clients = current_user.clients.order(:last_name)
    @untagged_tickets = Ticket.untagged
  end

  def show
    @client = Client.find(params[:id])

    limit = params[:limit] || 50
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
