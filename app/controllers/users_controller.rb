class UsersController < ApplicationController

# for users who want to sign up for access to site 
# without 3rd party auth

    skip_before_filter :set_current_user #:authorize 
    
    def new
        @user = User.new
    end 
	
	def update
		@user = User.find(session[:user_id])
	    if @user.update_attributes(params[:user])
            redirect_to user_path(@user)
    	end
	end
	
	def show
		@current_user = true
	    #@user = User.find(session[:user_id])
	    @current = User.find(session[:user_id])
	    @user = User.find(params[:id])
	end
	
	def edit
		@current_user = true
	    @user = User.find(session[:user_id])
	end
	
    def create

        # raise params.to_yaml

    	@user = User.new(params[:user])
    	
    	if @user.save 
    		# session persists (cookies), so it sets the current user to something
    		# until the user signs up
    		session[:user_id] = @user.id 
    		
			flash[:notice] = "Welcome, #{@user.penname}!"
    		redirect_to home_index_path
		else 	
    		flash[:alert] = "That penname or email is taken!" 
            render "new"
        end
            
    end 
   

end
    