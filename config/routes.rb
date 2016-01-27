Rails.application.routes.draw do

  get 'complements/index'

  get 'complements/show'

  get 'complements/edit'

  get 'complements/update'

  get 'complements/new'

  get 'complements/create'

  get 'complements/destroy'

  get 'raw_subcategories/index'

  get 'raw_subcategories/show'

  get 'raw_subcategories/new'

  get 'raw_subcategories/create'

  get 'raw_subcategories/edit'

  get 'raw_subcategories/update'

  get 'raw_subcategories/destroy'

  get 'raw_categories/index'

  get 'raw_categories/show'

  get 'raw_categories/new'

  get 'raw_categories/create'

  get 'raw_categories/edit'

  get 'raw_categories/update'

  get 'raw_categories/destroy'

  get 'raws/index'

  get 'raws/show'

  get 'raws/edit'

  get 'raws/update'

  get 'raws/new'

  get 'raws/create'

  get 'raws/destroy'

  get 'coupons/coupon_batch_actions' => "coupons#coupon_batch_actions", :as => 'coupon_batch_actions'

  get 'coupons/index'

  get 'coupons/show'

  get 'coupons/new'

  get 'coupons/create'

  get 'coupons/edit'

  get 'coupons/update'

  get 'coupons/destroy'

  get 'pictures/edit'

  get 'pictures/destroy'

  get 'colors/index'

  get 'colors/show'

  get 'colors/new'

  get 'colors/create'

  get 'colors/edit'

  get 'colors/update'

  get 'colors/destroy'

  get 'single_articles/index'

  get 'single_articles/show'

  get 'categories/index'

  get 'categories/show'

  get 'categories/new'

  get 'categories/edit'

  get 'materials/index'

  get 'materials/show'

  get 'materials/new'

  get 'materials/edit'

  get 'articles/index'

  get 'articles/show'

  get 'articles/show_pics' => "articles#show_pics", :as => 'articles_gallery'

  get 'articles/new'

  get 'articles/create'

  get 'articles/edit'

  get 'articles/update'

  get 'articles/destroy'

  get 'articles/batch_actions' => "articles#batch_actions", :as => 'batch_actions'

  get 'articles/set_picture' => "articles#set_picture", :as => 'set_picture'

  get 'articles/import_view' => "articles#import_view", :as => 'import_view'

  get 'articles/edit_multiple' => "articles#edit_multiple", :as => 'edit_multiple'

  get 'articles/update_multiple' => "articles#update_multiple", :as => 'update_multiple'

  get 'articles/raw_index' => "articles#raw_index", :as => 'raw_index'

  get 'articles/raw_new' => "articles#raw_new", :as => 'raw_new'

  get 'articles/raw_show' => "articles#raw_show", :as => 'raw_show'

  get 'articles/set_auction' => "articles#set_auction", :as => 'set_auction'

  get 'articles/create_auction' => "articles#create_auction", :as => 'create_auction'

  get 'articles/index_auction' => "articles#index_auction", :as => 'index_auction'

  get 'complements/complement_set_picture' => "complements#complement_set_picture", :as => 'complement_set_picture'

  root :to => 'dashboards#index'

  devise_for :admin_users, controllers: {sessions: "admin_users/sessions", registrations: "admin_users/registrations"}

  devise_scope :admin_user do
    get "login", to: "devise/sessions#new"
    authenticated :admin_user do
      root :to => 'dashboards#index', as: :authenticated_root
      get "sign_up", to: "devise/registrations#new"
    end
    unauthenticated :admin_user do
      root :to => 'admin_users/sessions#new', as: :unauthenticated_root
    end


    get "admin_users/sign_out" => redirect("devise/sessions#new")


    resources :complements do
      put :complement_set_picture, on: :collection
    end
    resources :dashboards
    resources :categories
    resources :articles do
      get :index_auction, on: :collection
      put :create_auction, on: :collection
      put :set_auction, on: :collection
      get :raw_edit, on: :collection
      get :raw_new, on: :collection
      put :raw_show, on: :collection
      get :raw_index, on: :collection
      put :batch_actions, on: :collection
      put :set_discount, on: :collection
      put :set_picture, on: :collection
      post :import, on: :collection
      put :edit_multiple, on: :collection
      post :update_multiple, on: :collection
    end
    resources :materials
    resources :single_articles
    resources :colors
    resources :pictures
    resources :raw_categories
    resources :raw_subcategories
    resources :coupons do
      put :coupon_batch_actions, on: :collection
    end

  end



    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'dashboards#index'

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
