require 'test_helper'

class PlantsCreateTest < ActionDispatch::IntegrationTest
  
  def setup
    login_as(users(:admin_user))
    @plant = plants(:mother)
  end

  test "invalid information should fail" do
    get new_plant_path
    assert_no_difference 'Plant.count' do
      post plants_path, plant: { name: "a" * 55,
                                 planting_date: "1/1/2015",
                                 plant_state_id: 1 }
    end
    assert_template 'plants/_form'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "should create new plant" do
    get new_plant_path 
    assert_difference 'Plant.count', 1 do
      post plants_path, plant: { name: "A Plant",
                                 planting_date: "1/1/2015",
                                 plant_state_id: 1 }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'plants/show'
  end

  test "should not create plant if logged in as non admin" do 
    login_as(users(:reg_user))
    assert_no_difference 'Plant.count' do
      post plants_path, plant: { name: "A Plant",
                                 planting_date: "1/1/2015",
                                 plant_state_id: 1 }
    end
    assert_redirected_to login_url
    assert_not flash.empty?
  end


end
