class User < ActiveRecord::Base
  #ensure email is lowercase before saving
  before_save { self.email = email.downcase! }
  #ensure name is present and maximum of 50 characters
  validates :name, presence: true, length: { maximum: 50 }
  #Email validation
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #Use bcrypt engine to secure password
  has_secure_password

  #validate password constraints
  # *Must be between 6 and 25 characters
  # *Must include at least 1 lowercase letter
  # *Must include at least 1 uppercase letter
  # *Must include at least 1 number
  PASSWORD_REGEX = /\A^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,25}$\z/
  validates :password, format: { with: PASSWORD_REGEX, 
            message: "must be between 6 and 25 characters and contain 
            at least 1 uppercase and 1 lowercase character and 1 number" }
  
end
