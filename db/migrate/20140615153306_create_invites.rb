class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :uid
      t.references :group, index: true
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
