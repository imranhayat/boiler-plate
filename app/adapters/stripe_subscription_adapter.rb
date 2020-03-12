# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe Subscription:
class StripeSubscriptionAdapter
  def initialize(subscription, stripe_plan_id, payment_method_id, current_user)
    @subscription = subscription
    @stripe_plan_id = stripe_plan_id
    @payment_method_id = payment_method_id
    @current_user = current_user
  end

  def call
    create_customer unless stripe_customer_exists?
    create_subscription
  end

  def stripe_customer_exists?
    @current_user.stripe_customer_id.present? &&
      @current_user.stripe_payment_method_id.present?
  end

  def create_customer
    make_customer
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError => e
    { success: false, error: e.message }
  end

  def make_customer
    stripe_customer = Stripe::Customer.create(
      email: @current_user.email,
      name: @current_user.name,
      payment_method: @payment_method_id,
      invoice_settings: {
        default_payment_method: @payment_method_id
      }
    )
    update_customer_in_app(stripe_customer)
  end

  def update_customer_in_app(stripe_customer)
    @current_user.update!(stripe_customer_id: stripe_customer.id,
                          stripe_payment_method_id: @payment_method_id)
  end

  def create_subscription
    make_subscription
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError => e
    { success: false, error: e.message }
  end

  def make_subscription
    subscription = Stripe::Subscription.create(
      customer: @current_user.stripe_customer_id,
      items: [
        {
          plan: @stripe_plan_id
        }
      ],
      expand: ['latest_invoice.payment_intent']
    )
    perform_several_actions(subscription)
  end

  def perform_several_actions(subscription)
    update_subscription_in_app(subscription)
    payment_intent = subscription.latest_invoice.payment_intent
    setup_payment_attrs(payment_intent, subscription)
  end

  def update_subscription_in_app(subscription)
    @subscription.update!(stripe_id: subscription.id,
                          current_period_start:
                          subscription.current_period_start,
                          current_period_end:
                          subscription.current_period_end,
                          cancel_at_period_end:
                          subscription.cancel_at_period_end)
  end

  def setup_payment_attrs(payment_intent, subscription)
    {
      payment_intent_status: payment_intent&.status,
      payment_intent_client_secret: payment_intent&.client_secret,
      stripe_subscription_status: subscription&.status
    }
  end
end
