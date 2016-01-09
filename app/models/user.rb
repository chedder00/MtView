class User < ActiveRecord::Base

  belongs_to :role

  has_many :tasks, dependent: :nullify
  has_many :notes, dependent: :nullify
  has_many :orders, dependent: :nullify
  
  attr_accessor :reset_token

  #ensure email is lowercase before saving
  before_save { self.email = email.downcase }
  #ensure name is present and maximum of 50 characters
  validates :name, presence: true, length: { maximum: 50 }, allow_nil: false
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

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #Returns true if reset token was generates less than 2 hours ago
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def authorized?(access, strict = false)
    access = (access == "Staff")? "Regular Employee" : access
    @roles ||= Role.all
    if(@role = @roles.find_by(name: access))
      if(strict)
        return self.role_id == @role.id
      else
        return self.role_id >= @role.id
      end
    end
  end

  #defines administrative access controll for user object
  def method_missing(method, *args, &block)
    @roles ||= Role.all
    if(method.to_s.match(/_access/))
      self.class.send :define_method, method do |arg=nil|
        return authorized?(method.to_s.gsub('_access','').titlecase, args[0])
        self.send(method)
      end
    else
      self.class.send :define_method, method do |arg=nil|
        return authorized?(method.to_s.gsub('?','').titlecase, args[0])
      end
      self.send(method)
    end
  end
    
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

    def staff
      where("role_id != ?", Role.find_by(name: "Reseller"))
    end
    
  end
end
