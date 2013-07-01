class ApplicationController < ActionController::Base
  before_filter :load_application_wide_varibales

  
  private
   def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end
     helper_method :current_user
   end
  
  
  
  def load_application_wide_varibales   
    
    def show
        @post = Post.find(params[:id])
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @post }
      end
    end 
    
  def get_subcategory_and_post
   @sub_category = SubCategory.all
  end
  
  def new
    @post = Post.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end

  
class PostController < ActionController::Base
  before_filter :get_subcategory_and_post, only: [:show]

    def show
      @post = Post.find(params[:id])
      if request.path != post_path(@post)
          redirect_to @post, status: :moved_permanently
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @post }
    end
   end
  end
  

  
  class SubCategoryController < ActionController::Base
    before_filter :get_subcategory_and_post
  end

end