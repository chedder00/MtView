require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:reg_user)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #invalid email
    post password_resets_path, password_reset: { email: "invalid" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #password rest form
    user = assigns(:user)
    #wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    #right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    #right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    #invalid password & confirm
    patch password_reset_path(user.reset_token), 
          email: user.email,
          user: { password: "MyPass1", password_confirmation: "MyPass" }
    assert_select 'div#error_explanation'
    #valid password & confirm
    patch password_reset_path(user.reset_token), 
          email: user.email,
          user: { password: "MyPass1", password_confirmation: "MyPass1" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    #expired token
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token), 
          email: user.email,
          user: { password: "MyPass1", password_confirmation: "MyPass1" }
    assert_response :redirect
    follow_redirect!
    assert_template 'password_resets/new'
  end  
    
end
