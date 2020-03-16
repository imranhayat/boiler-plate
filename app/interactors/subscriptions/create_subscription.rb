# frozen_string_literal: true

module Subscriptions
  # :Interactor for Creating a Subscription:
  class CreateSubscription < BaseInteractor
    def call
      subscription = Subscription.new(
        subscription_params
      )
      response = PaymentGatewayAdapter.new(
        payment_gateway: context.params[:payment_gateway],
        object: subscription,
        params: context.params
      ).call
      if response[:success] == true
        make_subscription_in_app(subscription)
        check_response(response)
      else
        context.fail! message: response[:error]
      end
    end

    def current_user
      context.current_user
    end

    def subscription_params
      {
        plan_id: context.params[:app_plan_id],
        user: current_user
      }
    end

    def make_subscription_in_app(subscription)
      if subscription.save!
        context.subscription = subscription
      else
        context.fail! message: 'Something went wrong!'
      end
    end

    def check_response(response)
      context.payment_attrs =
        {
          payment_intent_status: response[:payment_intent_status],
          payment_intent_client_secret: response[:payment_intent_client_secret],
          stripe_subscription_status: response[:stripe_subscription_status]
        }
    rescue StandardError => e
      context.fail! message: e.message
    end
  end
end
