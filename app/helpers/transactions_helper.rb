module TransactionsHelper
  # extract first line of note
  def note_for_overview(transaction)
    first_line = (transaction.note || '').split("\n").first || ''
    
    if transaction.customer
      "<span class=\"customer-name\">#{h(transaction.customer.name)}</span> " + first_line
    else
      first_line
    end
  end
  
  def formatted_attachment_no(transaction)
    '%04d' % transaction.attachment_no if transaction.attachment_no
  end
end
