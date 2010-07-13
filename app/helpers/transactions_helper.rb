module TransactionsHelper
  def transaction_type_class(transaction)
    Transaction::TRANSACTION_TYPES.invert[transaction.transaction_type].to_s
  end
  
  def transaction_types
    Transaction::TRANSACTION_TYPES.collect { |name, value| [I18n.t('transaction.transaction_type_' + name.to_s), value] }.sort_by { |name, value| value }
  end
  
  def options_for_transaction_types(selected)
    options_for_select(['', ''] | Transaction::TRANSACTION_TYPES.collect { |k, v| [I18n.t("transaction.transaction_type_#{k}"), v.to_s] }, selected)
  end
  
  # extract first line of note
  def note_for_overview(transaction, search=nil)
    first_line = highlight_words(h(extract_first_note_line(transaction)), search)
    
    if transaction.customer
      "<span class=\"customer-name\">#{highlight_words(h(transaction.customer.name), search)}</span> " + first_line
    else
      first_line
    end
  end
  
  def extract_first_note_line(transaction)
    truncate((transaction.note || '').split("\n").first || '', :length => 78)
  end
  
  def formatted_pdf_line(transaction)
  	[
  	  transaction.created_at.strftime("%d/%m-%Y"),
  	  transaction.attachment_no ? ('%04d' % transaction.attachment_no) : '',
  	  extract_first_note_line(transaction),
  	  (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:sell] || (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:pay] && transaction.amount > 0)) ? number_to_currency(transaction.amount, :unit => transaction.currency) : '',
  	  (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:buy] || (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:pay] && transaction.amount < 0)) ? number_to_currency(transaction.amount, :unit => transaction.currency) : ''
  	]
  end

  def formatted_related_pdf_line(transaction)
  	[
  	  transaction.created_at.strftime("%d/%m-%Y"),
  	  transaction.attachment_no ? ('%04d' % transaction.attachment_no) : '',
  	  'REF: ' + extract_first_note_line(transaction),
  	  (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:sell] || (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:pay] && transaction.amount > 0)) ? number_to_currency(transaction.amount, :unit => transaction.currency) : '',
  	  (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:buy] || (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:pay] && transaction.amount < 0)) ? number_to_currency(transaction.amount, :unit => transaction.currency) : ''
  	]
  end
  
  def formatted_transaction_type(transaction)
    translation_key = Transaction::TRANSACTION_TYPES.find { |k, v| v == transaction.transaction_type }.first.to_s
    I18n.t('transaction.transaction_type_' + translation_key)
  end
  
  def formatted_attachment_no(transaction)
    content_tag('span', '%04d' % transaction.attachment_no, :class => ('missing' if transaction.annexes.empty?)) if transaction.attachment_no
  end
  
  def formatted_income_amount(transaction)
    if transaction.transaction_type == Transaction::TRANSACTION_TYPES[:sell] || (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:pay] && transaction.amount > 0)
      formatted_amount(transaction)
    end
  end
  
  def formatted_expense_amount(transaction)
    if transaction.transaction_type == Transaction::TRANSACTION_TYPES[:buy] || (transaction.transaction_type == Transaction::TRANSACTION_TYPES[:pay] && transaction.amount < 0)
      formatted_amount(transaction)
    end
  end
  
  def formatted_amount(transaction)
    number_with_currency = number_to_currency(ExchangeRate.exchange_to(transaction.amount, transaction.currency, current_user.default_currency), :unit => current_user.default_currency)

    if transaction.transaction_type == Transaction::TRANSACTION_TYPES[:sell]
      number_with_currency = content_tag(:span, number_with_currency, :class => 'income')
    elsif transaction.transaction_type == Transaction::TRANSACTION_TYPES[:buy]
      number_with_currency = content_tag(:span, number_with_currency, :class => 'expense')
    end
    
    if transaction.currency == current_user.default_currency
      number_with_currency
    else
      content_tag(:span, content_tag(:span, '~', :class => 'exchanged') + number_with_currency, :title => number_to_currency(transaction.amount, :unit => transaction.currency))
    end
  end
  
  private
  
  def highlight_words(line, search)
    if search
      highlight(line, search)
    else
      line
    end
  end
  
end
