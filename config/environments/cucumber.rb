config.cache_classes = true # This must be true for Cucumber to operate correctly!

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
config.action_mailer.default_url_options = { :host => "hurtigmoms.test" }

config.i18n.default_locale = :en

# HOST = "localhost"

config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gemcutter.org"
config.gem "thoughtbot-factory_girl", :version => '>= 1.2.2', :lib => "factory_girl", :source => "http://gems.github.com"
config.gem 'cucumber',    :lib => false,        :version => '>=0.4.3' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber'))
config.gem 'webrat',      :lib => false,        :version => '>=0.5.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))
config.gem 'rspec',       :lib => false,        :version => '>=1.2.8' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
config.gem 'rspec-rails', :lib => false,        :version => '>=1.2.7.1' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
