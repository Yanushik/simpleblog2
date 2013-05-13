require 'test_helper'

class UserTest < ActiveSupport::TestCase
   # test "the truth" do
   #   assert true
   # end
  def test_user_creation
   #test for existence of username
   user = user.new()
   user.username  = ""
   assert ! user.valid?
  
   #test for password length
   user.username = "okaok"
   user.password = "213"
   assert !user.valid?
  
    #test for password length again
   user.password = "1q23091209"
    assert !user.valid?
  
    #test for existence of email
    user.email = "aodkaodkaodkaod"
    assert !user.valid?
  
  end
end
