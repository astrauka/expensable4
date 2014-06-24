class Share < ActiveRecord::Base
  belongs_to :expense
  belongs_to :user

  monetize :single_price_cents

  def total_price
    single_price * multiplier
  end
end
