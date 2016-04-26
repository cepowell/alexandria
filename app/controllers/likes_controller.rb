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
    
    def unlike
        document = Document.find(params[:like][:document_id])
        if Like.where(user_id: session[:user_id], document_id: document.id).exists?
            unlike = Like.find_by(user_id: session[:user_id], document_id: document.id)
            #raise unlike.inspect
            unlike.destroy
        end
        redirect_to request.referrer
    end
    
    def newColLike
        collection = Collection.find(params[:like][:collection_id])
        if !Like.where(user_id: session[:user_id], collection_id: collection.id).exists?
            like = Like.create(params[:like])
            like.save
            redirect_to request.referrer
        else
            redirect_to request.referrer
        end
    end
    
    def colUnlike
        collection = Collection.find(params[:like][:collection_id])
        if Like.where(user_id: session[:user_id], collection_id: collection.id).exists?
            unlike = Like.find_by(user_id: session[:user_id], collection_id: collection.id)
            #raise unlike.inspect
            unlike.destroy
        end
        redirect_to request.referrer
    end
end
