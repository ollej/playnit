# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_playnit-api_session',
  :secret      => '91b4dc45368266627550d714dd16ad7e7529b3a7202d5b0e9f09bdb7867d19acbce3d9115d4fe7d89c342f1e06bada508df067a74b8f0dc4d09b5f7769a6df6f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
