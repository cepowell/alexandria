class HomeController < ApplicationController
  def index
    @documents = Document.all
    @collections = Collection.all
  end
end
