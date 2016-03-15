# == Schema Information
#
# Table name: collections
#
#  id          :integer         not null, primary key
#  users_id    :integer
#  isPublished :boolean
#  name        :string
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Collection < ActiveRecord::Base
  belongs_to :users
end
