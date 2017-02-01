class Task < ActiveRecord::Base
  attr_accessible :deadline, :description, :open, :priority, :reminder, :title, :user_id, :email_reminder
  belongs_to :user

  before_save { |task| task.title = task.title.capitalize }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: {case_sensitive: false }
  validates :description, length: { maximum: 150 }
  validates :open, inclusion: { in: [true, false] }
  validates_datetime :reminder, after: lambda { DateTime.current }, if: lambda { |task| task.reminder.present? }
  validates_datetime :deadline, after: lambda { DateTime.current }, if: lambda { |task| task.deadline.present? }


  after_save :send_reminder_email, on: [:create, :update], if: lambda { |task| task.reminder.present? && task.open && task.email_reminder }
  after_save :display_reminder_notification, on: [:create, :update], if: lambda { |task| task.reminder.present? && task.open && task.email_reminder }

  def send_reminder_email
  	delay_interval = reminder - DateTime.now
  	SendMail.perform_at(delay_interval.from_now, self.attributes, 'reminder_email') if delay_interval > 0
  end

  def display_reminder_notification
    delay_interval = reminder - DateTime.now
    DisplayNotif.perform_at(delay_interval.from_now, self.attributes, 'reminder_notification') if delay_interval > 0
  end

  def self.as_csv
    columns = %w{title description deadline open}
    CSV.generate(headers: true) do |csv|
      csv << columns.collect { |column| column.capitalize }
      all.each do |task|
        csv << task.attributes.values_at(*columns)
      end
    end
  end

end
