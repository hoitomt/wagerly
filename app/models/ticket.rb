class Ticket < ApplicationRecord
  has_many :ticket_line_items, dependent: :destroy

  has_many :ticket_tags, dependent: :destroy
  has_many :clients, through: :ticket_tags

  validates_uniqueness_of :sb_bet_id

  scope :untagged, -> {
    find_by_sql("select twt.* from (
      select t.*, sum(tt.amount) as amount_tagged
      from tickets t
      join ticket_tags tt on tt.ticket_id = t.id
      group by t.id
    ) as twt
    where amount_tagged != amount_wagered
    order by twt.wager_date DESC")
  }

  def self.search(params)
    tickets = Ticket.order('wager_date DESC')
    if params[:page].to_i > 1
      limit = params.fetch(:limit, 0).to_i
      offset = (params[:page].to_i - 1) * limit
      tickets = tickets.limit(limit).offset(offset)
    end
    tickets
  end

  def wager_date_display
    self.wager_date ? self.wager_date.strftime("%-m/%-d/%Y") : ""
  end

  def won?
    self.outcome =~ /won/i
  end

  def lost?
    self.outcome =~ /lost/i
  end

  def is_tagged?
    untagged_amount == 0
  end

  def untagged_amount
    (amount_wagered - amount_tagged).round(2)
  end

  def amount_tagged
    self.ticket_tags.inject(0){|sum, tt| sum += tt.amount}
  end

  # Save for a rainy day - Bad practice but I want to keep this knowledge

  # def self.tickets_won(client, start_date, stop_date)
  #   tickets_by_outcomes(client, start_date, stop_date, 'won', 'cashed out')
  # end

  # def self.tickets_by_outcomes(client, start_date, stop_date, *outcomes)
  #   TicketTag.joins(:ticket)
  #             .select("ticket_tags.*,
  #                 (ticket_tags.amount / tickets.amount_wagered) as ticket_percent,
  #                 ((ticket_tags.amount / tickets.amount_wagered) * tickets.amount_paid) as won_amount")
  #             .where("ticket_tags.client_id = ?
  #                 AND tickets.wager_date > ?
  #                 AND tickets.wager_date < ?
  #                 AND tickets.outcome in (?)",
  #                 client.id, start_date, stop_date, outcomes)
  # end

end
