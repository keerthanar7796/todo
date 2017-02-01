class RemoveGroupByFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :group_by
  end

  def down
  	add_column :users, :group_by, :string
  end
end
