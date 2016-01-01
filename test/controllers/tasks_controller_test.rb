require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  
  def setup
    @task = tasks(:one)
    @plant = plants(:mother)
  end

  test "non staff should be redirected" do
    login_as(users(:reseller_user))
    get :new, plant_id: @plant.id
    assert_response :redirect
  end

  test "staff should be allowed to create tasks" do
    login_as(users(:reg_user))
    get :new, plant_id: @plant.id
    assert_response :success
  end
end
