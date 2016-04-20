class LikesController < ApplicationController
    
    def new 
        like = Like.create(params[:like])
        like.save
        redirect_to request.referrer
    end
end
