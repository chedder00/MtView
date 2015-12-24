require 'test_helper'

class PlantsDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @plant = plants(:mother)
  end

  test "non admin should not be able to delete plants" do 
    login_as(users(:reg_user))
    assert_no_difference 'Plant.count' do
      delete plant_path(@plant)
    end
  end

  test "admin users should be able to delete plants" do
    login_as(users(:admin_user))
    assert_difference 'Plant.count', -1 do
      delete plant_path(@plant)
    end
  end
    
end
