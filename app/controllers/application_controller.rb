class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # IS NOT CURRENTLY WORKING. NEED TO FIX
  # for setting user, authorizing them
  before_filter :set_current_user
  
  # this line causes too many redirects to happen => error 
  # before_filter :set_current_user, :authorize
  
  
  # for user authentication, taken directly from myrottenpotatoes
  protected # prevents method from being invoked by a route
  def set_current_user #creates this variable that we are going to use later on and will be stored in user table
    # we exploit the fact that find_by_id(nil) returns nil
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    #redirect_to login_path and return unless @current_user
  end
  
  def authorize
    redirect_to loginuser_path, alert: "Not Authorized" if session[:user_id].nil?
  end
  
  def getLikes(doc)
    return Like.where(document_id: doc.id)
  end
  
  def likesMap(likes)
    map = Hash.new
    likes.each do |like|
      map[like.id] = User.find(like.user_id).penname
    end
    return map
  end
  
  def getComments(doc)
    return Comment.where(document_id: doc.id)
  end
  
  def commentsMap(comments)
    map = Hash.new
    comments.each do |comment|
        map[comment.id] = User.find(comment.user_id).first
    end
    return map
  end
end
