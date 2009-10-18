module PostingsHelper
  def grouped_accounts
    [['** SALGSKONTI **', '']] + current_user.accounts.selling.collect { |a| [a.name, a.id] } +
    [['** KØBSKONTI **', '']] + current_user.accounts.buying.collect { |a| [a.name, a.id] }
  end
  
  def link_to_attachment(posting)
    # if posting.attachment?
      # link_to('%04d' % posting.attachment_no, download_fiscal_year_posting_path(current_user.active_fiscal_year, posting))
    # else
      '%04d' % posting.attachment_no if posting.attachment_no
    # end
  end
  
  def state_class(posting)
    Posting::STATES.find { |k, v| v == posting.state }[0].to_s
  end
  
  # extract first line of note
  def note_for_overview(posting)
    first_line = (posting.note || '').split("\n").first || ''
    
    if posting.customer
      "<span class=\"customer-name\">#{h(posting.customer.name)}</span> " + first_line
    else
      first_line
    end
  end
end
