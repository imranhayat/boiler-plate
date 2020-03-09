# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe Product:
class StripeProductAdapter
  def initialize(object)
    @object = object
  end

  def call
    product = Stripe::Product.create(
      name: @object.name,
      type: 'service'
    )
    @object.update!(stripe_id: product.id)
    true
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError
    false
  end
end
