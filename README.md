# README


* Ruby version (2.3.4)
* Rails version (5.1.5)
* Bootstrap version (4.0)
* 
* Database creation
* Database initialization

* with gem friendly_id 5.2
    extend FriendlyId
    friendly_id :generated_slug, use: :slugged
    def generated_slug
        @random_slug ||= persisted? ? friendly_id : ('a'..'z').to_a.shuffle[0,15].join
    end
* Other gems
    gem 'omniauth-facebook'
    gem 'omniauth-linkedin-oauth2'
    gem 'omniauth-google-oauth2'
    gem 'omniauth-twitter'
    gem 'cancancan', '~> 2.0'
    gem 'bullet' to log N+1 queries
    gem "meta_request" for a browser extension for rails metrics
    gem 'awesome_print'