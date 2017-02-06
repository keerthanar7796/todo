class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :signed_in_user
  before_filter :correct_user

  def handle_unverified_request
  	sign_out
  	super
  end
end
