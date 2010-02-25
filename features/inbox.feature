Feature: Inbox mail parsing
	In order to properly parse incoming emails
	As a user
	I want to have postings added with details from my email

	Scenario: Parsing a Harvest mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from Harvest
		When I go to the transactions page
		Then I should see "Harvest Subscription"
		And I should not see "Fwd: Harvest Subscription"
		And I should see "04/09-2009"
		And I should see "~DKK63.95"
 
	Scenario: Parsing a Harvest invoice mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from harvest_danish
		When I go to the transactions page
		Then I should see "Faktura #2009020 fra Commanigy"
		And I should not see "Fwd: Faktura #2009020 fra Commanigy"
		And I should see "08/10-2009"
		And I should see "DKK15,468.75"

	Scenario: Parsing a GitHub mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from GitHub
		When I go to the transactions page
		Then I should see "[GitHub] Payment Receipt"
		And I should not see "Fwd: [GitHub] Payment Receipt"
		And I should see "27/08-2009"
		And I should see "~DKK60.19"
  
	Scenario: Parsing a Campaign Monitor mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from CampaignMonitor
		When I go to the transactions page
		Then I should see "Delivery of ConquerCam 2.8.1 released"
		And I should not see "Fwd: Campaign Monitor: Invoice for delivery of ConquerCam 2.8.1 released"
		And I should see "29/08-2009"
		And I should see "~DKK182.73"

	Scenario: Parsing a Spotify mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from Spotify
		When I go to the transactions page
		Then I should see "1 month (Spotify Premium)"
		And I should not see "Fwd: Spotify Receipt"
		And I should see "14/09-2009"
		And I should see "DKK99.00"

	Scenario: Parsing a Basecamp mail
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from basecamp
		When I go to the transactions page
		Then I should see "1 month Basecamp Basic Plan"
		And I should not see "Fwd: Spotify Receipt"
		And I should see "25/08-2009"
		And I should see "~DKK120.38"

	Scenario: Parsing any mail with amount in its body
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from unknown
		When I go to the transactions page
		Then I should see "Something I bought"
		And I should not see "Fwd: Something I bought"
		And I should see "02/03-2009"
		And I should see "DKK5,420.00"

	Scenario: Parsing any mail with 'Total' in its body
		Given I have signed in with "john.doe@hurtigmoms.test/password"
		Given I sent mail from unknown_with_total
		When I go to the transactions page
		Then I should see "Amazon Web Services Billing Statement Available"
		And I should not see "Fwd: Amazon Web Services Billing Statement Available"
		And I should see "01/10-2009"
		And I should see "~DKK0.25"
