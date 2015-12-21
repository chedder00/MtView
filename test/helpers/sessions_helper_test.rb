require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:reg_user)
    login(@user)
  end

  test "current user set properly after login" do
    assert_equal @user, current_user
    assert is_logged_in?  
  end

end