class HomeController < ApplicationController
  def index
    @documents = Document.all
    @collections = Collection.all
    @docs_without_collection = Document.where(collections_id: nil)
  end
end
