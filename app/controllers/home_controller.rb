class HomeController < ApplicationController
  def index
    @documents = Document.all
    @collections = Collection.all
    @docs_without_collection = Document.where(collection_id: nil)
  end
end
