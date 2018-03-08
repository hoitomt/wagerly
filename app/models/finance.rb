class Finance

  def initialize(client, start_date, stop_date)
    @client = client
    @start_date = start_date
    @stop_date = stop_date
  end

  def tickets_won
    tickets_by_outcomes('won', 'cashed out')
  end

  def amount_won
    sql = <<-SQL
    SELECT sum((ticket_tags.amount / tickets.amount_wagered) * tickets.amount_paid)
    FROM ticket_tags
    JOIN tickets on ticket_tags.ticket_id = tickets.id
    where ticket_tags.client_id = #{@client.id}
      AND tickets.wager_date > '#{@start_date}'
      AND tickets.wager_date < '#{@stop_date}'
      AND tickets.outcome in ('won', 'cashed_out')
    SQL
    ActiveRecord::Base.connection.execute(sql).first['sum']
  end

  def tickets_by_outcomes(*outcomes)
    TicketTag.joins(:ticket)
              .select("ticket_tags.*,
                  (ticket_tags.amount / tickets.amount_wagered) as ticket_percent,
                  ((ticket_tags.amount / tickets.amount_wagered) * tickets.amount_paid) as won_amount")
              .where("ticket_tags.client_id = ?
                  AND tickets.wager_date > ?
                  AND tickets.wager_date < ?
                  AND tickets.outcome in (?)",
                  @client.id, @start_date, @stop_date, outcomes)
  end
end
