# frozen_string_literal: true

# :Stripe Manager for handling webhooks for Stripe Events:
class StripeWebhookManager
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
    when 'customer.subscription.updated'
      update_subscription
    when 'customer.subscription.deleted'
      delete_app_subscription
    when 'customer.updated'
      update_customer
    when 'checkout.session.completed'
      update_user_payment_method
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

  def update_subscription
    metadata = @params[:data][:object][:metadata]
    if metadata[:plan_id].present?
      fetch_subscription.update!(
        cancel_at_period_end: @params[:data][:object][:cancel_at_period_end],
        plan_id: metadata[:plan_id]
      )
    else
      fetch_subscription.update!(
        cancel_at_period_end: @params[:data][:object][:cancel_at_period_end]
      )
    end
  end

  def delete_app_subscription
    fetch_subscription.user.update!(payment_status: false)
    fetch_subscription.destroy!
  end

  def update_customer
    customer = User.find_by_stripe_customer_id(@params[:data][:object][:id])
    customer.update!(
      stripe_payment_method_id:
      @params[:data][:object][:invoice_settings][:default_payment_method]
    )
  end

  def fetch_subscription
    Subscription.find_by_stripe_id(@params[:data][:object][:id])
  end

  def update_user_payment_method
    user_id = @params[:data][:object][:client_reference_id]
    user = User.find_by_id(user_id)
    return unless user

    setup_intent =
      Stripe::SetupIntent.retrieve(@params[:data][:object][:setup_intent])
    payment_method_id = setup_intent.payment_method
    user.update!(stripe_payment_method_id: payment_method_id)
    Stripe::PaymentMethod.attach(payment_method_id,
                                 customer: user.create_stripe_customer)
    update_default_payment_method(user.stripe_customer_id, payment_method_id)
  end

  def update_default_payment_method(customer_id, payment_method_id)
    Stripe::Customer.update(
      customer_id,
      invoice_settings: {
        default_payment_method: payment_method_id
      }
    )
  end

  def handle_bad_requests
    { body: nil, status: :bad_request }
  end
end
