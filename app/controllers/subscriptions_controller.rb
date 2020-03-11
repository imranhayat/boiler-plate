# frozen_string_literal: true

# :Subscriptions Controller for Handling Subscription Actions:
class SubscriptionsController < ApplicationController
  def create
    response = Subscriptions::ChoosePaymentGateway.call(
      params: params,
      current_user: current_user
    )
    if response.success?
      redirect_to plans_path,
                  notice: 'You have subscribed our services successfully'
    else
      redirect_to plans_path, alert: "Error: #{response.message}"
    end
  end
end
