# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string
#  uid        :string
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Authorization < ActiveRecord::Base
    attr_accessible :name, :provider, :uid
    # user_id
    # , :user 
    # belongs_to :user
    
    # validates :provider, :uid, presence: true
    
    # def self.find_or_create(auth_hash)
    #     unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    #         user = User.create :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
    #         auth = create :user => user, :provider => auth_hash["provider"], :uid => auth_hash["uid"]    
    #     end
    #     auth
    # end
    
    def self.create_with_omniauth(auth)
        Authorization.create!(
            :provider => auth["provider"],
            :uid => auth["uid"],
            :name => auth["info"]["name"])
            
    end
    
end
