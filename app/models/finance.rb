class Finance

  def initialize(client, start_date, stop_date)
    @client = client
    @start_date = start_date
    @stop_date = stop_date
  end

  def summary
    transactions.to_f + amount_won.to_f - amount_wagered.to_f
  end

  def amount_lost
    amount_wagered - (amount_pending + amount_won)
  end

  def amount_pending
    @amount_pending ||= TicketTag.joins(:ticket)
             .where("tickets.outcome is null AND ticket_tags.client_id = ? AND tickets.wager_date >= ? AND tickets.wager_date <= ?", @client.id, @start_date, @stop_date)
             .sum(:amount)
  end

  def amount_wagered
    @amount_wagered ||= TicketTag.joins(:ticket)
             .where("ticket_tags.client_id = ? AND tickets.wager_date >= ? AND tickets.wager_date <= ?", @client.id, @start_date, @stop_date)
             .sum(:amount)
  end

  def transactions
    @transactions ||= @client.transactions
              .where("created_at >= ? AND created_at <= ?", @start_date, @stop_date)
              .sum(:amount)
  end

  def reload!
    @amount_wagered = nil
    @amount_pending = nil
    @amount_won = nil
    @transactions = nil
    self
  end

  def amount_won
    sql = <<-SQL
    SELECT sum((ticket_tags.amount / tickets.amount_wagered) * tickets.amount_paid)
    FROM ticket_tags
    JOIN tickets on ticket_tags.ticket_id = tickets.id
    where ticket_tags.client_id = #{@client.id}
      AND tickets.wager_date >= '#{@start_date}'
      AND tickets.wager_date <= '#{@stop_date}'
      AND tickets.outcome in ('won', 'cashed_out')
    SQL
    @amount_won ||= ActiveRecord::Base.connection.execute(sql).first['sum']
  end
end
