# Boiler-Plate Starter Things

### Versions

> Ruby version  (2.6.3)
> Rails version (5.2.3)
> Bootstrap version (4.6.0)
> Database (PostgreSQL)

#### Gem Friendly_ID Settings

```ruby
extend FriendlyId
friendly_id :generated_slug, use: :slugged
def generated_slug
  @random_slug ||= persisted? ? friendly_id : ('a'..'z').to_a.shuffle[0,15].join
end	
```
#### Gem Rolify Settings

> If you want to add more roles add them manually or using seeds file or you can create a CRUD for youself.

#### Omniauth Settings

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
 
#### Stripe Subscription Module

> This module contains the whole stripe subscription with, stripe product, plans coupons and etc. This Module follows the Single Repository Principle and Adapter Patterns, so if you don't know these, It is recommended, to first grasp these concepts. Let's dive into the thing.

* General Overview:

  This module talks about how the stripe is working here! When the request (you can say forexample click on a button) is sent from view to controller, we invoke the model here, but this is the simple MVC thing, What is different here is that when there is a request from the view to a controller, we invoke a specific interactor in the controller to perform the certian job, that interactor deals with the calls, if there is some API needed, that interactor invoke the specific adapter to finilize the request, and when there is a response of success, the success response is sent back, otherwise, failure response is returned. This is very general overview about how this whole module is working, If you don't have any idea about interators and adapters, as recommended before, It's necessary for you to grasp these concepts first, otherwise, this documentation will not give proper sense to you.
  
  * Interactor
    * An interactor is a simple, single-purpose object. Interactors are used to encapsulate your application's business logic. Each interactor represents one thing that your application does.
    
  * Adapter
    * An adapter can provide an interface for different classes to work together. In the Object Adapter Pattern, the adapter contains an instance of the class it wraps. In this situation, the adapter makes calls to the instance of the wrapped object. The main purpose of the Adapter is to call several APIs and perform certain tasks.
  
  * Helpful Links (Interactors and Adapters)
  
    * https://github.com/collectiveidea/interactor
    * https://www.sitepoint.com/using-and-testing-the-adapter-design-pattern/
    * https://www.thegreatcodeadventure.com/rails-refactoring-part-i-the-adapter-pattern/
    
* Stripe

  * Stripe Product:

    * In this feature, we setup the Stripe Product API, so we don't have to open stripe dashboard, we can create a stripe product from our application, just go to the [Products New Page](http://localhost:3000/products/new).
      * Above link should specified localhost, as I am assuming you are currently developing this on project on localhost, So for production you have to specified your domain name.
    * Below Call Specified the Product Create Call, You can visit this in Products Controller.

    ```ruby
    def create
      response = Products::CreateProduct.call(product_params: product_params)
      .....
    end
    ```
  
  * Stripe Plans:

    * Same above goes for the stripe plans, No need to check into stripe dashboard, just visit the following url to create the plans [Plans New Page](http://localhost:3000/plans/new).
      * Above link should specified localhost, as I am assuming you are currently developing this on project on localhost, So for production you have to specified your domain name.
    * Below Call Specified the Plan Create Call, You can visit this in Plans Controller.

    ```ruby
    def create
      response = Plans::CreatePlan.call(plan_params: plan_params)
      ......
    end
    ```
    
  * Stripe Subscriptions:

    * This feature create the stripe customer and subscriptions, first of all we first create the stripe customer and then subscribe that customer to a specfic plan, the plans we just created above. We also handled the coupons so if you want to give your customer a specfic discount you can do so, but coupons should be created from the stripe dashboard, we don't deal with them in the application, as they are much more flexible there. Upgrading and Downgrading Plans have also been implemented, So If you want that, that is there too. Customer can aslo add or update card details and customer invoices are also displayed, As this is the full fledge module so, just giving you basic code examples where these functions have implemented. To understand this process you can go over the Subscriptions controller and can see all the functions there. here are few examples.

    ```ruby
    def create
      Subscriptions::CreateSubscription.call(
        params: params,
        current_user: current_user
      )
      .....
    end

    def up_or_down_stripe_plan(plan)
      Subscriptions::UpOrDownStripePlan.call(
        current_user: current_user,
        plan: plan
      )
      .....
    end
    ```
  
  * Stripe Adapter:

    * This Adapter is for calling the Stripe API and then perform a certian task according to the call. Forexample,
    ```ruby
    def call_product_api
      create_product
    rescue Stripe::InvalidRequestError, Stripe::CardError,
           Stripe::APIConnectionError, Stripe::RateLimitError,
           Stripe::AuthenticationError, Stripe::StripeError => e
      { success: false, error: e.message }
    end
    ```

  * Stripe Webhook Manager:

    * This is the service for handle the webhook events for the stripe, forexample when subscription is updated you want to update the subscription in the application, Let me give you an example:
    
    ```ruby
    when 'customer.subscription.updated'
      update_subscription
    end
    ```


#### Other Gems used in the boiler-plate

*	gem 'awesome_print'
*	gem 'bullet' to log N+1 queries
*	gem 'cancancan', '~> 2.0'
*	gem 'meta_request' for a browser extension for rails metrics
*	gem 'omniauth-facebook'
*	gem 'omniauth-google-oauth2'
*	gem 'omniauth-linkedin-oauth2'
*	gem 'omniauth-twitter'
