require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do  
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    #assert_select "a[href=?]", plant_path
    #assert_select "a[href=?]", task_path
    #assert_select "a[href=?]", note_path
    #assert_select "a[href=?]", inventory_path
  end
end