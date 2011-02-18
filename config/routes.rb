App::Application.routes.draw do
  resources :abouts
  resources :notices
  resources :location_sections
  resources :questions
  resources :references
  resources :schedules
  resources :posts
  resources :notices
  resources :movies
  resources :links
  resources :link_categories
  resources :album_categories
  
  resources :location_sections do
    resources :locations
  end
   
  resources :albums do
    resources :photos
  end
  
  resources :instruments do
    resources :shop_advices
  end
  
  resources :locations do
    member do
      post 'add_mentor'
      post 'destroy_mentor'
    end
  end
    
  resources :mentors do
    member do
      post 'add_instrument'
      post 'destroy_instrument'
      get 'update_positions'
    end
  end
  
  resources :gigs do
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
