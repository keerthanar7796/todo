class ChangeDeadlineTypeInTasks < ActiveRecord::Migration
  def up
  	change_column :tasks, :deadline, :string
  	change_column :tasks, :reminder, :string
  end

  def down
  	change_column :tasks, :deadline, :datetime
  	change_column :tasks, :reminder, :datetime
  end
end
