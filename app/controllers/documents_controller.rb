class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end
  
  def show
    id = params[:id]
    @document = Document.find(id)
    if @document.isPublished
      @pubStatus = "Published"
    else
      @pubStatus = "Private"
    end
    s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
    s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
    @file = bucket.objects["#{s3_file_path}"].read
    #@file = Paperclip.io_adapters.for(@document.content).read
  end
  
  def new
    
  end
  
  def create
    @document = Document.create(params[:document])
    content = params[:document][:content]
    #raise params[:document]
    curFile = File.new(@document.title, "w")
    @document.content = curFile
    #curFile.close 
    @document.save
    s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
    s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
    bucket.objects["#{s3_file_path}"].write(content)
    redirect_to document_path(@document)
  end
  
  def update
    @document = Document.find params[:id]
    if !params.has_key?("is_Published")
      @document.isPublished = false
    else 
      @document.isPublished = true
    end
    content = params[:document][:content]
    s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
    s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
    bucket.objects["#{s3_file_path}"].write(content)
    #raise @document
    #file = File.open(@document.document.path, "w")
    #file.write params[:document][:content]
    #file.close
    if @document.update_attributes(params[:document])
      redirect_to document_path(@document)
    #curFile = File.open(params[:name]+".txt")
    #curFile.write(params[:body])
    #curFile.close 
    end
  end
  
  def edit
    @document = Document.find params[:id]
    s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
    s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
    @curFile = bucket.objects["#{s3_file_path}"].read
    #raise @curFile
  end
  
  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:notice] = "Document '#{@document.title}' deleted."
    redirect_to root_path  
  end
  
  
end