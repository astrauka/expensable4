class AddBalanceToUserGroupRelationships < ActiveRecord::Migration
  def change
    add_money :user_group_relationships, :balance
  end
end
