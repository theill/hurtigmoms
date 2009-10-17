Feature: Manage postings
	In order to manage postings
	A user
	Should be able to add, edit and delete postings

	Scenario: User looks as postings
		Given I am signed up and confirmed as "email@person.com/password"
		When I sign in as "email@person.com/password"
		Then I should be signed in
		When I go to the postings page
		Then I should see "Postings"

	# Scenario: User adds a posting
	# 	Given I am signed up and confirmed as "email@person.com/password"
	# 	When I sign in as "email@person.com/password"
	# 	Then I should be signed in
	# 	When I go to the postings page
	# 	And I fill in "Amount" with "42580"
	# 	And I fill in "Note" with ""
	# 	And I fill in "Account" with "Salg, indland"
	# 	And I press "Create posting"
	# 	Then one more posting should be added
	  

