class DisplayNotif
  include Sidekiq::Worker

  sidekiq_options queue: :display_notif, retry: 2, backtrace: true, failures: :exhaust

  def perform task, type
  	@task = task
  	user = User.find_by_id(task["user_id"])
    message = "Reminder: Complete task \"#{@task["title"]}\" before #{DateTime.parse(@task["deadline"].to_s).strftime('%I:%M %p on %b %d %Y')}!"
    $redis.set("messages:#{user.id}", message)
  end
end
