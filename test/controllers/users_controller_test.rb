require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:reg_user)
  end

  test "should get new if admin user" do
    login_as(users(:admin_user))
    get :new
    assert_response :success
    assert_template 'users/_form'
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: "Test User",
                                      email: "test@user.com",
                                      role_id: 1,
                                      password: "Password1",
                                      password_confirmation: "Password1" }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect index when not administrator" do
    login_as(@user)
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should show index page for administrator" do
    login_as(users(:admin_user))
    get :index
    assert_response :success
    assert flash.empty?
    assert_template 'users/index'
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    login_as(@user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

end
