# frozen_string_literal: true

# :User Panel Controller:
class UserPanelController < ApplicationController
  load_and_authorize_resource class: false

  def dashboard; end

  def user_settings
    if current_user.subscription.present?
      @subscription = current_user.subscription
      @plan = @subscription.plan
    end
    if current_user.stripe_customer_id? && current_user
       .stripe_payment_method_id?
      @card_details = current_user.card_details
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
    create_intent
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def create_intent
    @amount = (params[:amount].to_f * 100).to_i
    @intent = Stripe::PaymentIntent.create(
      amount: @amount,
      currency: 'usd',
      payment_method_types: ['card'],
      description: current_user.email
    )
  end
end
