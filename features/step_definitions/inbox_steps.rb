Given /^I sent mail from (.*)$/ do |name|
  mail = TMail::Mail.parse(File.read("#{RAILS_ROOT}/test/fixtures/mails/#{name.downcase}.txt"))
  MailParser.new.parse(mail)
end

Then /^I should have one posting$/ do
  assert 1, user.postings.length
end