App::Application.routes.draw do
  match 'dashboard', :to => 'dashboard#index'
  resources :people do 
    get :all, :on => :collection
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
      post 'add_mentor'
      post 'destroy_mentor'
    end
  end
  
  resources :albums do
    get :all, :on => :collection
    resources :photos
  end
  
  resources :instruments do
    get :all, :on => :collection
    resources :shop_advices do
      get :all, :on => :collection
    end
  end
    
  resources :mentors do
    get :all, :on => :collection
    member do
      post 'add_instrument'
      post 'destroy_instrument'
      get 'update_positions'
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
