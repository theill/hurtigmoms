Given /^I sent mail from (.*)$/ do |name|
  mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/#{name.downcase}.txt"))
  
  user = User.last
  
  email, transaction = MailParser.new(mail).parse
  if transaction
    transaction.fiscal_year = user.active_fiscal_year
    transaction.save
  end
end

Then /^I should have one posting$/ do
  assert 1, user.postings.length
end