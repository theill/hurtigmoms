Feature: Inbox mail parsing
	In order to properly parse incoming emails
	As a user
	I want to have postings added with details from my email

	Scenario: Parsing a Harvest mail
		Given I have signed in with "email@person.com/password"
		Given I sent mail from Harvest
		When I go to the postings page
		Then I should see "Harvest Subscription"
		And I should see "04/09-2009"
		And I should see "12.0"
  
