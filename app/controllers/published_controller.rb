class PublishedController < ApplicationController
    
    def index
        #raise params.inspect
        @publishedDocs = Document.where(isPublished: true)
        @publishedCols = Collection.where(isPublished: true)
    end
    
    def showDoc
        #raise session[:user_id].nil?.inspect
        @document = Document.find(params[:id])
        impressionist(@document)
        s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
        s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
        bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
        @file = bucket.objects["#{s3_file_path}"].read
        
        @comments = getComments(@document)
        @map = commentsMap(@comments)
        
        @notSignedIn = session[:user_id].nil?
        if !@notSignedIn
            @user = User.find(session[:user_id])
        end
    end
    
    def showCol
        @collection = Collection.find(params[:id])
        @docsInCol = Document.where(collection_id: params[:id], isPublished: true)
        @comments = Comment.where(collection_id: @collection.id)
        @map = Hash.new
        @comments.each do |comment|
            @map[comment.id] = User.find(comment.user_id).first
        end
        @notSignedIn = session[:user_id].nil?
        if !@notSignedIn
            @user = User.find(session[:user_id])
        end
    end
       
    def showDocInCol
        @document = Document.find(params[:id])
        @collection = Collection.find(@document.collection_id)
        s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
        s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
        bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
        @file = bucket.objects["#{s3_file_path}"].read
        @comments = getComments(@document)
        @map = commentsMap(@comments)
        @notSignedIn = session[:user_id].nil?
        if !@notSignedIn
            @user = User.find(session[:user_id])
        end
    end
end