class TasksController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :markdone, :markopen, :edit, :update]
  before_filter :correct_user, only: [:destroy, :markdone, :markopen, :edit, :update]

  def new
    @task = current_user.tasks.build if signed_in?
  end

  def create
  	@task = current_user.tasks.build(params[:task])
  	if @task.save
  		flash[:success] = "Task added!"
  		redirect_to user_path(current_user)
  	else
      render 'new'
  	end
  end

  def destroy
    @task.destroy
    flash[:success] = "Task deleted."
    redirect_to user_path(current_user)
  end

  def edit
  end

  def update
    binding.pry
    if @task.update_attributes(params[:task])
      flash[:success] = "Task updated!"
      redirect_to user_path(current_user)
    else
      Rails.logger.info(@task.errors.messages.inspect)
      render 'edit'
    end
  end

  def markdone
    @task.update_attribute(:open, false)
    flash[:success] = "Task marked as done!"
    redirect_to user_path(current_user)
  end

  def markopen
    @task.update_attribute(:open, true)
    flash[:success] = "Task marked as open!"
    redirect_to user_path(current_user)
  end

  private
  def correct_user
    @task = current_user.tasks.find_by_id(params[:id])
    redirect_to user_path(current_user) if @task.nil?
  end
end
