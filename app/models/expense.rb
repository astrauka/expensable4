class Expense < ActiveRecord::Base
  belongs_to :creator,
             class_name: 'User',
             inverse_of: :created_expenses
  belongs_to :group
  belongs_to :payer,
             class_name: 'User',
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

  # filter
  scope :visible_for, ->(user) do
    where("hidden = false OR '?' = ANY (participating_user_ids)", user.id)
  end

  # order
  scope :by_created_at_desc, -> { order created_at: :desc }

  def to_s
    description
  end

  def participating_users
    if participating_user_ids.any?
      User.find(participating_user_ids)
    else
      User.none
    end
  end
end
