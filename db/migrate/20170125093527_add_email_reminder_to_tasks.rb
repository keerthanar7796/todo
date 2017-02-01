class AddEmailReminderToTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :email_reminder, :boolean
  end
end
