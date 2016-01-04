require 'test_helper'

class UserRolesTest < ActionDispatch::IntegrationTest
  
  # def setup
  #   @role = roles(:regular)
  #   login_as(users(:admin_user))
  # end

  # test "should be valid" do 
  #   assert @role.valid?  
  # end

  # test "should not allow duplicates" do 
  #   @role_dup = @role.dup
  #   @role.save
  #   assert_not @role_dup.valid?
  # end

  # test "should not allow blank name" do 
  #   @role.name = " " * 10
  #   assert_not @role.valid?
  # end

  # test "name should not be longer than 50 characters" do 
  #   @role.name = "a" * 51
  #   assert_not @role.valid?
  # end

  # test "level should not be blank" do
  #   @role.level = ""
  #   assert_not @role.valid?
  # end

  # test "should allow admin to create" do
  #   assert_difference 'Role.count', 1 do
  #     post roles_path, role: {name: "New Role", level: "7" }
  #   end
  #   assert_redirected_to new_role_path
  #   assert_not flash.empty?
  # end
  
  # test "should not allow duplicate name" do
  #   assert_no_difference 'Role.count' do
  #     post roles_path, role: { name: @role.name, level: 7 }
  #   end
  #   assert_select 'div#error_explanation'
  #   assert_select 'div.field_with_errors'
  # end

  # test "should not allow duplicate level" do
  #   assert_no_difference 'Role.count' do
  #     post roles_path, role: { name: "New Role", level: @role.level }
  #   end
  #   assert_select 'div#error_explanation'
  #   assert_select 'div.field_with_errors'
  # end 

  # test "should allow edit" do
  #   old_id = @role.id
  #   old_name = @role.name
  #   old_lvl = @role.level
  #   patch role_path(@role), role: { name: "New Role", level: 3 }
  #   @role.reload
  #   assert_equal old_id, @role.id
  #   assert_not_equal old_name, @role.name
  #   assert_not_equal old_lvl, @role.level
  #   assert_not flash.empty?
  # end

  # test "should allow delete" do
  #   assert_difference 'Role.count', -1 do
  #     delete role_path(@role)
  #   end
  #   assert_redirected_to roles_url
  #   assert_not flash.empty?
  # end

end
