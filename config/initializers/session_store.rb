# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_baseapp_session',
  :secret      => 'fb18870f16bc26d714171ccd78a516ed29888f2d5bd8151820f69a7253daefb01d228a1f5558726732d0518ff589d81f6cdef6624caabc75cc03dc60351222e4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
