module PostingsHelper
  def accounts
    current_user.accounts.collect { |a| ["#{'%05d' % a.account_no} #{a.name}", a.id] }.sort_by { |no| no }
  end
  
  def link_to_attachment(posting)
    '%04d' % posting.attachment_no if posting.attachment_no
  end
  
  def state_class(posting)
    posting.created_at.to_date == Time.zone.today ? 'today ' : '' + Posting::STATES.find { |k, v| v == posting.state }[0].to_s
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
