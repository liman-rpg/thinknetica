require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  post "authorizations/save_email", as: 'save_email_for_auth'
  get "authorizations/confirm_email", as: 'confirm_email_for_auth'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers , shallow: true , concerns: :votable do
      resources :comments, only: :create, defaults: { commentable: 'answers' }
    end
  end

  resources :attachments, only: :destroy

  patch "/answers/set_best_answer/:id", to: 'answers#set_best_answer', as: 'best_answer'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions, only: [ :index, :show, :create ] do
        resources :answers, only: [ :show, :create ], shallow: true
        get "/answers", to: 'questions#answers', on: :member
      end
    end
  end

  root to: "questions#index"
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
