require 'test_helper'

class TaskCreateTest < ActionDispatch::IntegrationTest
  
  # def setup
  #   login_as(users(:reg_user))
  #   @task = tasks(:one)
  #   @plant = plants(:mother)
  # end

  # test "user should be able to create a task" do
  #   assert_difference 'Task.count', 1 do
  #     post plant_tasks_path(@plant), task: { name: "Some new task",
  #                                               description: "Some task stuff",
  #                                               user_id: users(:reg_user).id }
  #   end
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_template 'plants/show'
  # end

  # test "user should be able to modify a task" do
  #   old_name = @task.name
  #   old_id = @task.user_id
  #   patch task_path(@task), task: { name: "My fffirst task",
  #                                   user_id: users(:admin_user).id }
  #   @task.reload
  #   assert_not_equal old_name, @task.name
  #   assert_not_equal old_id, @task.user_id
  # end

end
