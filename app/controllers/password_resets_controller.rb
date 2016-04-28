class PasswordResetsController < ApplicationController
  
  before_action :get_user,   only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:alert] = "Email address not found."
      redirect_to request.referrer
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      flash[:alert] = "Password can't be empty."
      redirect_to request.referrer
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      redirect_to request.referrer
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def log_in(user)
        session[:user_id] = user.id
    end
  
end
