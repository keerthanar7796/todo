class Task < ActiveRecord::Base
  attr_accessible :deadline, :description, :open, :priority, :reminder, :title, :user_id, :email_reminder
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence:true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }
  validates :open, inclusion: { in: [true, false] }
  validates_datetime :reminder, after: lambda { DateTime.current }, if: lambda { |task| task.reminder.present? }
  validates_datetime :deadline, after: lambda { DateTime.current }, if: lambda { |task| task.deadline.present? }

  # default_scope order: 'updated_at DESC'

  after_save :send_reminder_email, on: [:create, :update], if: lambda { |task| task.reminder.present? } && :open && :email_reminder
  after_save :display_reminder_notification, on: [:create, :update], if: lambda { |task| task.reminder.present? } && :open

  def send_reminder_email
  	delay_interval = reminder - DateTime.now
  	SendMail.perform_at(delay_interval.from_now, self.attributes, 'reminder_email') if delay_interval > 0
  end

  def display_reminder_notification
    delay_interval = reminder - DateTime.now
    DisplayNotif.perform_at(delay_interval.from_now, self.attributes, 'reminder_notification') if delay_interval > 0
  end

  def self.as_csv
    atrbts = %w{title description deadline}
    CSV.generate(headers: true) do |csv|
      csv << atrbts
      all.each do |task|
        csv << task.attributes.values_at(*atrbts)
      end
    end
  end

end
