# Boiler Plater Starter Settings

### Versions

> Ruby version  (2.6.3)
> Rails version (5.2.3)
> Bootstrap version (4.0)
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

> This Module Contains the whole Stripe Subscription with, Stripe Product, Plans and Coupons and etc. This Module follows the Single Repository Principle and Adapter Patterns, so if you don't know these, I should recommend you to first grasp these concepts. Let's dive into the thing.

* Stripe:

  First of all, I want to give you some general overview regading this module about how the stripe is working here! As we all know MVC, so I just enhanced the concepts little bit so that we are in accordance with the community standards. Now when the request (you can say forexample click on a button) is sent from view to controller, we invoke the model here, but this is the simple MVC things, What is different here is when there is a request from the view to a controller, we invoke a specific interactor in the controller to perform the certian Job, that interactor deals with the calls, if there is some API needed, that interactor invoke the specific adapter to finilize the request, and when there is a response of success, the success response is sent back, otherwise, failure response is returned. This is very general overview about how this whole module is working, If you don't have any idea about interators and adapters, as I recommended before, It's necessary for you to grasp these concepts first, otherwise, this documentation will not give proper sense to you.

  * Stripe Product:

    * In this feature, we setup the Stripe Product API, so we don't have to open stripe dashboard, we can create a stripe product from our application, just go to the [Products New Page](http://localhost:3000/products/new).
      * Above link should specified localhost, as I am assuming you are currently developing this on losthost, So for production you have to specified your domain name.
    * Below Call Specified the Product Create Call, You can visit this in Products Controller.

    ```ruby
    def create
      response = Products::CreateProduct.call(product_params: product_params)
      .....
    end
    ```
  
  * Stripe Plans:

    * Same above goes for the stripe plans, No need to check into stripe dashboard, just visit the following url to create the plans [Plans New Page](http://localhost:3000/plans/new).
      * Above link should specified localhost, as I am assuming you are currently developing this on losthost, So for production you have to specified your domain name.
    * Below Call Specified the Plan Create Call, You can visit this in Plans Controller.

    ```ruby
    def create
      response = Plans::CreatePlan.call(plan_params: plan_params)
      ......
    end
    ```
    
  * Stripe Subscriptions:

    * This feature create the stripe customer and subscriptions, first of all we first create stripe customer and then subscribe that cutsomer to a specfic plan, the plans we just created above. We also handled the coupons so if you want to give your customer a specfic discount you can do so, but coupons should be created from the stripe dashboard, we don't deal with them in the application, as they are much more flexible there. Upgrading and Downgrading Plans have been implemented too, So If you want that, that is there too. Customer can add aslo add or update card details and customer invoices are displayed, As this is the full fledge module so, I am just giving you basic code examples where these functions have implemented. To understand this process you can go over the Subscriptions controller and can see all the functions there. I am just giving few examples here.

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

    * This Adapter is for calling the Stripe API and perform and certian task.

  * Stripe Webhook Manager:

    * This is the service for handle the webhooks for the stripe, forexample when subscription is updated you want to want to update the subscription in the application, Let me give you an example:
    
    ```ruby
    when 'customer.subscription.updated'
      update_subscription
    end
    .....
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
*	gem 'paperclip'