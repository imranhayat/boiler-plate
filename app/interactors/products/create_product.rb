# frozen_string_literal: true

module Products
  # :Interactor for Product Creation:
  class CreateProduct < BaseInteractor
    def call
      product = Product.new(context.product_params)
      if product.save!
        context.product = product
        StripeAdapter.new(product).call('Product')
      else
        context.fail!(message: product.errors.full_messages.to_sentence)
      end
    end
  end
end
