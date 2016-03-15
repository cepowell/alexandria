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
  belongs_to :users
  belongs_to :collections
end
