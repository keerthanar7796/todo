class UserMailer < ActionMailer::Base
	default from: 'Todo App <todowebapplication@gmail.com>'
	layout 'mailer'

	def welcome_email(user_id)
		@user = User.find_by_id(user_id)
		mail to: @user.email, subject: "Welcome to Todo App!"
	end

	def reminder_email(task)
		@task = Task.find_by_id(task["id"])
		if task["updated_at"].to_datetime.to_i != @task.updated_at.to_i
  			return
  		end
		@user = User.find_by_id(@task.user_id)
		mail to: @user.email, subject: "Reminder: Complete '#{@task.title}' by #{@task.deadline.strftime('%I:%M %p on %b %d %Y')}"
	end

	def tasks_csv_email(user_id)
		@user = User.find_by_id(user_id)
		@tasks = Task.where(user_id: @user.id)
		@csv_data = @tasks.as_csv
		attachments["#{@user.name}-tasks.csv"] = @csv_data
		mail to: @user.email, subject: "Download your list of tasks now!"
	end

	def tasks_xml_email(user_id)
		@user = User.find_by_id(user_id)
		@tasks = Task.where(user_id: @user.id)
		@xml_data = @tasks.to_xml
		attachments["#{@user.name}-tasks.xml"] = @xml_data
		mail to: @user.email, subject: "Download your list of tasks now!"
	end
end