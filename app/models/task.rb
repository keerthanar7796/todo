class Task < ActiveRecord::Base
  attr_accessible :deadline, :description, :open, :priority, :reminder, :title, :user_id, :email_reminder
  belongs_to :user

  before_save { |task| task.title = task.title.capitalize }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :description, length: { maximum: 150 }
  validates :open, inclusion: { in: [true, false] }
  [:reminder, :deadline].each do |col|
    validates_datetime col, after: lambda { DateTime.current }, if: lambda { |task| task[col].present? }
  end
  validates_datetime :reminder, before: lambda { :deadline }, if: lambda { |task| task.deadline.present? && task.reminder.present? }

  after_save :send_reminder_email, on: [:create, :update], if: lambda { |task| task.email_reminder && task.open && task.reminder.present? }
  after_save :display_reminder_notification, on: [:create, :update], if: lambda { |task| task.open && task.reminder.present? }

  def send_reminder_email
    	SendMail.perform_at(reminder, { id: self.id, updated_at: self.updated_at }, 'reminder_email') if reminder.to_i > DateTime.now.to_i
  end

  def display_reminder_notification
    DisplayNotif.perform_at(reminder, self.id, self.updated_at) if reminder.to_i > DateTime.now.to_i
  end

  def self.as_csv
    columns = %w{title description deadline open}
    CSV.generate(headers: true) do |csv|
      csv << columns.collect(&:capitalize)
      all.each do |task|
        csv << task.attributes.values_at(*columns)
      end
    end
  end

end
