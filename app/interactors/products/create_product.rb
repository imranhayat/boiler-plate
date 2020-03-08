# frozen_string_literal: true

module Products
  # :Interactor for Product Creation:
  class CreateProduct < BaseInteractor
    def call
      product = context.user.build_product(context.product_params)
      if product.save!
        context.product = product
        StripeAdapter.new('Product', product)
      else
        context.fail!(message: product.errors.full_messages.to_sentence)
      end
    end
  end
end
