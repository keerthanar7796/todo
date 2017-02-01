class SendMail
  include Sidekiq::Worker

  sidekiq_options queue: :send_mail, retry: 2, backtrace: true, failures: :exhaust

  def perform args, type
    UserMailer.send("#{type}",args).deliver
  end
end