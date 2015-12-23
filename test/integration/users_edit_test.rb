require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
  end

  test "non admin users should not be able to change most attributes" do
    login_as(@user)
    @user_save = @user
    get edit_user_path(@user)    
    patch user_path(@user), user: { name: "Changed Name",
                                    address: "Changed Address" }
    assert_redirected_to root_url
    @user.reload
    assert_equal @user_save.name, @user.name
    assert_equal @user_save.address, @user.address
    assert_not flash.empty?
  end

  test "non admin users should be able to change password" do
    login_as(@user)
    old_digest = @user.password_digest
    get edit_user_path(@user)
    patch user_path(@user), user: { password: "MyPass1", 
                                    password_confirmation: "MyPass1" }
    @user.reload
    assert_not_equal old_digest, @user.password_digest
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
