class TransactionsController < ApplicationController
  before_action :find_client

  def index
    @transactions = @client.transactions.order('created_at DESC')
  end

  def new
    @transaction = @client.transactions.new
  end

  def create
    tp = transaction_params.merge({amount: transaction_amount})
    @transaction = Transaction.new(tp)
    if @transaction.save
      if transaction_amount > 0
        flash[:notice] = "#{"%5.2f" % (@transaction.amount)} has been added to #{@client.full_name}"
      else
        flash[:notice] = "#{"%5.2f" % (@transaction.amount)} has been withdrawn from #{@client.full_name}"
      end
      redirect_to client_transactions_path(@client)
    else
      render :new
    end
  end

  private
  def find_client
    @client = Client.find(params[:client_id])
  end

  def transaction_params
    params.require(:transaction).permit(:client_id, :deposit, :withdrawal)
  end

  def transaction_amount
    if params[:transaction][:deposit].present?
      params[:transaction][:deposit].to_f
    else
      -1 * params[:transaction][:withdrawal].to_f
    end
  end
end
