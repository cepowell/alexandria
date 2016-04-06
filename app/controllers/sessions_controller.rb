class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :set_current_user, #:authorize
  
  # creates a new user with the 3rd party auth via Twitter
  def create
    auth = request.env['omniauth.auth']
    
    #raise request.env["omniauth.auth"].to_yaml
    
    #find_by_provider_and_uid
    # testing a quick change
     # creates a user from the 3rd party information we got
    user=User.find_by_provider_and_uid(["provider"], auth["uid"]) || 
    User.create_with_omniauth(auth)
    session[:user_id] = user.uid
    redirect_to root_path
  end
  
  def destroy
    session.delete(:user_id)
    flash[:notice] = 'Logged out successfully.'
    redirect_to root_path
  end
  
  # following methods to be used for logging in the users
  
  # new just presents the user with a nice view
  def new
    #user wants to log in 
  end 
  
  def find    
      
    #raise params.to_yaml
    
    #raise params[:user][:email].inspect

    user = User.find_by_email(params[:user][:email]) 

    # user.authenticate calls bcrypt to check if email and passwrd match a db entry
    if user && user.authenticate(params[:user][:password])
      # after we log in a user, we set their id, because we need it for before_filter
      session[:user_id] = user.uid
      
      session[:provider] = nil   
      flash[:notice] = "logged in!" 
      redirect_to root_path 
    else
      flash[:notice] = "Could not log in!" 
      redirect_to root_path
    end    

  end  
end