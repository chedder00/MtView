require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
  end

  test "login with invalid information should fail" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information then logout" do
    login_as(@user)
    assert_redirected_to root_path
    follow_redirect!
    assert flash.empty?
    assert is_logged_in?
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0

    #test to see if application still works if logout is pressed from second
    #browser window
    delete logout_path #simulate logging out from second browser window
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0    
  end
  
end