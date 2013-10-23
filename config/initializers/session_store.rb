# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_commcare_session',
  :secret      => 'e969fba432b37f1d874805ab72550a7046d8477682b1ff1d5274123721f651e7e092d97b0fadf300569289478a387d5f811a2ffb0e83615a644618544c2d105c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
