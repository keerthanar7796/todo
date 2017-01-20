class ChangePriorityDefaultInTasks < ActiveRecord::Migration
  def up
  	change_column :tasks, :priority, :integer, default: "4"
  end

  def down
  	change_column :tasks, :priority, :integer
  end
end
