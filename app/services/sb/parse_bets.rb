module SB
  class ParseBets
    def self.process(ndoc)
      pb = self.new(ndoc)
      pb.parse
    end

    def initialize(ndoc)
      @ndoc = ndoc
    end

    def parse
      events.map do |event|
        heading = event.css('div.eventheading').text.try(:strip)
        time = event.css('div#time').text.try(:strip)
        polished_event = {
          heading: heading,
          time: time,
        }
        polished_event[:rows] = event_rows(event).map do |event|
          row_contents = {
            row_title: event_title(event),
            money: event.css('div.money').text.try(:strip),
            spread: event.css('div.spread').text.try(:strip),
            total: event.css('div.total').text.try(:strip),
          }
          next if row_contents[:money].blank? &&
                  row_contents[:spread].blank? &&
                  row_contents[:total].blank?
          row_contents
        end.compact
        next if polished_event[:heading].blank? && polished_event[:rows].blank?
        polished_event
      end.compact
    end

    def event_title(event)
      if event.css('span.team-title').present?
        event.css('span.team-title')
      else
        event.css('span.team')
      end.text.try(:strip)
    end

    def event_rows(event)
      if event.css('div.eventrow div.row').present?
        event.css('div.eventrow div.row')
      else
        event.css('div.row')
      end
    end

    def events
      if @ndoc.css('div.eventbox div.event').present?
        @ndoc.css('div.eventbox div.event')
      else
        @ndoc.css('div.event')
      end
    end
  end
end

# for each event
# time: ndoc.css('div.event div#time')
# for each row
# team: event.css('span.team-title')
# money: event.css('div.money')
# spread: event.css('div.spread')
# total: event.css('div.total')
