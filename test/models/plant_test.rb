require 'test_helper'

class PlantTest < ActiveSupport::TestCase
  
  def setup
    @plant = Plant.new( name: "A Plant",
                        species: "Planticus Maximus",
                        planting_date: "1/1/2015",
                        plant_state_id: 1)
  end

  test "should be valid" do 
    assert @plant.valid?    
  end

  test "name should be present" do 
    @plant.name = "   "
    assert_not @plant.valid?
  end

  test "planting date should be valid" do 
    @plant.planting_date = "0/0/00"
    assert_not @plant.valid?
  end

  test "planting date should not be blank" do
    @plant.planting_date = ""
    assert_not @plant.valid?
  end

  test "plant state should not be blank" do
    @plant.plant_state_id = " "
    assert_not @plant.valid?
  end

  test "name should not be longer than 50 characters" do
    @plant.name = "a" * 51
    assert_not @plant.valid?
  end

end
