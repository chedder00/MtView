require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  def setup
    @base_title = "Mountain View Medicals"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Login | #{@base_title}"
    assert_template 'sessions/new'

  end

end
