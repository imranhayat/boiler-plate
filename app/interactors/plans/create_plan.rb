# frozen_string_literal: true

module Plans
  # :Interactor for Plan Creation:
  class CreatePlan < BaseInteractor
    def call
      plan = Product.first.plans.new(context.plan_params)
      if plan.save!
        context.plan = plan
        StripeAdapter.new(plan).call('Plan')
      else
        context.fail!(message: plan.errors.full_messages.to_sentence)
      end
    end
  end
end
