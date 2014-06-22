class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :creator, index: true
      t.references :group, index: true
      t.references :payer, index: true
      t.boolean :hidden, default: false
      t.money :spent

      t.timestamps
    end

    add_index :expenses, [:group_id, :payer_id, :hidden]
  end
end
