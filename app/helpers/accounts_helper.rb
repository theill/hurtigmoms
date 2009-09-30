module AccountsHelper
  def type_of_account(account)
    case account.account_type
    when Account::ACCOUNT_TYPES[:sell]
      t('account.account_type_sell')
    when Account::ACCOUNT_TYPES[:buy]
      t('account.account_type_buy')
    else
      t('account.account_type_unknown')
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
  
end
