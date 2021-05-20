# frozen_string_literal: true

source 'https://rubygems.org'

# Ruby Version
ruby '3.0.1'

# Major Gems
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'coffee-rails', '~> 5.0.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.3.2'
gem 'sass-rails', '~> 6.0.0'
gem 'turbolinks', '~> 5.2.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '~> 4.2.0'
gem 'webpacker', '~> 5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Gems Used for Development
group :development do
  gem 'bullet', '~> 6.1.4' # for N+1 queries
  gem 'letter_opener', '~> 1.7.0'
  gem 'listen', '~> 3.5.1'
  # gem 'meta_request', '~> 0.7.2' # browser extension for rails metrics
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
  gem 'web-console', '>= 4.1.0'
end

# Gems Used for Development and Testing
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Used Gems for Ease
gem 'awesome_print', '~> 1.9.2', require: 'ap' # for rails console
gem 'breadcrumbs_on_rails', '~> 4.1.0'
gem 'cancancan', '~> 3.2.1'
gem 'devise', '~> 4.8.0'
gem 'devise_invitable', '~> 2.0.5'
gem 'actionmailer', '~> 6.1.3.1'
gem 'actionpack', '~> 6.1.3.1'
gem 'railties', '~> 6.1.3.1'
gem 'figaro', '~> 1.2.0'
gem 'friendly_id', '~> 5.4.2'
gem 'interactor', '~> 3.1.2'
gem 'bootstrap', '~> 4.6.0'
gem 'jquery-rails', '~> 4.4.0'
gem 'money-rails', '~> 1.14.0'
gem 'omniauth-facebook', '~> 8.0.0'
gem 'omniauth-google-oauth2', '~> 1.0.0'
gem 'omniauth-linkedin-oauth2', '~> 1.0.0'
gem 'omniauth-twitter', '~> 1.4.0'
gem 'rolify', '~> 6.0.0'
gem 'rubocop', '~> 1.13.0', require: false
gem 'stripe', '~> 5.32.1'
gem 'ultrahook', '~> 1.0.1'