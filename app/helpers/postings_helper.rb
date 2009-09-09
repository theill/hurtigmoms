module PostingsHelper
  def grouped_accounts
    [['** SALGSKONTI **', '']] + current_user.accounts.selling.collect { |a| [a.name, a.id] } +
    [['** KØBSKONTI **', '']] + current_user.accounts.buying.collect { |a| [a.name, a.id] }
  end
  
  def link_to_attachment(posting)
    if posting.attachment?
      link_to('%04d' % posting.attachment_no, download_posting_path(posting))
    else
      '%04d' % posting.attachment_no
    end
  end
end
