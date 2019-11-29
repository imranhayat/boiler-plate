class UserPanelController < ApplicationController
	
	before_action :authenticate_user

	def payment
		@amount = (params[:amount].to_f * 100).to_i
		@intent = Stripe::PaymentIntent.create({
			amount: @amount,
			currency: 'usd',
			payment_method_types: ['card'],
			description: current_user.email
		})
		respond_to do |format|
			format.html {}
			format.js {}
		end
	end

	private
		def authenticate_user
			if user_signed_in? and current_user.has_role? :admin
				redirect_back(fallback_location: admin_panel_path, alert: "You don't have permissions to access this page.")
			end
		end

end