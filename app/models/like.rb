class Like < ActiveRecord::Base
  attr_accessible :document_id, :user_id, :collection_id
  belongs_to :user
  belongs_to :document
  belongs_to :collection
end