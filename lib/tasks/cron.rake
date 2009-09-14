task :cron => :environment do
	# clean up auto-generated users which didn't confirm their account within 24 hours
	unconfirmed_users = User.find(:all, :conditions => ['confirmation_token IS NOT NULL AND created_at < ?', 1.day.ago])
	unconfirmed_users.each &:destroy
end