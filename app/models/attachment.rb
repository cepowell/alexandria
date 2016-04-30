# == Schema Information
#
# Table name: attachments
#
#  id                :integer         not null, primary key
#  name              :string
#  user_id           :integer
#  document_id       :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#

class Attachment < ActiveRecord::Base
    attr_accessible :name, :document_id, :user_id, :file
    belongs_to :user
    belongs_to :document
    has_attached_file :file,
                :storage => :s3,
                :s3_credentials => {:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']},
                :bucket => ENV['S3_BUCKET_NAME']
    do_not_validate_attachment_file_type :file
end
