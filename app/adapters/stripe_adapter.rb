# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe:
class StripeAdapter
  def initialize(object)
    @object = object
  end

  def call
    check_call_from
  end

  def check_call_from
    if @object.class.to_s == 'Product'
      call_product_api
    elsif @object.class.to_s == 'Plan'
      call_plan_api
    end
  end

  def call_product_api
    create_product
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError => e
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
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError => e
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
end
