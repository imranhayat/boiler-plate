# frozen_string_literal: true

module Subscriptions
  # :Interactor for Creating a Subscription:
  class ChoosePaymentGateway < BaseInteractor
    def call
      return unless context.params[:payment_gateway] == 'Stripe'

      subscription = current_user.build_subscription(
        subscription_params
      )
      call_subscription_adapter(subscription)
    end

    def current_user
      context.current_user
    end

    def subscription_params
      {
        plan_id: context.params[:app_plan_id]
      }
    end

    def call_subscription_adapter(subscription)
      response = StripeSubscriptionAdapter.new(
        subscription,
        context.params[:stripe_plan_id],
        context.params[:payment_method],
        current_user
      ).call
      check_response(response, subscription)
    end

    def check_response(response, subscription)
      if response[:success] == true
        make_subscription_in_app(subscription)
      else
        context.fail! message: response[:error]
      end
    end

    def make_subscription_in_app(subscription)
      if subscription.save!
        context.subscription = subscription
      else
        context.fail! message: 'Something went wrong!'
      end
    end
  end
end
