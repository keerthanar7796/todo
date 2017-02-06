class Task < ActiveRecord::Base
  include ActiveModel::Dirty

  attr_accessible :deadline, :description, :open, :priority, :reminder, :title, :user_id, :email_reminder
  attr_accessible :sort_by
  belongs_to :user

  before_save { |task| task.title = task.title.slice(0,1).capitalize + task.title.slice(1..-1) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :description, length: { maximum: 150 }
  validates :open, inclusion: { in: [true, false] }
  [:reminder, :deadline].each do |col|
    validates_datetime col, after: lambda { DateTime.current }, if: lambda { |task| task[col].present? }
  end
  validates_datetime :reminder, before: lambda { :deadline }, if: lambda { |task| task.deadline.present? && task.reminder.present? }


  after_save :send_reminder_email, on: [:create, :update], if: lambda { |task| task.reminder_changed? && task.email_reminder && task.open && task.reminder.present? }
  after_save :display_reminder_notification, on: [:create, :update], if: lambda { |task| task.reminder_changed? && task.open && task.reminder.present? }


  def reminder=(val)
    reminder_will_change! unless (val == nil && DateTime.parse(val).to_i == reminder.to_i)
    self[:reminder] = val
  end

  def send_reminder_email
    	SendMail.perform_at(reminder, { id: self.id, reminder: self.reminder }, 'reminder_email')
  end

  def display_reminder_notification
    DisplayNotif.perform_at(reminder, self.id, self.reminder)
  end

  def self.as_csv
    columns = %w{title description deadline open}
    CSV.generate(headers: true) do |csv|
      csv << columns.collect(&:capitalize)
      all.each do |task|
        csv << [task.title, task.description, (task.deadline.strftime('%I:%M %p on %b %d %Y') if task.deadline.present?), task.open]
      end
    end
  end

end
