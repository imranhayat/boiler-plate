# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe:
class StripeAdapter
  def initialize(options = {})
    @object = options[:object] || nil
    @params = options[:params] || nil
  end

  def call
    check_call_from
  end

  def check_call_from
    if @object.class.to_s == 'Product'
      call_product_api
    elsif @object.class.to_s == 'Plan'
      call_plan_api
    elsif @object.class.to_s == 'Subscription'
      call_subscription_api
    else
      call_coupon_api
    end
  end

  def call_product_api
    create_product
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def create_product
    Stripe::Product.create(
      name: @object.name,
      type: 'service'
    )
    { success: true }
  end

  def call_plan_api
    create_plan
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def create_plan
    Stripe::Plan.create(
      currency: @object.currency,
      interval: @object.interval,
      interval_count: @object.interval_count,
      product: @object.product.stripe_id,
      nickname: @object.nickname,
      amount: @object.amount
    )
    { success: true }
  end

  def call_subscription_api
    create_customer unless stripe_customer_exists?
    create_subscription
  end

  def stripe_customer_exists?
    current_user.stripe_customer_id.present? &&
      current_user.stripe_payment_method_id.present?
  end

  def create_customer
    make_customer
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def current_user
    @object.user
  end

  def make_customer
    stripe_customer = Stripe::Customer.create(
      email: current_user.email,
      name: current_user.name,
      payment_method: @params[:payment_method],
      invoice_settings: {
        default_payment_method: @params[:payment_method]
      }
    )
    update_customer_in_app(stripe_customer)
  end

  def update_customer_in_app(stripe_customer)
    current_user.update!(stripe_customer_id: stripe_customer.id,
                         stripe_payment_method_id: @params[:payment_method])
  end

  def create_subscription
    make_subscription
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, error: e.message }
  end

  def make_subscription
    subscription = Stripe::Subscription.create(
      customer: current_user.stripe_customer_id,
      coupon: @params[:coupon_id],
      items: [
        {
          plan: @params[:stripe_plan_id]
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
    @object.update!(stripe_id: subscription.id,
                    current_period_start:
                    subscription.current_period_start,
                    current_period_end:
                    subscription.current_period_end,
                    cancel_at_period_end:
                    subscription.cancel_at_period_end)
  end

  def setup_payment_attrs(payment_intent, subscription)
    {
      success: true,
      payment_intent_status: payment_intent&.status,
      payment_intent_client_secret: payment_intent&.client_secret,
      stripe_subscription_status: subscription&.status
    }
  end

  def call_coupon_api
    p verify_coupon
  rescue Stripe::InvalidRequestError, Stripe::CardError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError, Stripe::StripeError => e
    { success: false, message: e.message }
  end

  def verify_coupon
    coupon = Stripe::Coupon.retrieve(@object)
    { success: true, coupon: coupon }
  end
end
