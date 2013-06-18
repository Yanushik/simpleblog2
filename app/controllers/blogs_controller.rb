class BlogsController < ApplicationController
  # GET /blogs
  # GET /blogs.json
  before_filter  :authorize, only:[:edit, :update, :new, :index]

  def index
    @blogs = Blog.all
	
    respond_to do |format|
	
      format.html # index.html.erb
      format.json { render json: @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
   #this should never work; intentional, and cruel.
	@blog = Blog.find_by_title(params[:id])
 #
  
		format.html { redirect_to(root_url, :notice => 'Invalid URL please stop ')}
		if @blog.blank?
	  		format.html { redirect_to(root_url, :notice => 'Invalid URL please stop ')}
	  	else
			format.html { redirect_to(root_url, :notice => 'Invalid URL please stop ')}
			format.html # show.html.erb
			format.json { render json: @blog }
		end
    
  end
  
  def show_comments
   #this should never work; intentional, and cruel.
	@blog = Blog.find(params[:id])
  
  @blogcomments = @blog.comments
  respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @blog; @blogcomments }
    end
  end
  #Comments code
  def comment_add
    unless session[:user_id] == nil
      @blog = Blog.find(params[:id])
      @comment = Comment.new;
      @comment.commentbody = (params[:commentbody])
      @comment.user_id = (params[:user_id])
      @blog.comments << @comment
      redirect_to :back
    else
      redirect_to :back
    end
  end
  
  
  #end of comments code
  # GET /blogs/new
  # GET /blogs/new.json
  
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blog }
    end
  end
  
  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
	if (@blog.user_id != session[:user_id])	
		redirect_to(user_path(current_user.username), :notice=> "Blog post with this ID either doesn't belong to you or does not exist")
	end
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(params[:blog])
	@recaptchaError
    respond_to do |format|
      if verify_recaptcha() and @blog.save
        format.html { redirect_to user_path(current_user.username), notice: 'Post was successfully created.' }
        format.json { render json: @blog, status: :created, location: @blog }
		@recaptchaError = ''
      else
		flash[:notice] = 'Your input did not match the ReCaptcha. Please try again.'
        format.html { render action: "new" }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.json
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html { redirect_to user_path(current_user.username), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end
  

  
  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @post = Blog.find(params[:id])
    @post.destroy

  end
end
