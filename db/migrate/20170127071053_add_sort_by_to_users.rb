class AddSortByToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :sort_by, :string
  end
end
