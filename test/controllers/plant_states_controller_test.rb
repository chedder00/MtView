require 'test_helper'

class PlantStatesControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:reg_user)
    @admin = users(:admin_user)
  end

  test "should redirect non logged in users" do
    get :new
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect non admin users" do
    login_as(@user)
    get :new
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should allow admin users" do
    login_as(@admin)
    get :new
    assert_response :success
  end
  
end
