class CollectionsController < ApplicationController
    
    def index
        @collections = Collection.all
    end
    
    def new
    
    end
    
    def show
        id = params[:id]
        @collection = Collection.find(id)
        @documents_with_id = Document.where(collections_id: params[:id])
    end

    def edit
        @collection = Collection.find params[:id]
    end
    
    def create
        @collection = Collection.create(params[:collection])
        redirect_to root_path
    end
    
    def update
        @collection = Collection.find params[:id]
        @collection.update_attributes(params[:collection])
        redirect_to root_path
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
