# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe Plan:
class StripePlanAdapter
  def initialize(object)
    @object = object
  end

  def call
    create_plan
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError
    false
  end

  def create_plan
    plan = Stripe::Plan.create(
      currency: @object.currency,
      interval: @object.interval,
      interval_count: @object.interval_count,
      product: @object.product.stripe_id,
      nickname: @object.nickname,
      amount: @object.amount
    )
    @object.update!(stripe_id: plan.id)
    true
  end
end
