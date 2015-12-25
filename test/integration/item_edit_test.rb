require 'test_helper'

class ItemEditTest < ActionDispatch::IntegrationTest
  def setup
    @item = inventory_items(:rso)
  end

  test "should not allow staff to update item" do
    login_as(users(:reg_user))
    old_name =@item.name
    old_qty = @item.quantity
    patch inventory_item_path @item, inventory_item: { name: "New Name",
                                                       increase_qty: 5 }
    @item.reload
    assert_equal old_name, @item.name
    assert_equal old_qty, @item.quantity
  end

  test "should allow inventory controller to increase quantity but not price" do
    login_as(users(:inventory_user))
    @item = inventory_items(:rso)
    old_qty = @item.quantity
    old_price = @item.price_cents
    patch inventory_item_path @item, inventory_item: { increase_qty: 5,
                                                       new_price: 25.30 }
    @item.reload
    assert_not_equal old_qty, @item.quantity
    assert_equal @item.quantity, (old_qty + 5)
    assert_equal old_price, @item.price_cents
  end

  test "should allow admin to change name and quantity" do 
    login_as(users(:admin_user))
    @item = inventory_items(:rso)
    old_name = @item.name
    old_qty = @item.quantity
    old_price = @item.price_cents
    patch inventory_item_path @item, inventory_item: { name: "New Name",
                                                       increase_qty: 5,
                                                       new_price: 25.30 }
    @item.reload
    assert_not_equal old_name, @item.name
    assert_not_equal old_qty, @item.quantity
    assert_equal @item.quantity, (old_qty + 5)
    assert_equal old_price, @item.price_cents
  end

  test "should allow controller to increase quantity and price" do
    login_as(users(:controller_user))
    @item = inventory_items(:rso)
    old_qty = @item.quantity
    old_price = @item.price_cents
    patch inventory_item_path @item, inventory_item: { increase_qty: 5,
                                                       new_price: 25.30 }
    @item.reload
    assert_not_equal old_qty, @item.quantity
    assert_equal @item.quantity, (old_qty + 5)
    assert_not_equal old_price, @item.price_cents
    assert_equal @item.price_cents, 2530
  end

end
