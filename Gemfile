source 'http://rubygems.org'

gem 'sinatra', '~> 2.0.2'
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'
gem 'require_all'
# gem 'sqlite3'
gem 'thin'
gem 'shotgun'
gem 'pry'
gem 'bcrypt'
gem "tux"

# updating dependencies for security
gem 'rack-flash3'
gem 'nokogiri', '~> 1.8.2'
gem 'sprockets', '~> 3.7.2'

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
end

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'activerecord-postgresql-adapter'
end