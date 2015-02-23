class RemoveTotalPriceFromShare < ActiveRecord::Migration
  def change
    remove_monetize :shares, :total_price
  end
end
