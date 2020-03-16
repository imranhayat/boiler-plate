# frozen_string_literal: true

# :Subscriptions Controller for Handling Subscription Actions:
class SubscriptionsController < ApplicationController
  def create
    @response = call_interactor
    respond_to do |format|
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

  def call_interactor
    Subscriptions::CreateSubscription.call(
      params: params,
      current_user: current_user
    )
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
end
