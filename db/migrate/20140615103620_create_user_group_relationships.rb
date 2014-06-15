class CreateUserGroupRelationships < ActiveRecord::Migration
  def change
    create_table :user_group_relationships do |t|
      t.references :user, index: true
      t.references :group

      t.timestamps
    end

    add_index :user_group_relationships, [:group_id, :user_id]
  end
end
