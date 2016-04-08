class UsersController < ApplicationController

# for users who want to sign up for access to site 
# without 3rd party auth

    skip_before_filter :set_current_user #:authorize 

    
    def new
		@user = User.new
	end 
	
    def create

        # raise params.to_yaml

    	@user = User.new(params[:user])
    	
    	if @user.save 
    		# session persists (cookies), so it sets the current user to something
    		# until the user signs up
    		session[:user_id] = @user.id 
    		
			flash[:notice] = "Thank you for signing up."
    		redirect_to home_index_path
		else 	
    		flash[:notice] = "Could not sign up!" 
            render "new"
        end
            
    end 
   

end
    