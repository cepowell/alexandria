class CollectionsController < ApplicationController
    
    def index
        @collections = Collection.all
    end
    
    def new
        @freeDocs = Document.where(collections_id: nil)
    end
    
    def show
        id = params[:id]
        @collection = Collection.find(id)
        if @collection.isPublished
          @pubStatus = "Published"
        else
          @pubStatus = "Private"
        end
        @curDocs = Document.where(collections_id: params[:id])
    end

    def edit
        @collection = Collection.find params[:id]
        @curDocs = Document.where(collections_id: params[:id])
        @freeDocs = Document.where(collections_id: nil)
    end
    
    def create
        #raise params[:documents]
        @collection = Collection.create(params[:collection])
        if params[:documents].present?
            params[:documents].keys.each do |id|
                doc = Document.find(id)
                doc.collections_id = @collection.id
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
        Document.where(collections_id: params[:id]).each do |doc|
            doc.collections_id = nil
            doc.save
        end
        params[:documents].keys.each do |id|
            doc = Document.find(id)
            doc.collections_id = params[:id]
            doc.save
        end
        redirect_to collection_path(@collection)
    end

    def destroy
        @collection = Collection.find(params[:id])
        @collection.destroy
        redirect_to root_path
    end
    
    def createDocument
        @collection = Collection.find(params[:id])
        @document = Document.create(params[:document])
        @document.collections_id = params[:id]
    end
end
