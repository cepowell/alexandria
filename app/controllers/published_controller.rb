class PublishedController < ApplicationController
    def index
        @publishedDocs = Document.where(isPublished: true)
        @publishedCols = Collection.where(isPublished: true)
    end
    
    def showDoc
        @document = Document.find(params[:id])
        s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
        s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
        bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
        @file = bucket.objects["#{s3_file_path}"].read
    end
    
    def showCol
        @collection = Collection.find(params[:id])
        @docsInCol = Document.where(collection_id: params[:id])
    end
       
    def showDocInCol
        @document = Document.find(params[:id])
        @collection = Collection.find(@document.collection_id)
        s3_file_path ="documents/documents/000/000/#{format("%03d", @document.id)}/original/#{@document.content_file_name}"
        s3 = AWS::S3.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
        bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
        @file = bucket.objects["#{s3_file_path}"].read
    end
end