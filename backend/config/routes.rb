Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # pharmacy routes
  post "/pharmacies", to: "pharmacies#index"

  # user routes
  get "/users/top_n", to: "users#top_n"

  # pharmacy_mask routes
  # get "/pharmacy_masks", to: "pharmacy_masks#index"
  resources :pharmacies, only: [:show] do
    resources :pharmacy_masks, only: [:index]
  end

  get "/mask_transactions/analysis", to: "mask_transactions#analysis"

  # mask_transaction routes
  post "/mask_transactions", to: "mask_transactions#create"
end
