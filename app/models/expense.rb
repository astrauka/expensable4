class Expense < ActiveRecord::Base
  belongs_to :creator,
             class_name: "User",
             inverse_of: :created_expenses
  belongs_to :group
  belongs_to :payer,
             class_name: "User",
             inverse_of: :paid_expenses

  has_many :shares,
           dependent: :destroy

  has_many :sharing_users,
           through: :shares,
           source: :user

  monetize :spent_cents

  validates :creator, presence: true
  validates :group, presence: true
  validates :payer, presence: true
  validates :spent, presence: true
  validates :description, presence: true
end
