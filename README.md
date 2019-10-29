# BOILER PLATE SETTINGS

## Tech Versions

> Ruby version ** 2.6.3 **
> Rails version ** 5.2.3 **
> Bootstrap version ** 4.0 **
> Database ** PostgreSQL **

Gem Friendly_ID Settings

	```
	extend FriendlyId
	friendly_id :generated_slug, use: :slugged
	def generated_slug
		@random_slug ||= persisted? ? friendly_id : ('a'..'z').to_a.shuffle[0,15].join
	end
	```
Other Gems

*	gem 'paperclip'
*	gem 'omniauth-facebook'
*	gem 'omniauth-linkedin-oauth2'
*	gem 'omniauth-google-oauth2'
*	gem 'omniauth-twitter'
*	gem 'cancancan', '~> 2.0'
*	gem 'bullet' to log N+1 queries
*	gem "meta_request" for a browser extension for rails metrics
*	gem 'awesome_print'