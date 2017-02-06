class SessionsController < ApplicationController
	skip_before_filter :signed_in_user
	skip_before_filter :correct_user
	
	def new
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_to tasks_path
		else
			flash.now[:danger] = 'Invalid username/password'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
