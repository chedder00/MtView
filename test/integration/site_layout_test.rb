require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
  end

  test "non logged in layout links" do  
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "logged in layout links" do
    login_as(@user)
    follow_redirect!
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", new_user_path, count: 0
    assert_select "a[href=?]", roles_path, count: 0
    assert_select "a[href=?]", new_role_path, count: 0

    #assert_select "a[href=?]", new_role_path
    #assert_select "a[href=?]", plant_state_path
    #assert_select "a[href=?]", plant_path
    #assert_select "a[href=?]", task_path
    #assert_select "a[href=?]", note_path
    #assert_select "a[href=?]", inventory_path
  end

  test "admin layout links" do
    login_as(users(:admin_user))
    follow_redirect!
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", new_user_path
    assert_select "a[href=?]", roles_path
    assert_select "a[href=?]", new_role_path
  end

end