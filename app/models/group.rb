class Group < ActiveRecord::Base
  has_many :user_group_relationships,
           dependent: :destroy
  has_many :active_user_group_relationships,
           -> { where(active: true) },
           class_name: "UserGroupRelationship"

  has_many :users,
           through: :user_group_relationships
  has_many :active_users,
           through: :active_user_group_relationships,
           source: :user

  has_many :invites, dependent: :destroy
  has_many :expenses

  validates :name, presence: true
end
