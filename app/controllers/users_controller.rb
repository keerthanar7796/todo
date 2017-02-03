class UsersController < ApplicationController
require 'will_paginate/array'
require 'date'
  before_filter :signed_in_user, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]

	def show
		@user = User.find(params[:id])
    reminder_tasks = $redis.smembers "messages:#{@user.id}"
    reminder_tasks.each do |task_id|
      task = Task.find_by_id(task_id)
      flash[:info] ||= []
      flash[:info] << "Reminder: Complete task \"#{task.title}\" before #{task.deadline.strftime('%I:%M %p on %b %d %Y')}!"
      $redis.srem("messages:#{@user.id}", task_id)
    end
    sort_order = "#{@user.sort_by}"
    sort_order += " ASC, " if @user.sort_by != nil
    @open_tasks = @user.tasks.order("#{sort_order}updated_at DESC").select{ |task| task.open? }
    @open_tasks = @open_tasks.paginate(page: params[:page], per_page: 7)
    @done_tasks = @user.tasks.order("#{sort_order}updated_at DESC").select{ |task| !task.open? }
    @done_tasks = @done_tasks.paginate(page: params[:page], per_page: 7)
	end

  def new
    if signed_in?
      redirect_to root_url, flash: { warning: "Sign out before you sign up as new user!" }
    end
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to Todo App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def sort
    @user = current_user
    @user.update_attribute(:sort_by, params[:sort_by])
    sign_in @user
    show
    render 'show'
  end

  def destroy
    @user.destroy
    sign_out
    flash[:success] = "You have successfully deleted your account."
    redirect_to root_url
  end

  def more_options
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url, flash: { warning: "Sign out to sign in as another user."} unless current_user?(@user)
    end
end
