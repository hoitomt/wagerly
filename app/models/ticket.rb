class Ticket < ApplicationRecord
  has_many :ticket_line_items, dependent: :destroy

  has_many :ticket_tags, dependent: :destroy
  has_many :clients, through: :ticket_tags

  validates_uniqueness_of :sb_bet_id

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
end
