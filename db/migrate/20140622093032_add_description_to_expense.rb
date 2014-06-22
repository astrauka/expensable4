class AddDescriptionToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :description, :string
  end
end
