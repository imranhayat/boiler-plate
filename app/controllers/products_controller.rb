# frozen_string_literal: true

# :Product Controller for handling products actions:
class ProductsController < ApplicationController
  load_and_authorize_resource
  def show; end

  def new
    if Product.count < 1
      @product = Product.new
    else
      redirect_to product_path(Product.first), alert: 'Product was already present.'
    end
  end

  # POST /products
  def create
    response = Products::CreateProduct.call(product_params: product_params,
                                            user: current_user)
    if response.success?
      redirect_to response.product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name)
  end
end
