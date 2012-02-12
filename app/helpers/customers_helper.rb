# encoding: utf-8

module CustomersHelper
  def formatted_customer_amount(amount)
    return '&nbsp' if amount.nil? || amount.to_f == 0
    
    number_to_currency(amount.to_f, :unit => current_user.default_currency)
  end
end
