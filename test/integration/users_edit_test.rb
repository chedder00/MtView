require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
  end

  test "unsuccessful edit should fail" do
    login_as(@user)
    get edit_user_path(@user)
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_template 'sessions/new'
    
    patch user_path(@user), user: { 
                                    name: "",
                                    email: "my@email.com",
                                    role_id: 2,
                                    password: "pass",
                                    password_confirmation: "word" 
                                  }
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_template 'sessions/new'
  end

  test "admin users should be able to edit any record" do
    @admin = users(:admin_user)
    login_as(@admin)
    get edit_user_path(@user)
    assert_template 'users/_form'
    name = "My new name"
    email = "new@email.com"
    patch user_path(@user), user: { 
                                    name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: ""
                                  }
    assert_not flash.empty?
    assert_redirected_to root_path
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    follow_redirect!
    assert_template 'static_pages/home'
  end

end
