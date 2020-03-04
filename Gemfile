# frozen_string_literal: true

source 'https://rubygems.org'

# Ruby Version
ruby '2.6.3'

# Major Gems
gem 'coffee-rails', '~> 4.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2', '>= 5.2.3'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Gems Used for Development
group :development do
  gem 'bullet' # for N+1 queries
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'meta_request' # browser extension for rails metrics
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Gems Used for Development and Testing
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

# Used Gems for Ease
gem 'awesome_print', require: 'ap' # for rails console
gem 'breadcrumbs_on_rails'
gem 'cancancan', '~> 2.0'
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'figaro'
gem 'friendly_id', '~> 5.2', '>= 5.2.4'
gem 'jquery-rails'
gem 'money-rails', '~>1.12'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-twitter'
gem 'paperclip'
gem 'rolify'
gem 'rubocop', require: false
gem 'stripe'
gem 'sweetalert-rails'
gem 'toastr_rails'
gem 'ultrahook'
