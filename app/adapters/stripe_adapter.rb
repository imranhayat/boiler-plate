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
    StripeProductAdapter.new(@object).call
  end

  def call_plan_api
    StripePlanAdapter.new(@object).call
  end
end
