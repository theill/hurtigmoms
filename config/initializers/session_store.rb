# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hurtigmoms_session',
  :secret      => 'eaf96995a59b2e08ca37b2f5a2470c69e3c45d7b88a3a054a48622a62487a4bb0ed90098cd2722a7ea9bfc0188ce3832b8c55c24f19c03ed45727ccaab3b4603'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
