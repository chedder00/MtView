require 'test_helper'

class ItemCreateTest < ActionDispatch::IntegrationTest
  
  def setup
    @item = InventoryItem.new( name: "Some product",
                               quantity: 5,
                               avaliable_to_reseller: true,
                               price_cents: 1000,
                               suggested_retail_price_cents: 1200 )
  end

  test "should not allow staff to create inventory items" do
    login_as(users(:reg_user))
    assert_no_difference "InventoryItem.count" do
      post inventory_items_path, inventory_item: { name: "A Product",
                                                   increase_qty: 3 }
    end
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test "should allow admin to create inventory item" do
    login_as(users(:admin_user))
    get new_inventory_item_path
    assert_difference 'InventoryItem.count', 1 do
      post inventory_items_path, inventory_item: { name: "A Product",
                                                   increase_qty: 3 }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'inventory_items/_form'
    assert_not flash.empty?
  end

  test "should not allow admin to set price but should increase quantity" do
    login_as(users(:admin_user))
    get new_inventory_item_path
    assert_difference 'InventoryItem.count', 1 do
      post inventory_items_path, inventory_item: { name: "A Product",
                                                   increase_qty: 3,
                                                   new_price: 10.00 }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'inventory_items/_form'
    @item = InventoryItem.last
    assert_equal @item.price_cents, 0
    assert_equal @item.quantity, 3
    assert_not flash.empty?
  end

  test "should allow controller to set price" do
    login_as(users(:controller_user))
    get new_inventory_item_path
    assert_difference 'InventoryItem.count', 1 do
      post inventory_items_path, inventory_item: { name: "A Product",
                                                   avaliable_to_reseller: true,
                                                   increase_qty: 3,
                                                   new_price: 10.00 }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'inventory_items/_form'
    @item = InventoryItem.last
    assert_equal @item.price_cents, 1000
    assert_equal @item.suggested_retail_price_cents, 
                (@item.price_cents + (@item.price_cents * 0.12))
    assert_equal @item.quantity, 3
    assert_not flash.empty?
  end

end
