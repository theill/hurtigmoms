task :cron => :environment do
	::Inbox.new.perform
end