class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.boolean :open
      t.integer :priority
      t.datetime :deadline
      t.datetime :reminder
      t.integer :user_id

      t.timestamps
    end
    add_index :tasks, [:user_id, :created_at]
    change_column :tasks, :open, :boolean, default: true
  end
end
