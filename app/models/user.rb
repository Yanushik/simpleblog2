class User < ActiveRecord::Base
  has_one :profile
  has_many :blogs
  has_secure_password
  
  attr_accessible :username, :email, :password, :password_confirmation, :user_id, :comment, :profile_picture
  
  validates_uniqueness_of :email, :username

  def to_param
    username
  end
end
