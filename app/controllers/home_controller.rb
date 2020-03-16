# frozen_string_literal: true

# :Home Controller:
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :webhooks

  def webhooks
    WebhookManager.new(
      request.body.read,
      request,
      params
    ).call
  end
end
