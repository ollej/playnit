# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_server_session',
  :secret      => '59a9647ef44ef5cdee5fc8c64b47494b7905258e8d3d75039fb8f758e4a3d9ca8fa45e69ac6ee20685316b7d419b3c0ec468d992254f818cde947f623dbaf55f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
