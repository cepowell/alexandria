# == Schema Information
#
# Table name: documents
#
#  id                   :integer         not null, primary key
#  user_id              :integer
#  collection_id        :integer
#  title                :string
#  content_file_name    :string
#  content_content_type :string
#  content_file_size    :integer
#  content_updated_at   :datetime
#  isPublished          :boolean
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

class Document < ActiveRecord::Base
  attr_accessible :title, :collection_id, :user_id, :tag_list
  has_attached_file :content
  do_not_validate_attachment_file_type :content
  #, :default_url => "/images/:style/missing-document"  #default page for non-existing document
  # validates_attachment_content_type :doc, :content_type => /\Afile\/.*\Z/
  belongs_to :user
  belongs_to :collection
  is_impressionable
  
  acts_as_taggable
end
