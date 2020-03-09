# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe:
class StripeAdapter
  def initialize(object)
    @object = object
  end

  def call(name)
    check_call_from(name)
  end

  def check_call_from(name)
    if name == 'Product'
      call_product_api
    elsif name == 'Plan'
      call_plan_api
    end
  end

  def call_product_api
    product = Stripe::Product.create(
      name: @object.name,
      type: 'service'
    )
    @object.update!(stripe_id: product.id)
  end

  def call_plan_api
    plan = Stripe::Plan.create(
      currency: @object.currency,
      interval: @object.interval,
      interval_count: @object.interval_count,
      product: @object.product.stripe_id,
      nickname: @object.nickname,
      amount: @object.amount
    )
    @object.update!(stripe_id: plan.id)
  end
end
