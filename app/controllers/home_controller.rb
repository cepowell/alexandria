class HomeController < ApplicationController
  def index
    @documents = Document.all
    @collections = Collection.all
    @docs_without_collection = Document.where(collection_id: nil)
    @mydocs = Document.where(user_id: session[:user_id])
    @mycols = Collection.where(user_id: session[:user_id])
  end
end
