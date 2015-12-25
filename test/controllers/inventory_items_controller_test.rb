require 'test_helper'

class InventoryItemsControllerTest < ActionController::TestCase
    def setup
    @user = users(:reg_user)
    @admin = users(:admin_user)
    @inv = users(:inventory_user)
    @item = inventory_items(:rso)
  end

  test "should redirect new for non logged in users" do
    get :new
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect edit for non logged in users" do
    get :edit, id: @item
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect index for non logged in users" do
    get :index
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect new for non admin users" do
    login_as(@user)
    get :new
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect edit for non admin users" do
    login_as(@user)
    get :edit, id: @item
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should allow new for admin users" do
    login_as(@admin)
    get :new
    assert_response :success
  end

  test "should allow edit for inventory controller and higher users" do
    login_as(@inv)
    get :edit, id: @item
    assert_response :success
    assert flash.empty?
  end

  test "should show index for logged in users" do
    login_as(users(:reseller_user))
    get :index
    assert_response :success
  end

  test "should show item page for logged in users" do
    login_as(users(:reseller_user))
    get :show, id: @item
    assert_response :success
  end

end
