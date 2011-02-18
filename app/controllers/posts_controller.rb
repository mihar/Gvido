class PostsController < InheritedResources::Base
  before_filter :set_section  
  respond_to :html
   
  def index
    @notices = Notice.all
    super
  end
  
  protected
  
  def collection
    @posts ||= end_of_association_chain.paginate :page => params[:page], :per_page => 10
  end
  
  def set_section
    @section = :posts
  end
end
