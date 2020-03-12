# frozen_string_literal: true

# Users Module
module Users
  # :Interactor for Updating user credit card details:
  class UpdateStripeCardDetails < BaseInteractor
    def call
      update_card_details
    rescue Stripe::InvalidRequestError,
           Stripe::StripeError,
           Stripe::APIConnectionError,
           Stripe::CardError,
           Stripe::RateLimitError,
           Stripe::AuthenticationError => e
      context.fail! message:
                    "Stripe error while updating card info: #{e.message}"
    end

    def update_card_details
      p Stripe::Customer.update(
        context.current_user.stripe_customer_id,
        source: context.params[:stripeToken]
      )
    end
  end
end
