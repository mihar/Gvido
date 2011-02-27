class QuestionsController < InheritedResources::Base
  load_and_authorize_resource
  before_filter :set_section
  layout :pick_layout
  
  def create
    create! { all_questions_path }
  end
  
  def update
    update! { all_questions_path }
  end
  
  def destroy
    destroy! { all_questions_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :abouts
  end
  
end
