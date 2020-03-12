# frozen_string_literal: true

# :Subscriptions Controller for Handling Subscription Actions:
class SubscriptionsController < ApplicationController
  def create
    @response = Subscriptions::ChoosePaymentGateway.call(
      params: params,
      current_user: current_user
    )
    respond_to do |format|
      p @response.payment_attrs
      p @response.payment_attrs[:stripe_subscription_status]
      @payment_attrs = @response.payment_attrs
      if @response.success?
        format.html do
          redirect_to plans_path,
                      notice: 'You have subscribed our services successfully'
        end
      else
        format.html do
          redirect_to plans_path, alert: "Error: #{response.message}"
        end
      end
      format.js
    end
  end

  def cancel_subscription_now
    response = Subscriptions::CancelSubscriptionNow.call(
      current_user: current_user
    )
    if response.success?
      redirect_to plans_path,
                  notice: 'Your Subscription has been cancelled successfully.'
    else
      redirect_to plans_path, alert: "Error: #{response.message}"
    end
  end

  def setup_renewal_of_subscription
    response = Subscriptions::SetupSubscriptionRenewal.call(
      current_user: current_user
    )
    if response.success?
      redirect_to plans_path, notice: 'Subscription Update Successfully'
    else
      redirect_to plans_path, alert: "Error: #{e.message}"
    end
  end

  def update_card_details
    response = Users::UpdateStripeCardDetails.call(
      current_user: current_user,
      params: params
    )
    if response.success?
      redirect_to plans_path, notice: 'Card Details Updated Successfully'
    else
      redirect_to plans_path, alert: "Error: #{e.message}"
    end
  end
end
