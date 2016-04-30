# == Schema Information
#
# Table name: comments
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  document_id   :integer
#  collection_id :integer
#  body          :text
#  flagged       :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Comment < ActiveRecord::Base
  attr_accessible :body, :document_id, :user_id, :collection_id
  belongs_to :user
  belongs_to :document
  belongs_to :collection
end
