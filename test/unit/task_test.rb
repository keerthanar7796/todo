require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@task = Task.new(title: "task", open: "true", user_id: "1")
  end

  test "title should not be empty" do
  	@task.title = " "
  	assert !@task.save
  end

  test "title should not be too long" do
  	@task.title = "task" * 20
  	assert !@task.valid?
  end

  test "task should have user_id" do
  	@task.user_id = " "
  	assert !@task.save
  end

  test "description should not be too long" do
  	@task.description = "Description" * 100
  	assert !@task.valid?
  end

  test "task should either be open or done" do
  	@task.open = ""
  	assert !@task.save
  end

  test "reminder should be after current time" do
  	@task.reminder = DateTime.current - 1
  	assert !@task.valid?
  end

  test "deadline should be after current time" do
  	@task.deadline = DateTime.current - 1
  	assert !@task.valid?
  end
end
