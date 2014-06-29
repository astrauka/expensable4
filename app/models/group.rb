class Group < ActiveRecord::Base
  has_many :user_group_relationships,
           dependent: :destroy
  has_many :active_user_group_relationships,
           -> { where(active: true) },
           class_name: 'UserGroupRelationship'

  has_many :users,
           through: :user_group_relationships
  has_many :active_users,
           through: :active_user_group_relationships,
           source: :user

  has_many :invites, dependent: :destroy
  has_many :expenses, dependent: :destroy

  belongs_to :creator,
             class_name: 'User'

  validates :name, presence: true

  def balance_for(user)
    user_group_relationships.for_user(user).first.try(:balance)
  end
end
