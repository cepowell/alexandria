# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first           :string
#  last            :string
#  email           :string
#  password        :string
#  password_digest :string
#  provider        :string
#  emailOptOut     :boolean
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class User < ActiveRecord::Base
    has_many :documents, :as => :user
    has_many :collections, :as => :user
    
    has_secure_password
    
    attr_accessible :first, :last, :email, :password, :password_digests, :penname, :description
    
    validates :email, presence: true, uniqueness: true
    validates :penname, presence: true, uniqueness: true
    
    # following code added to try and fix 3rd party auth
    # has_many :authorizations
    
    # def add_provider(auth_hash)
    #     # Check if the provider already exists, so we don't add it twice
    #     unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    #         Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    #     end
    # end
    
    #validates_uniqueness_of :email, :penname
    
    def self.from_omniauth(auth)
        where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
           user.provider = auth.provider
           user.uid = auth.uid
           user.email = SecureRandom.hex(9) #can use Faker gem to create fake email
           user.oauth_token = auth.credentials.token
           user.penname = auth.info.name #need to figure out how to format this correctly 
           # ["nickname", "ghtjg"]
           # user.oauth_expires_at = Time.at(auth.credentials.expires_at)
           if user.provider = 'twitter'
               user.password = SecureRandom.hex(9)
           end
           user.save!
        end
    end
    
end
