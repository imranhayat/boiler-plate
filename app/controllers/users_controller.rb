class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            redirect_to edit_user_path, notice: "User profile updated successfully"
        else
            redirect_to edit_user_path, notice: @user.errors.full_messages.join
        end
    end
    
    private
    def user_params
        params.require(:user).permit(:name, :username,:phone_number,:identifier,:company_name,:linkedin_link,:githhub_link,:website_link,:portfolio,:other_link1,:other_link2,:other_link3,:experience)
    end
end
