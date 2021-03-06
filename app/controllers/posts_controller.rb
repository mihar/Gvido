class PostsController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => :all
  before_filter :set_section  
  layout :pick_layout
   
  def index
    @notices = Notice.non_expired
    index!
  end
  
  def create
    create! { all_posts_path }
  end
  
  def update
    update! { all_posts_path }
  end
  
  def destroy
    destroy! { all_posts_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def collection
    @posts ||= end_of_association_chain.paginate :page => params[:page], :per_page => 10
  end
  
  def set_section
    @section = :posts
  end
end
