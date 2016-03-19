# == Schema Information
#
# Table name: documents
#
#  id             :integer         not null, primary key
#  users_id       :integer
#  collections_id :integer
#  name           :string
#  filePath       :string
#  isPublished    :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Document < ActiveRecord::Base
  attr_accessible :name, :body
  # has_attached_file :document, :default_url => "/images/:style/missing-document"  #default page for non-existing document
  # validates_attachment_content_type :doc, :content_type => /\Afile\/.*\Z/
  belongs_to :users
  belongs_to :collections
end
