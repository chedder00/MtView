require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  
  def setup
    @base_title = "Mountain View Medicals"
  end

  test "should redirect home if not logged in" do
    get :home
    assert_response :redirect
  end

  test "should get home if logged in" do
    login_as(users(:reg_user))
    get :home
    assert_response :success
    assert_select "title", "Home | #{@base_title}" 
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@base_title}" 
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
