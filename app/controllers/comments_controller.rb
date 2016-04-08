class CommentsController < ApplicationController
    def new
        #raise params[:comment].inspect
        comment = Comment.create(params[:comment])
        comment.save
        redirect_to request.referrer
    end
        
end
