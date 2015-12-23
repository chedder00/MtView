class User < ActiveRecord::Base

  #ensure email is lowercase before saving
  before_save { self.email = email.downcase }
  #ensure name is present and maximum of 50 characters
  validates :name, presence: true, length: { maximum: 50 }
  #Email validation
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  #Use bcrypt engine to generate secure password hash
  has_secure_password

  #validate password constraints
  # *Must be between 6 and 25 characters
  # *Must include at least 1 lowercase letter
  # *Must include at least 1 uppercase letter
  # *Must include at least 1 number
  PASSWORD_REGEX = /\A^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,25}$\z/
  validates :password, format: { with: PASSWORD_REGEX, 
            message: "must be between 6 and 25 characters and contain 
            at least 1 uppercase and 1 lowercase character and 1 number" },
            allow_nil: true

  #Ensure user has a role
  validates :role_id, presence: true
  

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create( string, cost: cost )
    end

    #return a random url safe token
    def new_token
      SecureRandom.urlsafe_base64
    end
    
  end

end
