module AccountsHelper
  def account_type_class(account)
    case account.account_type
    when Account::ACCOUNT_TYPES[:heading]
      'heading-account'
    when Account::ACCOUNT_TYPES[:operating]
      'operating-account'
    when Account::ACCOUNT_TYPES[:status]
      'status-account'
    when Account::ACCOUNT_TYPES[:sum]
      'sum-account'
    else
      ''
    end
  end
  
  def account_types
    Account::ACCOUNT_TYPES.collect { |name, value| [I18n.t('account.account_type_' + name.to_s), value] }.sort_by { |name, value| value }
  end
  
  def vat_types
    Account::VAT_TYPES.collect { |name, value| [I18n.t('account.vat_type_' + name.to_s), value] }.sort_by { |name, value| value }
  end
  
  def account_deletable(account)
    account.account_type == Account::ACCOUNT_TYPES[:operating]
  end
  
end
