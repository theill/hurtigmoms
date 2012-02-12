# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Hurtigmoms::Application.initialize!

# create quick lookup table for performing currency conversion calculations
EXCHANGE_RATES = ExchangeRate.latest.all.inject({}) { |initial, er| initial.merge({er.currency => er.rate}) } if ExchangeRate.table_exists?

DO_NOT_REPLY = "bilag@hurtigmoms.dk"

require 'slugify'
# require 'memcached'