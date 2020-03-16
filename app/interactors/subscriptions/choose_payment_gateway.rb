# frozen_string_literal: true

module Subscriptions
  # :Interactor for Creating a Subscription:
  class ChoosePaymentGateway < BaseInteractor
    def call
      return unless context.params[:payment_gateway] == 'Stripe'

      subscription = current_user.build_subscription(
        subscription_params
      )
      call_stripe_subscription_adapter(subscription)
    end

    def current_user
      context.current_user
    end

    def subscription_params
      {
        plan_id: context.params[:app_plan_id]
      }
    end

    def call_stripe_subscription_adapter(subscription)
      response = StripeSubscriptionAdapter.new(
        subscription,
        context.params[:stripe_plan_id],
        context.params[:payment_method],
        current_user
      ).call
      check_response(response)
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
