class Share < ActiveRecord::Base
  belongs_to :expense
  belongs_to :user

  monetize :single_price_cents

  delegate :name, :shortened_name, to: :user, prefix: true

  # filter
  scope :for_user, ->(user) { where user_id: user.id }

  # order
  scope :by_user_name, -> { includes(:user).order('users.name') }

  def total_price_cents
    single_price_cents * multiplier
  end

  def total_price
    Money.new(total_price_cents)
  end
end
