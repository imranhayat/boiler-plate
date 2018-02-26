class HomeController < ApplicationController
    before_action :authenticate_user!
    def home
    end
    
    def admin
        # render :layout => false
        # byebug
    end
end
