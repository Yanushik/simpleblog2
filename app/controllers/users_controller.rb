class UsersController < ApplicationController

  def new
	@user = User.new
	@userprofile = Profile.new
	
  end
  
  def create
	@user = User.new(params[:user])
	
	if @user.save
	  @userprofile = Profile.new
	  @userprofile.user_id = @user.id
	  @userprofile.save
	  session[:user_id] = @user.id
	  
	  redirect_to root_url, notice: "Sign up complete!"
	else
	  render "new"
	end
  end
  
  def index
	@users = User.all
	
	 respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
	end
  end
  
  def show
	@usersblog = User.find_by_username(params[:id])
	#@usersblog = User.find_by_username(@search)
	respond_to do |format|
	  if @usersblog.blank?
		format.html { redirect_to(root_url, :notice => 'User not found')}
	  else
      format.html # show.html.erb
      format.json { render json: @usersblog }
	  end
    end
  end	
  def edit
	if session[:user_id]
	  @user = User.find(session[:user_id])
	else
		redirect_to(root_url, :notice=> 'please log in before attempting this')
	end
  end
  
  def update
	@user = User.find(session[:user_id])
	
	
	#@profile = @user.build_profile
	#@usersprofile = User.find(session[:user_id])
	respond_to do |format|
		if @user.update_attributes(params[:user])
			format.html{ redirect_to blogs_path, notice: 'Profile updated.' }
			format.json { head :no_content}
		else
			format.html { render action: "edit"}
			format.json { render json: @profile.errors, status: :unprocessable_entity }
		end
		
	end
  end
  

end
