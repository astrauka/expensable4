class RemoveTotalPriceFromShare < ActiveRecord::Migration
  def change
    remove_money :shares, :total_price
  end
end
