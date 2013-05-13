class Comment < ActiveRecord::Base
  attr_accessible :commentbody, :user_id
  has_and_belongs_to_many :blogs
  
  validate_presense_of :commentbody
  validates_uniqueness_of :commentbody
  
end
