require 'test_helper'

class InventoryItemsDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @inventory_item = inventory_items(:rso)
  end

  test "should not allow staff to delete item" do
    login_as(users(:reg_user))
    assert_no_difference 'InventoryItem.count' do
      delete inventory_item_path @inventory_item
    end
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test "should not allow inventory controller to delete item" do
    login_as(users(:inventory_user))
    assert_no_difference 'InventoryItem.count' do
      delete inventory_item_path @inventory_item
    end
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test "should allow admin to delete item" do
    login_as(users(:admin_user))
    assert_difference 'InventoryItem.count', -1 do
      delete inventory_item_path @inventory_item
    end
    assert_response :redirect
    assert_redirected_to inventory_items_path
    assert_not flash.empty?
  end
  
end
