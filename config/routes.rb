Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'homes/index'
  get 'homes/between'
  get 'homes/at_date'
  get 'homes/scale'
  get 'homes/between2'
  post 'homes/between3'
  get 'homes/statistics'
  get 'homes/department/:department_id' => 'homes#department'
  get 'homes/user/:user_id' => 'homes#user'
  get 'projects/all'
  get 'projects/excel'
  get 'projects/department/:department_id' => 'projects#department'
  root 'homes#index'
  resources :cooperations
  # resources :modifications
  resources :plans do
    resources :projects, shallow: true
    resources :modifications, shallow: true
  end
  
  resources :projects do
    resources :modifications, shallow: true
  end
  
  get 'people/index'



  # root 'tasks#index'
  resources :tasks
  resources :departments
  
  devise_for :users

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
