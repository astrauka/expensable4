class AddParticipatingUserIdsToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :participating_user_ids, :text, array: true, default: []
    add_index  :expenses, :participating_user_ids, using: 'gin'
  end
end
