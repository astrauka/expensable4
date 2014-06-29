class AddCreatorToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :creator, index: true
  end
end
