require 'test_helper'

class PlantsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @plant = plants(:mother)
  end

  test "non admin should only be able to change state and harvest date" do
    login_as(users(:reg_user))
    old_name = @plant.name
    old_date = @plant.planting_date
    #try to change name and planting date should fail
    patch plant_path(@plant), plant: { name: "New Plant Name",
                                       planting_date: "2/2/99" }
    @plant.reload
    assert_equal old_name, @plant.name
    assert_equal old_date, @plant.planting_date
    #changing harvest date and state should succeed
    old_harvest = @plant.harvest_date
    old_state = @plant.plant_state_id
    patch plant_path(@plant), plant: { harvest_date: "2/2/99",
                                       plant_state_id: 3 }
    assert_response :redirect
    @plant.reload
    assert_not_equal old_harvest, @plant.harvest_date
    assert_not_equal old_state, @plant.plant_state_id
  end

  test "non staff members should not be able to change any attributes" do
    login_as(users(:reseller_user))
    old_name = @plant.name
    old_date = @plant.planting_date
    old_state = @plant.plant_state_id
    patch plant_path(@plant), plant: { name: "New Plant Name",
                                       planting_date: "2/2/99",
                                       plant_state_id: 5 }
    @plant.reload
    assert_equal old_name, @plant.name
    assert_equal old_date, @plant.planting_date
    assert_equal old_state, @plant.plant_state_id
    assert_redirected_to root_url
    assert_not flash.empty?
  end

  test "admin shold be able to change all attributes" do
    login_as(users(:admin_user))
    old_name = @plant.name
    old_pdate = @plant.planting_date
    old_hdate = @plant.harvest_date
    old_state = @plant.plant_state_id
    patch plant_path(@plant), plant: { name: "New Name",
                                       planting_date: "3/3/2012",
                                       harvest_date: "3/4/2015",
                                       plant_state_id: 20 }
    @plant.reload
    assert_not_equal old_name, @plant.name
    assert_not_equal old_pdate, @plant.planting_date
    assert_not_equal old_hdate, @plant.harvest_date
    assert_not_equal old_state, @plant.plant_state_id

  end

end
