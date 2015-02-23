class AddBalanceToUserGroupRelationships < ActiveRecord::Migration
  def change
    add_monetize :user_group_relationships, :balance
  end
end
