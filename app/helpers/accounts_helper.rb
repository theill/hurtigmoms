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
  
  def type_of_vat(account)
    case account.vat_type
    when Account::VAT_TYPES[:standard]
      t('account.vat_type_standard')
    when Account::VAT_TYPES[:none]
      t('account.vat_type_none')
    when Account::VAT_TYPES[:other_country]
      t('account.vat_type_other_country')
    else
      t('account.vat_type_unknown')
    end
  end
  
  def account_types
    Account::ACCOUNT_TYPES.collect { |name, value| [I18n.t('account.account_type_' + name.to_s), value] }.sort_by { |name, value| value }
  end
  
end
