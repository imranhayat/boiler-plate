class UserPanelController < ApplicationController
	
	load_and_authorize_resource class: false

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

end