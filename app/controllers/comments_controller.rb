class CommentsController < ApplicationController
    def new
        #raise raise request.referrer
        comment = Comment.create(params[:comment])
        comment.save
        redirect_to request.referrer
    end
end
