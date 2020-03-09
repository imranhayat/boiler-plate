# frozen_string_literal: true

module Products
  # :Interactor for Product Creation:
  class CreateProduct < BaseInteractor
    def call
      if check_product_exists?
        context.fail!
      else
        make_product_on_stripe
      end
    end

    def check_product_exists?
      return true if Product.count >= 1
    end

    def make_product_on_stripe
      product = Product.new(context.product_params)
      response = StripeAdapter.new(product).call
      if response == true
        make_product_in_app(product)
      else
        context.fail!
      end
    end

    def make_product_in_app(product)
      if product.save!
        context.product = product
      else
        context.fail!
      end
    end
  end
end
