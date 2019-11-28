source 'https://rubygems.org'

# Ruby Version
ruby '2.6.3'

# Major Gems
gem 'rails', '~> 5.2', '>= 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Gems Used for Development
group :development do
  gem 'letter_opener'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'meta_request' # browser extension for rails metrics
  gem 'bullet' # for N+1 queries
end

# Gems Used for Development and Testing 
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

# Used Gems for Ease
gem 'awesome_print', require: 'ap' #for rails console 
gem 'devise'
gem 'jquery-rails'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'cancancan', '~> 2.0'
gem 'friendly_id', '~> 5.2', '>= 5.2.4'
gem 'paperclip'
gem 'sweetalert-rails'
gem 'money-rails', '~>1.12'
gem 'stripe'
gem 'ultrahook'
gem 'figaro'
gem 'toastr_rails'
gem 'rubocop', require: false
gem 'devise_invitable', '~> 2.0.0'
gem 'rolify'