# SETTINGS

### Versions

> Ruby version  (2.6.3)
> Rails version (5.2.3)
> Bootstrap version (4.0)
> Database (PostgreSQL)

Gem Friendly_ID Settings

```ruby
extend FriendlyId
friendly_id :generated_slug, use: :slugged
def generated_slug
  @random_slug ||= persisted? ? friendly_id : ('a'..'z').to_a.shuffle[0,15].join
end	
```
Gem Rolify Settings

> If you want to add more roles add them manually or using seeds file.

Omniauth Settings

> Omniauth Complete Integration for Google and Facebook Social Login has been Implemented.

* Facebook:
  * Go to your facebook developers console and create an App.
  * The App will have a APP ID and APP SECRET.
  * Just set those keys as ENV variables in your application.yml file.
  * ( For Heroku ) Go to the Facebook Login Settings and add Valid OAuth Redirect URI such as:
    * app_name/users/auth/facebook/callback

* Google:
  * Go to your google developers console and create a Project.
  * Select the API & Services and setup OAuth consent screen. 
    * ( For Heroku ) Add your domain in Authorised domains.
  * After setting OAuth consent screen go to Credentials tab and click on create credentials
  * Google will generate keys, just set those keys as ENV variables in your application.yml file.
    * Select OAuth Client ID and then in that panel add your redirect url in Authorised redirect URIs such as:
      * app_name/users/auth/google_oauth2/callback
 
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