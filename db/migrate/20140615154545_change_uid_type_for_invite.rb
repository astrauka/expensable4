class ChangeUidTypeForInvite < ActiveRecord::Migration
  def change
    remove_column :invites, :uid
    add_column :invites, :uid, :string
    add_index  :invites, :uid
  end
end
