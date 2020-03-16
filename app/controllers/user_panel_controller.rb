# frozen_string_literal: true

# :User Panel Controller:
class UserPanelController < ApplicationController
  load_and_authorize_resource class: false

  def dashboard; end

  def user_settings
    if params[:success] == 'yes'
      p 'Card Details Updated'
    else
      p 'Error, Card Details Not Updated'
    end
  end

  def update_card_details
    @response = Users::UpdateStripeCardDetails.call(
      current_user: current_user
    )
    respond_to do |format|
      format.js
    end
  end

  def payment
    @amount = (params[:amount].to_f * 100).to_i
    @intent = Stripe::PaymentIntent.create(
      amount: @amount,
      currency: 'usd',
      payment_method_types: ['card'],
      description: current_user.email
    )
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
end
