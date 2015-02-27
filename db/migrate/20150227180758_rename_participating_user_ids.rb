class RenameParticipatingUserIds < ActiveRecord::Migration
  def up
    rename_column :expenses, :participating_user_ids, :participating_user_ids3
    rename_column :expenses, :participating_user_ids2, :participating_user_ids
  end

  def down
  end
end
