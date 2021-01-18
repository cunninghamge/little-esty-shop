module ApplicationHelper
  def format_date(date)
    date.strftime("%A, %B %-d, %Y")
  end

  def name(customer)
    "#{customer.first_name} #{customer.last_name}"
  end

  def format_price(price)
    number_to_currency(price / 100.0)
  end

  def discount_details(discount)
    "#{discount.percentage}% off orders of #{discount.threshold} or more"
  end
end
