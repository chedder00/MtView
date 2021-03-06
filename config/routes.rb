Rails.application.routes.draw do

  root 'static_pages#home'
  
  resources :users, except: :show do
    resources :tasks, only: :index
    resources :notes
    resources :orders, except: :new do
      resources :items, only: :create
    end
  end

  resources :orders, only: :index do
    patch 'submit' => 'orders#submit'
    resources :items, only: :show
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :roles, only: :index
  resources :plant_states
  resources :plants do
    resources :tasks
    resources :notes
    resources :measurements, except: [:show, :index]
    get  'clone' => 'plants#clone'
    post 'clone' => 'plants#clone_create'
  end
  resources :tasks do
    patch 'add_item' => 'tasks#add_item'
    resources :items, only: [:create]
  end

  resources :items, only:[:destroy] do
    get  'return' => 'items#return'
    patch 'return' => 'items#return_update'
  end

  resources :inventory_items do
    resources :notes
  end
  resources :notes

  #REPORTS
  resource :reports, as: :report, only: :new do
    get 'full_plant' => 'reports#full_plant'
    get 'full_note'  => 'reports#full_note'
    get 'full_user'  => 'reports#full_user'
    get 'full_task'  => 'reports#full_task'
    get 'full_item'  => 'reports#full_item'
    get 'full_order' => 'reports#full_order'
    get 'receipt'    => 'reports#order_receipt'
  end

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
