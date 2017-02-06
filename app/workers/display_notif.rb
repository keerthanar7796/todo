class DisplayNotif
  include Sidekiq::Worker

  sidekiq_options queue: :display_notif, retry: 2, backtrace: true, failures: :exhaust

  def perform task_id, reminder
  	@task = Task.find_by_id(task_id)
  	if reminder.to_datetime.to_i != @task.reminder.to_i && !@task.open
  		return
  	end
  	@user = User.find_by_id(@task.user_id)
    message = "#{task_id}"
    $redis.sadd("messages:#{@user.id}", message)
  end
end
