# frozen_string_literal: true

# :Stripe Manager for handling webhooks for Stripe Events:
class WebhookManager
  def initialize(read_body_request, request, params)
    @read_body_request = read_body_request
    @request = request
    @params = params
  end

  def call
    ensuring_security
    handle_events
  end

  def ensuring_security
    # To Ensure the Security that the events are coming from a trusted source
    payload = @read_body_request
    sig_header = @request.env['HTTP_STRIPE_SIGNATURE']
    begin
      Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_ENDPOINT_SECRET']
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      # Invalid payload, Invalid signature
      render body: nil, status: :bad_request
      return
    end
  end

  # Different Events Handling
  def handle_events
    case @params[:type]
    when 'product.created'
      update_app_product
    when 'plan.created'
      update_app_plan
    when 'payment_intent.payment_failed'
      run_the_job
    when 'payment_intent.succeeded'
      update_user
    else
      handle_bad_requests
    end
  end

  def update_app_product
    app_product_name = @params[:data][:object][:name]
    product = Product.find_by_name(app_product_name)
    product.update!(stripe_id: @params[:data][:object][:id])
  end

  def update_app_plan
    app_plan_name = @params[:data][:object][:nickname]
    plan = Plan.find_by_nickname(app_plan_name)
    plan.update!(stripe_id: @params[:data][:object][:id])
  end

  def run_the_job
    intent_id = params[:data][:object][:id]
    PaymentIntentJob.perform_later(intent_id)
    redirect_to(root_path)
  end

  def update_user
    stripe_customer =
      @params[:data][:object][:charges][:data][0][:customer]
    customer_object = Stripe::Customer.retrieve(stripe_customer)
    user_email = customer_object.email
    user = User.find_by_email(user_email)
    user.update!(payment_status: true) if user.present?
  end

  def handle_bad_requests
    retrun body: nil, status: :bad_request
  end
end
