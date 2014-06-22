class CreateRemoveCurrencyFromExpenses < ActiveRecord::Migration
  def up
    remove_column :expenses, :spent_currency if column_exists?(:expenses, :spent_currency)
    remove_column :expenses, :spent_cents if column_exists?(:expenses, :spent_cents)
    add_money :expenses, :spent, currency: { present: false }
  end

  def down
  end
end
