class CollectionsController < ApplicationController
    
    def index
        @collections = Collection.all
    end
    
    def new
        @freeDocs = Document.where(collection_id: nil)
    end
    
    def show
        id = params[:id]
        @collection = Collection.find(id)
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
        @freeDocs = Document.where(collection_id: nil)
    end
    
    def create
        #raise params.inspect1
        @collection = Collection.create(params[:collection])
        @collection.save
        if params[:documents].present?
            params[:documents].keys.each do |id|
                doc = Document.find(id)
                doc.collection_id = @collection.id
                doc.save
            end
        end
        
        #associate files with collections
        
        
        redirect_to root_path
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
        redirect_to root_path
    end
    
end
