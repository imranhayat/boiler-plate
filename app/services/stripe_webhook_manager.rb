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
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      # Invalid payload, Invalid signature
      { body: nil, status: :bad_request, message: e.message }
    end
  end

  # Different Events Handling
  def handle_events
    case @params[:type]
    when 'payment_intent.payment_failed'
      cancel_payment_intent
      change_user_status
    when 'payment_intent.succeeded'
      update_user
    when 'customer.subscription.updated'
      set_up_subscription
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

  def cancel_payment_intent
    intent_id = @params[:data][:object][:id]
    Stripe::PaymentIntent.cancel(intent_id)
  rescue Stripe::InvalidRequestError => e
    { message: e.message }
  end

  def change_user_status
    user_email =
      @params[:data][:object][:last_payment_error][:payment_method][:billing_details][:email]
    return unless user_email.present?

    user = User.find_by_email(user_email)
    return unless user.present?

    user.update(payment_status: false)
  end

  def update_user
    stripe_customer =
      @params[:data][:object][:charges][:data][0][:customer]
    return unless stripe_customer.present?

    customer_object = Stripe::Customer.retrieve(stripe_customer)
    user_email = customer_object.email
    user = User.find_by_email(user_email)
    user.update!(payment_status: true) if user.present?
  end

  def set_up_subscription
    if fetch_subscription.present?
      update_subscription
    else
      create_subscription
    end
  end

  def update_subscription
    metadata = @params[:data][:object][:metadata]
    if metadata[:plan_id].present?
      fetch_subscription.update!(
        cancel_at_period_end: @params[:data][:object][:cancel_at_period_end],
        current_period_start: @params[:data][:object][:current_period_start],
        current_period_end: @params[:data][:object][:current_period_end],
        plan_id: metadata[:plan_id]
      )
    else
      fetch_subscription.update!(
        cancel_at_period_end: @params[:data][:object][:cancel_at_period_end]
      )
    end
  end

  def create_subscription
    user_id = @params[:data][:object][:metadata][:user]
    user = User.find(user_id)
    return unless user.present?

    return unless @params[:data][:object][:status] == 'active'

    subscription = user.build_subscription(subscription_params)
    subscription.update!(
      stripe_id: @params[:data][:object][:id],
      cancel_at_period_end: @params[:data][:object][:cancel_at_period_end],
      current_period_start: @params[:data][:object][:current_period_start],
      current_period_end: @params[:data][:object][:current_period_end]
    )
  end

  def subscription_params
    {
      plan_id: @params[:data][:object][:metadata][:plan_id]
    }
  end

  def delete_app_subscription
    return unless fetch_subscription.present?

    fetch_subscription.user.update!(payment_status: false)
    fetch_subscription.destroy!
  end

  def update_customer
    customer = User.find_by_stripe_customer_id(@params[:data][:object][:id])
    return unless customer.present?

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
    return unless user.present?

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
