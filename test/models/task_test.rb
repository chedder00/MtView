require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  
  def setup
    @task = Task.new( name: "Do Something",
                      description: "A very long description",
                      plant_id: plants(:mother).id )
  end

  test "should be valid" do
    assert @task.valid?
  end
  
  test "name should not be blank" do
    @task.name = ""
    assert_not @task.valid?
  end

  test "name should not be longer than 100 characters" do 
    @task.name = "a" * 101
    assert_not @task.valid?
  end

  test "task should be associated with a plant" do
    @task.plant_id = nil
    assert_not @task.valid?
  end

  
end
