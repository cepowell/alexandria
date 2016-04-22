class LikesController < ApplicationController
    
    def new 
        document = Document.find(params[:like][:document_id])
        if !Like.where(user_id: session[:user_id], document_id: document.id).exists?
            like = Like.create(params[:like])
            like.save
            redirect_to request.referrer
        else
            redirect_to request.referrer
        end
    end
end
