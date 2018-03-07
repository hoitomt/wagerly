class Finance
  def self.amount_won(client, start_date, stop_date)
    TicketTag.joins(:ticket)
             .select("ticket_tags.*,
                     (ticket_tags.amount / tickets.amount_wagered) as ticket_percent,
                     (((ticket_tags.amount / tickets.amount_wagered) * tickets.amount_paid) + ticket_tags.amount) as won_amount")
             .where("client_id = ?
                     AND tickets.wager_date > ?
                     AND tickets.wager_date < ?
                     AND (tickets.outcome = 'won' OR tickets.outcome = 'cashed out')",
                     client.id, start_date, stop_date)
  end
end



# select t.*,
#       (tt.amount / t.amount_wagered) as ticket_percent,
#       ((tt.amount / t.amount_wagered) * t.amount_paid) as won_amount
#       from ticket_tags tt
#       join tickets t on tt.ticket_id = t.id
#       where tt.client_id = 2
#       and t.wager_date > '2017-07-01'
#       and t.wager_date < '2018-06-30'
#       and (t.outcome = 'won' OR t.outcome = 'cashed out')
#       order by t.wager_date DESC;
