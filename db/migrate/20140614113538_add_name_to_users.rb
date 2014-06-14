class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :short_name, :string
    add_column :users, :fb_name, :string
  end
end
