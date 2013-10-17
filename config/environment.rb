# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION
#RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
#   config.action_controller.session = {
#     :session_key => '_timber_session',
#     :secret      => '5b2c1d251a6eb894bc46014254468e90fbd180935e59f55662ddb9dd3b4c434c63bb3bf42e41f11534475271dd018ceef1b1acd1c89b2d6bffac6aae0abd1c68'
#   }


  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Include your application configuration below

# Relay mail through w                                                                                           
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address => "www.sness.org",
  :domain => "orchive.sness.org"
}

# # Email me if there are any exceptions                                                                           
# ExceptionNotifier.exception_recipients = %w(snessnet@gmail.com)
# ExceptionNotifier.sender_address = %w(exceptions@orchive.sness.org)

# Don't colorize SQL logs
ActiveRecord::Base.colorize_logging = false

# Gruff graphs
#require 'gruff'

# will_paginate
#gem 'mislav-will_paginate', '~> 2.2'
require 'will_paginate'

# Register mp3s as a Mime type
Mime::Type.register 'audio/mpeg', :mp3

# Register jpgs as a Mime type
Mime::Type.register 'image/jpeg', :jpg

