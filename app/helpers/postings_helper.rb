module PostingsHelper
  def grouped_accounts
    [['** SALGSKONTI **', '']] + current_user.accounts.selling.collect { |a| [a.name, a.id] } +
    [['** KØBSKONTI **', '']] + current_user.accounts.buying.collect { |a| [a.name, a.id] }
  end
end
