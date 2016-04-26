class CollectionsController < ApplicationController
    
    def index
        @collections = Collection.all
        @mycols = Collection.where(user_id: session[:user_id])
    end
    
    def new
        @freeDocs = Document.where(collection_id: nil, user_id: session[:user_id])
    end
    
    def show
        id = params[:id]
        @collection = Collection.find(id)
        @comments = Comment.where(collection_id: @collection.id)
        @map = Hash.new
        @comments.each do |comment|
            @map[comment.id] = User.find(comment.user_id).penname
        end
        @likes = getColLikes(@collection)
        @likesmap = likesMap(@likes)
        unless session[:user_id] == @collection.user_id
            flash[:alert] = "You don't have access to this collection!"
            redirect_to root_path
        end
        if @collection.isPublished
          @pubStatus = "Published"
        else
          @pubStatus = "Private"
        end
        @curDocs = Document.where(collection_id: params[:id])
    end

    def edit
        @collection = Collection.find params[:id]
        @curDocs = Document.where(collection_id: params[:id])
        @freeDocs = Document.where(collection_id: nil, user_id: session[:user_id])

    end
    
    def create
        #raise params.inspect
        @collection = Collection.create(params[:collection])
        @collection.user_id = session[:user_id]
        if params.has_key?("isPublished")
          @collection.isPublished = true
        end
        @collection.save
        if params[:documents].present?
            params[:documents].keys.each do |id|
                doc = Document.find(id)
                doc.collection_id = @collection.id
                doc.save
            end
        end
        
        #associate files with collections
        
        
        redirect_to home_index_path
    end
    
    def update
        #raise params[:documents].keys.to_s
        @collection = Collection.find params[:id]
        if !params.has_key?("is_Published")
          @collection.isPublished = false
        else 
          @collection.isPublished = true
        end
        @collection.update_attributes(params[:collection])
        Document.where(collection_id: params[:id]).each do |doc|
            doc.collection_id = nil
            doc.save
        end
        if params[:documents].present?
            params[:documents].keys.each do |id|
                doc = Document.find(id)
                doc.collection_id = params[:id]
                doc.save
            end
        end
        redirect_to collection_path(@collection)
    end

    def destroy
        @collection = Collection.find(params[:id])
        @collection.destroy
        flash[:notice] = "Collection '#{@collection.name}' deleted."
        redirect_to home_index_path
    end
    
end
