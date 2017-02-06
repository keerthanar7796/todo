class UsersController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new, :create]
  skip_before_filter :correct_user, only: [:new, :create]

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
  		redirect_to tasks_path
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
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    sign_out
    flash[:success] = "You have successfully deleted your account."
    redirect_to root_url
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url, flash: { warning: "Sign out to sign in as another user."} unless current_user?(@user)
    end
end
