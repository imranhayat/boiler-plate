# frozen_string_literal: true

# :Subscriptions Controller for Handling Subscription Actions:
class SubscriptionsController < ApplicationController
  def create
    @response = create_subscription
    @payment_attrs = @response.payment_attrs
    respond_to do |format|
      format.html do
        if @response.success?
          redirect_to plans_path,
                      notice: 'You have subscribed our services successfully'
        else
          redirect_to plans_path, alert: "Error: #{response.message}"
        end
      end
      format.js
    end
  end

  def create_subscription
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
      redirect_to plans_path,
                  alert: "Stripe Error: #{response.message}"
    end
  end

  def setup_renewal_of_subscription
    response = Subscriptions::SubscriptionRenewal.call(
      current_user: current_user
    )
    if response.success?
      redirect_to plans_path, notice: 'Subscription Update Successfully'
    else
      redirect_to plans_path,
                  alert:
          "Stripe error while updating subscription: #{response.message}"
    end
  end
end
