class UserPanelController < ApplicationController
	before_action :authenticate_user
	def index
	end

	private
		def authenticate_user
			if !(user_signed_in? and current_user.admin == false)
				redirect_back(fallback_location: root_url,alert: "You don't have permissions to access this page.")
			end
		end
end
