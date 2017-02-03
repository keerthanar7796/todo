class DisplayNotif
  include Sidekiq::Worker

  sidekiq_options queue: :display_notif, retry: 2, backtrace: true, failures: :exhaust

  def perform task_id, updated_at
  	@task = Task.find_by_id(task_id)
  	if updated_at.to_datetime.to_i != @task.updated_at.to_i
  		return
  	end
  	@user = User.find_by_id(@task.user_id)
    message = "#{task_id}"
    $redis.sadd("messages:#{@user.id}", message)
  end
end
