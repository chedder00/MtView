require 'test_helper'

class UsersRegistrationTest < ActionDispatch::IntegrationTest
  
  test "invalid registration" do
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "",
                              email: "user@email.com",
                              role_id: 2,
                              password: "foo",
                              password_confirmation: "bar"}
    end
    assert_template 'users/new'
  end
  
end
