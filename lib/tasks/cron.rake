task :cron => :environment do
	::Inbox.new.fetch
end