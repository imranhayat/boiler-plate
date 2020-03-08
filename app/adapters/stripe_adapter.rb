# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe:
class StripeAdapter
  def initialize(name, object)
    @object = object
    check_call_from(name)
  end

  def check_call_from(name)
    if name == 'Product'
      call_product_api
    end
  end

  def call_product_api
    product = Stripe::Product.create(
      name: @object.name,
      type: 'service'
    )
    @object.update!(stripe_id: product.id)
  end
end
