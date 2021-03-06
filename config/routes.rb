Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users,
    path_names: {
      sign_in: 'login',
      sign_out: 'logout' #,
      #password: 'secret',
      #confirmation: 'verification',
      #unlock: 'unblock',
      #registration: 'register',
      #sign_up: 'cmon_let_me_in'
    },
    controllers: {
      sessions: 'users/sessions',
      omniauth_callbacks: "users/omniauth_callbacks"
    },
    :skip => [:registrations, :password]

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy', as: :logout
  end

  namespace :api do
    resources :users, only: [:index]
    resources :spots, only: [:index, :create]
    resources :comments, only: [:index, :create]
    resources :veredicts, only: [:index, :create]
    resources :tag_alongs, only: [:create, :destroy]
    resources :notifications, only: [:index, :update]
    resources :recommendations, only: [:index, :create]

    get '/validation/username_exists' => 'validation#username_exists'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'

  get '/signup' => 'external_users#new', as: :signup
  post '/signup' => 'external_users#create'

  get '/tag_along/add' => 'tag_along#add', as: :tag_along_add
  get '/tag_along' => 'tag_along#index', as: :tag_along

  get '/movies' => 'main#movies', as: :movies

  get '/test' => 'main#test', as: :test

  get '/tvshows' => 'main#tvshows', as: :tvshows
  get '/notifications' => 'main#notifications', as: :notifications

  get '/spots/new' => 'spots#new'
  get ':username/spots/:spot_id' => 'spots#show'
  get ':username/spots/' => 'spots#index'
  get ':username/' => 'spots#index'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
