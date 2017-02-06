class BasicPagesController < ApplicationController
	skip_before_filter :signed_in_user
	skip_before_filter :correct_user
	
  def home
  end

  def help
  end

  def about
  end
end
