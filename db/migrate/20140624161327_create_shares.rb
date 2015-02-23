class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :expense, index: true
      t.integer :multiplier
      t.monetize :single_price, currency: { present: false }
      t.monetize :total_price, currency: { present: false }

      t.timestamps
    end
  end
end
