# frozen_string_literal: true

module Plans
  # :Interactor for Plan Creation:
  class CreatePlan < BaseInteractor
    def call
      if check_product_exists?
        make_plan_on_stripe
      else
        context.fail!
      end
    end

    def check_product_exists?
      return true if Product.count >= 1
    end

    def make_plan_on_stripe
      plan = Product.first.plans.new(context.plan_params)
      response = StripeAdapter.new(plan).call
      if response == true
        make_plan_in_app(plan)
      else
        context.fail!
      end
    end

    def make_plan_in_app(plan)
      if plan.save!
        context.plan = plan
      else
        context.fail!
      end
    end
  end
end
