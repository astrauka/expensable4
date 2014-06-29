class AddUniqueIndexOnUserGroupRelationship < ActiveRecord::Migration
  def change
    add_index :user_group_relationships, [:user_id, :group_id], unique: true
  end
end
