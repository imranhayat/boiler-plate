# frozen_string_literal: true

# :Plans Controller for managing plan actions:
class PlansController < ApplicationController
  load_and_authorize_resource
  before_action :set_plan, only: %i[show]

  def index
    @plans = Plan.all
  end

  def show; end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # POST /plans
  def create
    response = Plans::CreatePlan.call(plan_params: plan_params)
    if response.success?
      redirect_to plans_path, notice: 'Plan was successfully created.'
    else
      redirect_to new_plan_path, alert: 'Plan Error, Something went wrong'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def plan_params
    params.require(:plan).permit(:nickname, :amount, :currency,
                                 :interval, :interval_count)
  end
end
