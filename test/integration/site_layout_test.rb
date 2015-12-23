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
    assert_select "a[href=?]", roles_path
    assert_select "a[href=?]", new_role_path
    #assert_select "a[href=?]", plant_state_path
    #assert_select "a[href=?]", plant_path
    #assert_select "a[href=?]", task_path
    #assert_select "a[href=?]", note_path
    #assert_select "a[href=?]", inventory_path
  end

end