# frozen_string_literal: true

# :Stripe Adapter for making API calls to Stripe Product:
class StripeProductAdapter
  def initialize(object)
    @object = object
  end

  def call
    make_product
  rescue Stripe::InvalidRequestError, Stripe::StripeError,
         Stripe::APIConnectionError, Stripe::RateLimitError,
         Stripe::AuthenticationError => e
    { success: false, error: e.message }
  end

  def make_product
    Stripe::Product.create(
      name: @object.name,
      type: 'service'
    )
    { success: true }
  end
end
