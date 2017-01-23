class Task < ActiveRecord::Base
  attr_accessible :deadline, :description, :open, :priority, :reminder, :title, :user_id
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence:true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }
  validates :open, inclusion: { in: [true, false] }
  validates_datetime :reminder, after: lambda { DateTime.current }, if: lambda { |task| task.reminder.present? }
  validates_datetime :deadline, after: lambda { DateTime.current }, if: lambda { |task| task.reminder.present? }

  default_scope order: 'priority ASC, deadline ASC'

end
