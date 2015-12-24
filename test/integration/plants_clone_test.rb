require 'test_helper'

class PlantsCloneTest < ActionDispatch::IntegrationTest
  
  def setup
    @plant = plants(:mother)
  end

  test "any regular or above user should be able to clone a plant" do
    login_as(users(:reg_user))
    assert_difference 'Plant.count', 5 do
      post plant_clone_path(@plant), clone: { clone_date: "2/2/25",
                                              clone_qty: 5 }
    end
  end

  test "non staff members should not be able to create clones" do
    login_as(users(:reseller_user))
    assert_no_difference 'Plant.count' do
      post plant_clone_path(@plant), clone: { clone_date: "2/2/25",
                                              clone_qty: 5 }
    end
  end

end
