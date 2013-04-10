class Profile < ActiveRecord::Base
  has_one :User
  
  attr_accessible :user_id, :comment, :profile_picture
end
