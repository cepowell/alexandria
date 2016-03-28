class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end
  
  def show
    id = params[:id]
    @document = Document.find(id)
    @file = Paperclip.io_adapters.for(@document.document).read
  end
  
  def new
    
  end
  
  def create
    @document = Document.create(params[:document])
    #@document.collections_id = 1
    #raise params[:document]
    curFile = File.new(@document.name, "w")
    @document.document = curFile
    curFile.close 
    @document.save
    file = File.open(@document.document.path, "w")
    file.write params[:document][:content]
    file.close
    redirect_to root_path
  end
  
  def update
    @document = Document.find params[:id]
    #raise @document
    file = File.open(@document.document.path, "w")
    file.write params[:document][:content]
    file.close
    if @document.update_attributes(params[:document])
      redirect_to document_path(@document)
    #curFile = File.open(params[:name]+".txt")
    #curFile.write(params[:body])
    #curFile.close 
    end
  end
  
  def edit
    @document = Document.find params[:id]
    @curFile = Paperclip.io_adapters.for(@document.document).read
    #raise @curFile
  end
  
  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:notice] = "Document '#{@document.name}' deleted."
    redirect_to root_path  
  end
  
  
end