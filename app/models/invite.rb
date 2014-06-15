class Invite < ActiveRecord::Base
  belongs_to :group

  validates :uid, presence: true
  validates :group, presence: true
end
