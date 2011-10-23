source 'http://rubygems.org'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem 'rails', '3.0.9'

#gem 'formtastic'
gem "simple_form"

gem 'devise'  
gem 'omniauth'  

gem 'carrierwave'
gem 'json'
gem 'multi_json'
gem 'ya2yaml'

gem 'jquery-rails'

gem 'rake'
# was for heroku 
#gem 'rake', '0.8.7', :group => :production
#gem 'evernote', :group => :production

group :production do
  # was for heroku 
  gem 'pg'
  # for dotcloud
  # https://github.com/brianmario/mysql2
  gem "mysql2", "~> 0.2.7"
end

group :development do
  gem 'sqlite3'
  gem "nifty-generators"
end

group :test do
  gem "rspec"
  gem "rspec-rails"
  gem "mocha"
  gem "factory_girl_rails"
  #gem "capybara"
  gem "guard-rspec"
end


