class Group < ActiveRecord::Base
  has_many :user_group_relationships
  has_many :users, through: :user_group_relationships

  validates :name, presence: true
end
