class RemoveSortByFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :sort_by
  end

  def down
  	add_column :users, :sort_by, :string
  end
end
