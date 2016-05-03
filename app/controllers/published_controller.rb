class PublishedController < ApplicationController
    
    def index
        #raise params.inspect
        
        if params[:search]
            
            # to do mutliple tag/ tag + penname searching:
            # searchString = params[:search].split(", ")
            # masterList for both Docs and Cols to iterate through the searchString and
            # append all qualifying instances 
            # at end of the loop, set @publishedDocs/Cols to be their corresponding MasterList
            
            theUser = User.find_by(penname: params[:search])
            taggedDocs = Document.where(isPublished: true).tagged_with(params[:search])
            taggedCols = Collection.where(isPublished: true).tagged_with(params[:search])
            
            if !theUser.nil?
                pennameDocs = Document.where(isPublished: true, user_id: theUser.id)
                @publishedDocs = taggedDocs + pennameDocs
                
                pennameCols = Collection.where(isPublished: true, user_id: theUser.id)
                @publishedCols = taggedCols + pennameCols
            else
                @publishedDocs = taggedDocs
                @publishedCols = taggedCols
            end
           
            params.delete :search
        
        else
            @publishedDocs = Document.where(isPublished: true)
            @publishedCols = Collection.where(isPublished: true)
        end
    end
    
    def showDoc
        #raise session[:user_id].nil?.inspect
        @document = Document.find(params[:id])
        impressionist(@document)
        s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
        s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
        bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
        @file = bucket.objects["#{s3_file_path}"].read
        
        @attachments = getAttachments(@document)
        @comments = getComments(@document)
        @map = commentsMap(@comments)
        @likes = getLikes(@document)
        @likesmap = likesMap(@likes)
        
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
            @map[comment.id] = User.find(comment.user_id).penname
        end
        @likes = getColLikes(@collection)
        @likesmap = likesMap(@likes)
        @notSignedIn = session[:user_id].nil?
        if !@notSignedIn
            @user = User.find(session[:user_id])
        end
    end
       
    def showDocInCol
        @document = Document.find(params[:id])
        impressionist(@document)
        @collection = Collection.find(@document.collection_id)
        s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
        s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
        bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
        @file = bucket.objects["#{s3_file_path}"].read
        @attachments = getAttachments(@document)
        @comments = getComments(@document)
        @map = commentsMap(@comments)
        @likes = getLikes(@document)
        @likesmap = likesMap(@likes)
        @notSignedIn = session[:user_id].nil?
        if !@notSignedIn
            @user = User.find(session[:user_id])
        end
    end
    
    def search
        @publishedDocs = Document.where(isPublished: true)
        @publishedCols = Collection.where(isPublished: true)
        
        @collectionResults = @publishedCols.tagged_with(:search)
        @documentResults = @publishedDocs.tagged_with(:search)
    end
    
end