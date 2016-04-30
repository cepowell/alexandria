Rails.application.routes.draw do
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'published#index'
  
  #adding document routes
  resources :documents do
    resources :attachments, only: [:new, :create, :index, :destroy]
  end
  
  get 'shared' => 'documents#shared', :as => :shared
  post 'documents/:id/share' => 'documents#share', :as => :share_document
  delete 'documents/share/:id' => 'documents#removeShare', :as => :remove_share
  #get 'documents/'
  get 'home/index'
 
  
  #adding collection routes
  resources :collections
  
  post 'new_comment' => 'comments#new'
  post 'new_col_comment' => 'comments#newCol'
  
  post 'new_like' => 'likes#new'
  delete 'unlike' => 'likes#unlike'
  post 'new_col_like' => 'likes#newColLike'
  delete 'col_unlike' => 'likes#colUnlike'
  
  get 'published' => 'published#index'
  get 'published/doc/:id' => 'published#showDoc', :as => :pub_doc
  get 'published/col/:id' => 'published#showCol', :as => :pub_col
  get 'published/col/:id/doc/:id' => 'published#showDocInCol', :as => :pub_col_doc
  
  # for searching through tags
  # post 'published/search' => 'published#search', :as => :pub_search
  
  #adding sign up/log in routes
  resources :users
  
  # routes to sign up and log in
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  get 'login' => 'sessions#new', :as => 'loginuser'
  post 'login' => 'sessions#find', :as=> 'finduser'
  
  #for 3rd party authentication, creates a new session for this user, attached to login
  get  'auth/:provider/callback' => 'sessions#create',:as => 'login'
  # gives the option to log out
  get 'logout' => 'sessions#destroy'
  # post 'logout' => 'sessions#destroy' -- this was initially in the pastebin
  # if the authentication doesn't go through
  get  'auth/failure' => 'sessions#failure'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # testing to see if this will fix an error I am 
  # getting with before_filter

  # You can have the root of your site routed with "root"
  

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
