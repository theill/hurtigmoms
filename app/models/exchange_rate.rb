require 'open-uri'

class ExchangeRate < ActiveRecord::Base
  named_scope :latest, :conditions => ['active = ?', true]
  
  # refresh exchange rates from an external source
  def self.refresh
    # read latest currencies (excluding base which is 'DKK')
    rates = ExchangeRate.all(:conditions => ['active = ? AND currency != ?', true, 'DKK'])
    rates.each do |rate|
      # convert value using 1 DKK as a base. returns a json object such as
      # {lhs: "1 Danish krone",rhs: "0.134227323 Euros",error: "",icc: true}
      result = open("http://www.google.com/ig/calculator?q=1DKK%3D%3F#{rate.currency}").read
      conversion_rate = ActiveSupport::JSON.decode(result)["rhs"]
      conversion_rate = conversion_rate.match(/\d[\.\d+]*/)[0]
      
      if conversion_rate
        ExchangeRate.update_all(['active = ?', false], :currency => rate.currency)
        ExchangeRate.create(:currency => rate.currency, :rate => conversion_rate.to_f, :active => true)
      end
    end
  end

  def self.exchange_to(amount, from, to)
    return amount if from == to # no conversion necessary
    
    exchange_rate = ((1.0 / (EXCHANGE_RATES[to] || 1.0)) * (EXCHANGE_RATES[from] || 1.0))
    amount / exchange_rate
  end
  
end
