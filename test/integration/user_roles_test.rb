require 'test_helper'

class UserRolesTest < ActionDispatch::IntegrationTest
  
  def setup
    @role = roles(:regular)
  end

  test "should be valid" do 
    assert @role.valid?  
  end

  test "should not allow duplicates" do 
    @role_dup = @role.dup
    @role.save
    assert_not @role_dup.valid?
  end

  test "should not allow blank name" do 
    @role.name = " " * 10
    assert_not @role.valid?
  end

  test "name should not be longer than 50 characters" do 
    @role.name = "a" * 51
    assert_not @role.valid?
  end

  test "level should not be blank" do
    @role.level = ""
    assert_not @role.valid?
  end
  
end
