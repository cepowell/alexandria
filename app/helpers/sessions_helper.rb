module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end
    
    def logged_in
        !!current_user
    end
    
    def current_user
        @current_user ||= User.find(session[user.id]) if session[:user_id]
    end
end
