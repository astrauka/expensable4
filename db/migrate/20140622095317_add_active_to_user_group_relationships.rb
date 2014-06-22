class AddActiveToUserGroupRelationships < ActiveRecord::Migration
  def change
    add_column :user_group_relationships, :active, :boolean, default: true
  end
end
