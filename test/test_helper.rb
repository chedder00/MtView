ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # test to see if user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user to the application
  def login_as(user, options = {})
    password = options[:password] = 'Password1'
    if(integration_test?)
      post login_path, session: { email: user.email, password: password }
    else
      session[:user_id] = user.id
    end
  end

  def end_session
    if(integration_test?)
      delete logout_path
    else
      session.delete(:user_id)
    end
  end

  #Returns true only inside integration tests
  def integration_test?
    defined?(post_via_redirect)
  end
  
end
