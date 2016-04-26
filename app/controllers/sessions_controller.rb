class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :set_current_user #:authorize
  
  # creates a new user with the 3rd party auth via Twitter
  def create
    
    
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
    
    #render :text => auth_hash.inspect
    #raise request.env["omniauth.auth"].to_yaml
 
    #Original
    # user=Authorization.find_by_provider_and_uid(auth["provider"],auth["uid"]) || Authorization.create_with_omniauth(auth)
    # #session[:user_id] = user.id
    #redirect_to root_path
    
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
    #user = User.find_by_email(params[:user][:email]) || User.find_by(penname: params[:user][:penname])
    begin
      if params[:permission][:name].include? '@'
        user = User.find_by(email: params[:permission][:name])
      else
        user = User.find_by(penname: params[:permission][:name])
      end
    rescue 
      flash[:alert] = 'Invalid login credentials.'
      redirect_to request.referrer
    end
    # user.authenticate calls bcrypt to check if email and passwrd match a db entry
    if user && user.authenticate(params[:user][:password])
      # after we log in a user, we set their id, because we need it for before_filter
      session[:user_id] = user.id
      
      session[:provider] = nil   
      flash[:notice] = "Welcome, #{user.penname}!" 
      redirect_to root_path 
    else
      flash[:alert] = "Invalid login credentials." 
      redirect_to root_path
    end    

  end 
  
  def failure
    flash[:notice] = "Sorry, but you didn't allow access to Alexandria."
  end
  
end