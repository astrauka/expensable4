class User < ActiveRecord::Base
  devise :rememberable, :trackable, :database_authenticatable,
         :omniauthable, omniauth_providers: %w(facebook)

  has_many :user_group_relationships,
           dependent: :destroy
  has_many :groups,
           through: :user_group_relationships

  has_one :identity, dependent: :destroy

  validates :email, email: true
end
