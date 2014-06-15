class Group < ActiveRecord::Base
  has_many :user_group_relationships,
           dependent: :destroy

  has_many :users,
           through: :user_group_relationships

  has_many :invites, dependent: :destroy

  validates :name, presence: true
end
