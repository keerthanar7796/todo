require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: "Sample", email: "sample@example.com", password: "password", password_confirmation: "password")
  end

  test "should not be empty" do
  	@user = User.new
  	assert !@user.save
  end

  test "name should not be empty" do
  	@user.name = " "
  	assert !@user.valid?
  end

  test "name should not be too long" do
  	@user.name = "Sample" * 10
  	assert !@user.valid?
  end

  test "email should not be empty" do
   	@user.email = " "
   	assert !@user.valid?
  end

  test "email should be valid" do
   	emails = %w[ hsirah@example.com dasda@asdas.edu a123@23a.cc freshdesk@freshdesk.com FRSHDSK@EE.IN a.b.c.d@e.f.g ]
   	emails.each do |e|
    	@user.email = e
     	assert @user.valid?,"#{@user.errors.full_messages} #{e}"
   	end
  end

  test "email should not be valid" do
   	emails = %w[ 123 abcdefg this_is_not_valid.com iamkidding@you 2+2=5 ]
  	emails.each do |e|
      @user.email = e
      assert !@user.valid?, "#{@user.errors.full_messages} #{e}"
    end
	end

	test "user should not already be present" do
		@user.save
		duplicate = @user.dup
		assert !duplicate.save
	end

	test "password should be present" do
		@user.password = @user.password_confirmation = " "
		assert !@user.valid?
	end

	test "password doesn't match password confirmation" do
		@user.password_confirmation = "notpassword"
		assert !@user.valid?
	end

	test "password confirmation is nil" do
		@user.password_confirmation = nil
		assert !@user.valid?
	end

	test "password should have minimum length" do
		@user.password = "pass"
		assert !@user.save
	end
end
