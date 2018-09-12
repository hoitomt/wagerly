module ApplicationHelper
  def display_date(date)
    date.blank? ? nil : date.strftime("%b %d, %Y")
  end
end
