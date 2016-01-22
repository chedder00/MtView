require 'test_helper'

class PlantsControllerTest < ActionController::TestCase

  def setup
    @plant = plants(:mother)
  end

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
    assert_template 'shared/form'
  end

  test "should allow non admin to view all plants" do
    login_as(users(:reg_user))
    get :index
    assert_response :success
  end

  test "should allow non admin to view specific plant page" do
    login_as(users(:reg_user))
    get :show, id: @plant
    assert_response :success
  end

  test "should redirect non staff from index" do
    login_as(users(:reseller_user))
    get :index
    assert_response :redirect
  end

  test "should not show plant page to non staff" do
    login_as(users(:reseller_user))
    get :show, id: @plant
    assert_response :redirect
  end
  
end
