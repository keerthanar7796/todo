class ChangeOpenDefaultInTasks < ActiveRecord::Migration
  def up
  	change_column :tasks, :open, :boolean, default: true
  end

  def down
  	change_column :tasks, :open, :boolean
  end
end
