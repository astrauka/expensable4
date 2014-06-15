class Invite < ActiveRecord::Base
  belongs_to :group

  validates :uid, presence: true
  validates :group, presence: true

  scope :not_accepted, -> { where accepted: false }
  scope :for_uid, ->(uid) { where uid: uid }
end
