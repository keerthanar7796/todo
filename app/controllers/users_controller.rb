class UsersController < ApplicationController
require 'will_paginate/array'
require 'date'
  before_filter :signed_in_user, only: :show
  before_filter :correct_user, only: :show

	def show
		@user = User.find(params[:id])
    # binding.pry
    @open_tasks = @user.tasks.select{ |task| task.open? }
    @open_tasks = @open_tasks.paginate(page: params[:page], per_page: 7)
    @done_tasks = @user.tasks.select{ |task| !task.open? }
    @done_tasks = @done_tasks.paginate(page: params[:page], per_page: 7)
	end

  def new
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

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url, notice: "Sign out to sign in as another user." unless current_user?(@user)
    end
end
