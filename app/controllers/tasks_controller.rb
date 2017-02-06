class TasksController < ApplicationController
  require 'will_paginate/array'
  require 'date'

  skip_before_filter :correct_user, except: [:destroy, :edit, :update, :markdone, :markopen]

  def new
    @task = current_user.tasks.build if signed_in?
  end

  def create
  	@task = current_user.tasks.build(params[:task])
  	if @task.save
  		flash[:success] = "Task added!"
  		redirect_to tasks_path
  	else
      render 'new'
  	end
  end

  def destroy
    @task.destroy
    flash[:success] = "Task deleted."
    redirect_to tasks_path
  end

  def edit
  end

  def update
    if @task.update_attributes(params[:task])
      flash[:success] = "Task updated!"
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def markdone
    @task.update_attribute(:open, false)
    flash[:success] = "Task marked as done!"
    redirect_to tasks_path
  end

  def markopen
    @task.update_attribute(:open, true)
    flash[:success] = "Task marked as open!"
    redirect_to tasks_path
  end

  def index
    load_user
    load_tasks
    load_reminders
    set_sort_order
    load_open_tasks
    load_done_tasks
    respond_to do |format|
      format.html
      format.xml { send_data @tasks.to_xml }
      format.csv { send_data @tasks.as_csv, disposition: 'attachment', type: 'text/csv' }
    end
  end

  def more_options
  end

  def mail_csv
    load_user
    SendMail.perform_async(@user.id, "tasks_csv_email")
    flash[:success] = "Your mail is on the way!"
    redirect_to :back
  end

  def mail_xml
    load_user
    SendMail.perform_async(@user.id, "tasks_xml_email")
    flash[:success] = "Your mail is on the way!"
    redirect_to :back
  end

  private
  def correct_user
    @task = current_user.tasks.find_by_id(params[:id])
    redirect_to tasks_path if @task.nil?
  end

  def load_reminders
    reminder_task_ids = $redis.smembers "messages:#{@user.id}"
    reminder_tasks = Task.find_all_by_id(reminder_task_ids)
    reminder_tasks.each do |task|
      flash[:info] ||= []
      flash[:info] << "Reminder: Complete task \"#{task.title}\" before #{task.deadline.strftime('%I:%M %p on %b %d %Y')}!"
      $redis.srem("messages:#{@user.id}", task.id)
    end
  end

  def load_user
    @user = current_user
  end

  def load_tasks
    @tasks = current_user.tasks
  end

  def set_sort_order
    @sort_order = "#{params[:sort_by]}"
    @sort_order += " ASC, " if params[:sort_by] != nil
  end

  def load_open_tasks
    @open_tasks = @user.tasks.order("#{@sort_order}updated_at DESC").where(open: true)
    @open_tasks = @open_tasks.paginate(page: params[:page], per_page: 7)
  end

  def load_done_tasks
    @done_tasks = @user.tasks.order("#{@sort_order}updated_at DESC").where(open: false)
    @done_tasks = @done_tasks.paginate(page: params[:page], per_page: 7)
  end
end
