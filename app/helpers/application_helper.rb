module ApplicationHelper
end
  # Helper method to format price with currency symbol
  def format_price(amount)
    number_to_currency(amount)
  end
