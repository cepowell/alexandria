# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  uid             :integer         not null
#  first           :string
#  last            :string
#  email           :string
#  password        :string
#  emailOptOut     :boolean
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string
#  provider        :string
#

class User < ActiveRecord::Base
    has_many :documents, :as => :user
    has_many :collections, :as => :user
    has_secure_password
    
    attr_accessible :name, :email, :password, :password_confirmation
    
    validates_uniqueness_of :email
    
    # def self.create_with_omniauth(auth)
    # create! do |user|
      #  user.provider = auth["provider"]
       # user.uid = auth["uid"]
        # user.first = auth["info"]["name"]
        # end
    #end
    # def self.create_with_omniauth(auth, user_id)
  #  @authentication = Authentication.create(:user_id  => user_id, 
    #                                       :provider => auth[:provider],
     #                                 :uid      => auth[:uid])
    #end
    
end
