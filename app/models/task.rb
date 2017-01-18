class Task < ActiveRecord::Base
  attr_accessible :deadline, :description, :open, :priority, :reminder, :title, :user_id
  belongs_to :user, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence:true, length: { maximum: 50 }
  validates :description, length: { maximum: 150 }
  validates :open, presence: true
  validates_datetime :reminder, after: lambda { DateTime.current }
  validates_datetime :deadline, after: lambda { DateTime.current }

  default_scope order: 'deadline ASC'

end
