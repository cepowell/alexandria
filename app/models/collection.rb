# == Schema Information
#
# Table name: collections
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  isPublished :boolean
#  name        :string
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Collection < ActiveRecord::Base
    attr_accessible :name
    belongs_to :users
    has_many :documents
end
