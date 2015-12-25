require 'test_helper'

class InventoryItemTest < ActiveSupport::TestCase
  
  def setup
    @item = InventoryItem.new( name: "Some Product",
                               quantity: 10,
                               avaliable_to_reseller: true,
                               price_cents: 1000,
                               suggested_retail_price_cents: 1200)
  end

  test "should be valid" do
    assert @item.valid?    
  end

  test "should not allow blank name" do
    @item.name = ""
    assert_not @item.valid?
  end

  test "name should not be longer than 100 characters" do
    @item.name = "a" * 101
    assert_not @item.valid?
  end

  test "price should not be greater than 999999.99" do 
    @item.price_cents = 100000000
    assert_not @item.valid?
  end

  test "price should not be negative" do 
    @item.price_cents = -12345
    assert_not @item.valid?
  end

  test "price should be a number" do
    @item.price_cents = "abc"
    assert_not @item.valid?
  end

  test "quantity should not be negative" do 
    @item.quantity = -1
    assert_not @item.valid?
  end

end
