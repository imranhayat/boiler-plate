# frozen_string_literal: true

# :Product Controller for handling products actions:
class ProductsController < ApplicationController
  load_and_authorize_resource
  def show; end

  def new
    @product = Product.new
  end

  # POST /products
  def create
    response = Products::CreateProduct.call(product_params: product_params)
    if response.success?
      redirect_to response.product, notice: 'Product was successfully created.'
    else
      redirect_to new_product_path, alert: "Product Error: #{response.message}"
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name)
  end
end
