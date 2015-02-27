class ChangeParticipatingUserIdsToInteger < ActiveRecord::Migration
  def up
    unless column_exists?(:expenses, :participating_user_ids2)
      add_column :expenses, :participating_user_ids2, :integer, array: true, default: []
      add_index  :expenses, :participating_user_ids2, using: 'gin'
    end

    Expense.find_each do |expense|
      if expense.participating_user_ids
        expense.participating_user_ids2 = expense.participating_user_ids.map(&:to_i)
        expense.save!
      end
    end
  end

  def down
  end
end
