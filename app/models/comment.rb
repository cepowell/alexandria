class Comment < ActiveRecord::Base
  attr_accessible :body, :document_id, :user_id, :collection_id
  belongs_to :user
  belongs_to :document
  belongs_to :collection
end
