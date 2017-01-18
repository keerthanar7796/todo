class TasksController < ApplicationController
  def create
  	@task = current_user.tasks.build(params[:task])
  	if @task.save
  		flash[:success] = "Task added!"
  		redirect_to root_url
  	else
  		render 'basic_pages/home'
  	end
  end

  def destroy
  end
end
