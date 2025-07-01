Rails.application.routes.draw do
  resources :orders do
    resources :order_items, only: [:create, :update, :destroy]
  end

  root "orders#index"
end
