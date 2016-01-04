require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:reg_user)
  end

  test "non logged in layout links" do  
    get root_path
    assert_response :redirect
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_template 'sessions/new'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "staff layout links" do
    login_as(@user)
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", new_user_path, count: 0
    assert_select "a[href=?]", roles_path, count: 0
    #assert_select "a[href=?]", new_role_path, count: 0
    assert_select "a[href=?]", plants_path
    assert_select "a[href=?]", new_plant_path, count: 0
    assert_select "a[href=?]", new_plant_state_path, count: 0
    assert_select "a[href=?]", plant_states_path, count: 0
    assert_select "a[href=?]", inventory_items_path
    assert_select "a[href=?]", new_inventory_item_path, count: 0


    #assert_select "a[href=?]", task_path
    #assert_select "a[href=?]", note_path
  end

  test "admin layout links" do
    login_as(users(:admin_user))
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", new_user_path
    assert_select "a[href=?]", roles_path
    #assert_select "a[href=?]", new_role_path
    assert_select "a[href=?]", plants_path
    assert_select "a[href=?]", new_plant_path
    assert_select "a[href=?]", new_plant_state_path
    assert_select "a[href=?]", plant_states_path
    assert_select "a[href=?]", inventory_items_path
    assert_select "a[href=?]", new_inventory_item_path
  end

  test "plant show page links" do
    login_as(users(:reg_user))
    @plant = plants(:mother)
    get plant_path @plant
    assert_select "a[href=?]", edit_plant_path(@plant)
    assert_select "a[href=?]", plant_clone_path(@plant)
    assert_select "a[href=?]", new_plant_task_path(@plant)
  end

end