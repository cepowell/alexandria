# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  first       :string
#  last        :string
#  email       :string
#  password    :string
#  emailOptOut :boolean
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class User < ActiveRecord::Base
    has_many :documents, as :users
    has_many :collections, as: :users
end
