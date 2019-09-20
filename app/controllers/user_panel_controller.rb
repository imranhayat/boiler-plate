class UserPanelController < ApplicationController
	before_action :authenticate_user

	def payment
		# @intent = Stripe::PaymentIntent.create({
	 #        amount: params[:amount],
	 #        currency: 'usd',
	 #        payment_method_types: ['card'],
	 #        description: current_user.email
	 #    })
	    
	    respond_to do |format|
	    	format.html {}
	    	format.js {}
	    end
	end
	private
		def authenticate_user
			if !(user_signed_in? and current_user.admin == false)
				redirect_back(fallback_location: root_url,alert: "You don't have permissions to access this page.")
			end
		end
end
