# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_progs_session',
  :secret      => '9fdf4acd4ec173c54446dc4227ffc82fbee9a7439015ded500e68865bbedd0348c30e75c27859fd92d99fe31ff60215a706e8edf8a2812b0ca9593cdae2e0e6e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
