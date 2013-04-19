class User < ActiveRecord::Base
  has_one :profile
  has_many :blogs
  has_secure_password
  
  attr_accessible :username, :email, :password, :password_confirmation, :user_id, :comment, :profile_picture
  
  validates_uniqueness_of :email, :username

  def to_param
    username
  end
  validate :password_length, :on => :create
   
  def password_length
    if password.length < 5 
      errors.add(:password, "Must be greater than 5 characters")
    end
  end
  
  def username_and_email
    [username, email].join('-')
  end
  
  def username_and_email=(umail)
    split = umail.split('-')
    self.username = split.first
    self.email = split.last
  end
end
