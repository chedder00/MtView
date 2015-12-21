require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Real User",
                     email: "REAL@USER.COM",
                     hire_date: "1/1/2001",
                     address: "1234 Some Street",
                     city: "Some city",
                     state: "OR",
                     zipcode: "12345",
                     phone_number: "123-456-7890",
                     role_id: 2,
                     password: "Password1",
                     password_confirmation: "Password1")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "          "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "          "
    assert_not @user.valid?
  end

  test "name should not be longer than 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email shold not be longer than 255 characters" do
    @user.email = "a" * 250 + "@user.com"
    assert_not @user.valid?
  end

  test "should accept valid email addresses" do
    valid_emails = %w[user@example.com
                     USER@Example.com
                     U_SE_R@Ex.am.ple.org
                     alice+bob@foo.ca]
    valid_emails.each do |valid_email|
        @user.email = valid_email
        assert @user.valid?, "#{valid_email.inspect} should be valid"
    end    
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[user@example,com
                        user_at_example.org
                        user@example.
                        user@exam_ple.net
                        user@exam+ple.ca]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "email should be unique" do 
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "email address should be saved as lower case" do
    email = "Example@User.COM"
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.reload.email
  end

  test "password should be present and not blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be minimum of 6 characters" do
    @user.password = @user.password_confirmation = "P0" + "a" * 3
    assert_not @user.valid?
  end

  test "password should not be longer than 25 characters" do
    @user.password = @user.password_confirmation = "P0" + "a" * 25
    assert_not @user.valid?
  end

  test "should accept valid passwords using at least 1 uppercase character 
        1 lowercase letter and at least 1 number" do
    valid_passwords = %w[Mypass1
                         0checkSum
                         race2theEnd
                         Pa55W0rd]
    valid_passwords.each do |valid_password|
      @user.password = @user.password_confirmation = valid_password
      assert @user.valid?, "#{valid_password.inspect} should be valid"
    end
  end

  test "should reject invalid passwords" do
    invalid_passwords = %w[password
                           PASSWORD1
                           pass
                           password0
                           Password
                           5551212]
    invalid_passwords.each do |invalid_password|
      @user.password = @user.password_confirmation = invalid_password
      assert_not @user.valid?, "#{invalid_password.inspect} should be invalid"
    end
  end

end
