require 'test_helper'

class PlantsControllerTest < ActionController::TestCase

  test "should redirect if not logged in" do    
    get :new
    assert_redirected_to login_url
  end

  test "should reidrect non admin users" do
    login_as(users(:reg_user))
    get :new
    assert_redirected_to login_url
  end

  test "should allow admin users" do
    login_as(users(:admin_user))
    get :new
    assert_response :success
  end
  
end
