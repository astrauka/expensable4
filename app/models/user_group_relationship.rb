class UserGroupRelationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  monetize :balance_cents

  scope :for_group, ->(group) { where group_id: Array.wrap(group).map(&:id) }
  scope :for_user, ->(user) { where user_id: Array.wrap(user).map(&:id) }
end
