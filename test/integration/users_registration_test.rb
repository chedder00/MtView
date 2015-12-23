require 'test_helper'

class UsersRegistrationTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
    ActionMailer::Base.deliveries.clear
  end

  test "invalid registration should fail" do
    login_as(users(:admin_user))
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: @user.name,
                              email: @user.email,
                              role_id: @user.role_id,
                              password: "foo",
                              password_confirmation: "bar"}
    end
    assert_template 'users/_form'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "should create user if logged in as admin user" do
    login_as(users(:admin_user))
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: @user.name,
                                            email: "my@email.com",
                                            role_id: @user.role_id,
                                            password: "Password1",
                                            password_confirmation: "Password1" }
    end
    assert_response :success
    assert_not flash.empty?
    assert_template 'static_pages/home'    
  end
  
end
