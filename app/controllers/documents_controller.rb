class DocumentsController < ApplicationController
  
  def allowed(document, perm)
    unless document.user_id == session[:user_id] || perm == "revise"
      redirect_to root_path
      flash[:alert] = "You don't have access to that page."
    end
  end
  
  def index
    redirect_to root_path
    flash[:alert] = "You don't have access to that page."
    @documents = Document.all
    @mydocs = Document.where(session[:user_id])
  end
  
  def new
  end
  
  def show
    begin
      sessionId = session[:user_id]
      @document = Document.find(params[:id])
      @attachments = getAttachments(@document)
      @comments = getComments(@document)
      @likes = getLikes(@document)
      @map = commentsMap(@comments)
      @likesmap = likesMap(@likes)
      if sessionId == @document.user_id
        @perm = "owner"
      else
        @perm = Permission.where(user_id: session[:user_id], document_id: @document.id).first.access
      end
      @curPermissions = Permission.where(document_id: params[:id])
      @mapAccess = Hash.new
      @curPermissions.each do |curPer|
        @mapAccess[curPer.id] = User.find(curPer.user_id).penname
      end
      #raise @mapAccess.to_s
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
    rescue 
      redirect_to root_path
      flash[:alert] = "You don't have access to that page."
    end
  end
  
  def create
    @document = Document.create(params[:document])
    @document.user_id = session[:user_id]
    if params.has_key?("isPublished")
      @document.isPublished = true
    end
    content = params[:document][:content]
    #raise params[:document]
    curFile = File.new(@document.title, "w")
    @document.content = curFile
    curFile.close 
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
    begin 
      @document = Document.find params[:id]
      @attachments = getAttachments(@document)
      if session[:user_id] == @document.user_id
        @perm = "owner"
      else
        @perm = Permission.where(user_id: session[:user_id], document_id: @document.id).first.access
      end
      allowed(@document, @perm)
      s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
      s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
      bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
      @curFile = bucket.objects["#{s3_file_path}"].read
      #raise @curFile
    rescue
      redirect_to root_path
      flash[:alert] = "You don't have access to that page."
    end
  end
  
  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:notice] = "Document '#{@document.title}' deleted."
    redirect_to home_index_path
  end
  #All sharing methods
  
  
  def share
    #raise params.inspect
    #raise params[:permissions].inspect
    current = User.find_by(id: session[:user_id])
    begin
      if params[:permission][:name] == current.penname
        flash[:alert] = "You can't share with yourself!"
        redirect_to request.referrer
      elsif params[:permission][:name] == current.email
        flash[:alert] = "You can't share with yourself!"
        redirect_to request.referrer
      elsif params[:permission][:name].include? '@'
        user = User.find_by(email: params[:permission][:name])
      else
        user = User.find_by(penName: params[:permission][:name])
      end
    rescue 
      flash[:alert] = 'Invalid user.'
      redirect_to request.referrer
    else
      if !user.nil?
        perm = Permission.where(user_id: user.id, document_id: params[:id]).first
        if perm!=nil
          perm.access=params[:permission][:access]
        else
            perm = Permission.create(user_id: user.id, document_id: params[:id], access: params[:permission][:access])
        end
        perm.save
        flash[:notice] = "You successfully shared this document with #{user.penname}"
        redirect_to request.referrer
      end
    end
  end
  
  def removeShare
    #raise params.inspect
    permission = Permission.find(params[:id])
    permission.destroy
    redirect_to request.referrer
  end
  
  def shared
    docIds = []
    perms = Permission.where(user_id: session[:user_id])
    perms.each do |perm| 
      docIds.push(perm.document_id)
    end
    @user = User.find(session[:user_id])
    @documents = Document.where(id: docIds)
    @attachments = Attachment.where(document_id: docIds)
    @map = commentsMap(@documents)
    @map2 = Hash.new
    perms.each do |perm|
      @map2[perm.document_id] = perm.access
    end
  end
end