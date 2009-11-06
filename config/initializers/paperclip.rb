Paperclip.options[:log] = false

Paperclip.interpolates :user_id do |attachment, style|
  attachment.instance.transaction.fiscal_year.user_id
end