class RemoveParticipatingUserIdsText < ActiveRecord::Migration
  def change
    remove_column :expenses, :participating_user_ids3
  end
end
