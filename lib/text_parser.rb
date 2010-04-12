class TextParser

  def guess_date(body)
    t = body.scan(/date:\W?(\d{4}-\d{2}-\d{2})/i).flatten
    if (t.length > 0)
      date = t[0].to_datetime rescue nil
    end
    return date unless date.nil?
    
    t = body.scan(/date:\W?(.*)/i).flatten
    if (t.length > 0)
      date = t[0].to_datetime rescue nil
    end
    return date unless date.nil?
    
    nil
  end
  
  def guess_amount(body)
    # explicit dollar symbol
    parsed_amount = body.scan(/amount:?\W?\$\W?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 0)
    return [amount, 'USD'] if amount.present?
    
    parsed_amount = body.scan(/amount:?\W?\$?\W?([\d|\.|\,]*)\W?(DKK|USD|GBP|NOK|SEK|EUR)?/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 0)
    currency = (parsed_amount[1] if parsed_amount.length > 1)
    return [amount, currency] if amount.present? #&& currency

    parsed_amount = body.scan(/[^sub]total:?\W?\$?([\d|\.|\,]*)\W?(kr\.?|$|DKK|USD|GBP|NOK|SEK|EUR)?/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 0)
    currency = (parsed_amount[1] if parsed_amount.length > 1)
    return convert_localized_currency(amount, currency) if amount.present? && currency.present?
    
    parsed_amount = body.scan(/[^sub]total:?\W?(\$|kr\.?)?\W?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[1] if parsed_amount.length > 1)
    currency = (parsed_amount[0] if parsed_amount.length > 0)
    return convert_localized_currency(amount, currency) if amount.present? && currency.present?

    # e.g. ..nt *:0.00Totals:31.00*  The rec...
    parsed_amount = body.scan(/totals:?\W?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 0)
    currency = 'USD'
    return convert_localized_currency(amount, currency) if amount.present? && currency.present?
    
    # e.g. ...kr.750,00Ialtkr.3.750,00NoterAn...
    parsed_amount = body.scan(/I\W?alt:?\W?(kr\.|DKK|USD|GBP|NOK|SEK|EUR)\W?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[1] if parsed_amount.length > 1)
    currency = (parsed_amount[0] if parsed_amount.length > 0)
    return convert_localized_currency(amount, currency) if amount.present? && currency.present?
    
    parsed_amount = body.scan(/[^del]beløb:?\W?(kr\.)\W?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[1] if parsed_amount.length > 1)
    currency = (parsed_amount[0] if parsed_amount.length > 0)
    return convert_localized_currency(amount, currency) if amount.present? && currency.present?
    
    # e.g. ...PSTSmallUSD $12.00*GitHub Inc.\n582 M...
    parsed_amount = body.scan(/(DKK|USD|GBP|NOK|SEK|EUR)\W?\$?([\d|\.|\,]*)/i).flatten
    amount = (parsed_amount[1] if parsed_amount.length > 1)
    currency = (parsed_amount[0] if parsed_amount.length > 0)
    return convert_localized_currency(amount.to_f, currency) if amount.present? && currency.present?
    
    # e.g. ..__71,20 Total (incl moms) ____90,10Alle..
    
    parsed_amount = body.scan(/\W+([\d|\.|\,]*)\W?(kr\.)/i).flatten
    amount = (parsed_amount[0] if parsed_amount.length > 1)
    currency = (parsed_amount[1] if parsed_amount.length > 0)
    return convert_localized_currency(amount, currency) if amount.present? && currency.present?
    
    [nil, nil]
  end
  
  def convert_localized_currency(amount, currency)
    if (['kr.', 'kr'].include?(currency))
      currency = 'DKK'
      # replace "15.498,75" with "15498.75"
      amount = amount.gsub(/\./, '')
      amount = amount.gsub(/\,/, '.')
    end
    
    if (currency == '$')
      currency = 'USD'
    end
    
    [amount.to_f, currency]
  end
end