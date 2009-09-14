Feature: Inbox mail parsing
	In order to properly parse incoming emails
	As a user
	I want to have postings added with details from my email

	Scenario: Parsing a Harvest mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from Harvest
		When I go to the postings page
		Then I should see "Harvest Subscription"
		And I should not see "Fwd: Harvest Subscription"
		And I should see "04/09-2009"
		And I should see "USD12.00"
  
	Scenario: Parsing a GitHub mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from GitHub
		When I go to the postings page
		Then I should see "[GitHub] Payment Receipt"
		And I should not see "Fwd: [GitHub] Payment Receipt"
		And I should see "27/08-2009"
		And I should see "USD12.00"
  
	Scenario: Parsing a Campaign Monitor mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from CampaignMonitor
		When I go to the postings page
		Then I should see "Delivery of ConquerCam 2.8.1 released"
		And I should not see "Fwd: Campaign Monitor: Invoice for delivery of ConquerCam 2.8.1 released"
		And I should see "29/08-2009"
		And I should see "USD36.43"

	Scenario: Parsing a Spotify mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from Spotify
		When I go to the postings page
		Then I should see "1 month (Spotify Premium)"
		And I should not see "Fwd: Spotify Receipt"
		And I should see "14/09-2009"
		And I should see "DKK 99.00"

	Scenario: Parsing an unknown mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from unknown
		When I go to the postings page
		Then I should see "Something I bought"
		And I should not see "Fwd: Something I bought"
		And I should see "02/03-2009"
		And I should see "DKK5,420.00"

