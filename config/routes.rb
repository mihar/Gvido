App::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }
  
  match 'dashboard', :to => 'dashboard#index'
  match 'dashboard', :to => 'dashboard#index', :as => 'user_root'

  resources :payments, :only => [:index, :show] do
    member do
      get :settle
      get :unsettle
      delete :destroy
    end
  end
  
  get 'lessons' => 'lessons#index'
  put 'lessons' => 'lessons#update'
  
  resources :statuses
  
  resources :billing_options  
  
  resources :students do
    resources :personal_contacts
    resources :enrollments do
      get :mentor_instruments, :on => :collection
    end
  end
  
  resources :abouts do
    get :all, :on => :collection
  end
  
  resources :notices do
    get :all, :on => :collection
  end
  
  resources :questions do
    get :all, :on => :collection
  end
  
  resources :references do
    get :all, :on => :collection
  end
  
  resources :schedules do
    get :all, :on => :collection
  end
  
  resources :posts do
    get :all, :on => :collection
  end
  
  resources :movies do
    get :all, :on => :collection
  end
  
  resources :links do
    get :all, :on => :collection
  end
  
  resources :link_categories do
    get :all, :on => :collection
  end
  
  resources :album_categories do
    get :all, :on => :collection
  end
  
  resources :location_sections do
    get :all, :on => :collection
    resources :locations
  end
  
  resources :locations do
    get :all, :on => :collection
    member do
      post :add_mentor
      post :destroy_mentor
    end
  end
  
  resources :albums do
    get :all, :on => :collection
    resources :photos do
      get :all, :on => :collection
    end
  end
  
  resources :instruments do
    get :all, :on => :collection
    get :detail, :on => :member
    resources :shop_advices do
      get :all, :on => :collection
    end
  end
    
  resources :mentors do
    get :all, :on => :collection
    member do
      post :add_instrument
      post :destroy_instrument
      get  :update_positions
      get  :details
      get  :edit_login_account
      put  :update_login_account
    end
  end
  
  resources :gigs do
    get :all, :on => :collection
    member do
      post :add_mentor
      post :destroy_mentor
    end
  end
  
  resources :contacts do
    get :new_report, :on => :collection
  end
  
  root :to => "posts#index"
end
