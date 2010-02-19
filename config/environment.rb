# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "thoughtbot-clearance", :version => '>=0.8.2', :lib => 'clearance', :source  => 'http://gems.github.com'
  config.gem 'thoughtbot-paperclip', :version => '>=2.3.1', :lib => 'paperclip', :source => 'http://gems.github.com'
  config.gem 'jigfox-action_mailer_tls', :version => '>=1.1.3', :lib => 'smtp_tls.rb', :source => 'http://gems.github.com'
  config.gem 'fastercsv'
  config.gem 'will_paginate', :version => '>=2.3.11', :source => 'http://gemcutter.org'
  config.gem 'exceptional', :version => '>=2.0.10'
  config.gem 'rubyzip', :lib => 'zip/zip'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.action_mailer.delivery_method = :smtp

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :da
  
  # Localize default path names
  config.action_controller.resources_path_names = { :new => 'ny', :edit => 'rediger', :create => 'opret', :destroy => 'slet', :update => 'opdater' }
  
  # config.after_initialize do
  #   if Delayed::Job.table_exists?
  #     # clean existing jobs to avoid running inbox checks multiple times
  #     Delayed::Job.delete_all
  #     
  #     # quiet log
  #     Delayed::Worker.logger = nil
  #     
  #     # queue initial inbox check
  #     Delayed::Job.enqueue Inbox.new
  #   end
  # end
end

# create quick lookup table for performing currency conversion calculations
EXCHANGE_RATES = ExchangeRate.all.inject({}) { |initial, er| initial.merge({er.currency => er.rate}) } if ExchangeRate.table_exists?

DO_NOT_REPLY = "bilag@hurtigmoms.dk"