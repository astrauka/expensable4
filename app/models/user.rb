class User < ActiveRecord::Base
  devise :rememberable, :trackable, :database_authenticatable,
         :omniauthable, omniauth_providers: %w(facebook)

  has_many :user_group_relationships,
           dependent: :destroy
  has_many :groups,
           through: :user_group_relationships

  has_many :created_expenses,
           class_name: "Expense",
           inverse_of: :creator,
           foreign_key: :creator_id

  has_many :paid_expenses,
           class_name: "Expense",
           inverse_of: :payer,
           foreign_key: :payer_id

  has_one :identity, dependent: :destroy

  validates :email, email: true

  def to_s
    name
  end

  def name
    [first_name, last_name].join(' ')
  end
end
