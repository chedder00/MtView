require 'test_helper'

class UsersDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
  end

  test "should delete user if logged in as admin" do
    login_as(users(:admin_user))
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash.empty?
    assert_template 'static_pages/home'
  end
end
