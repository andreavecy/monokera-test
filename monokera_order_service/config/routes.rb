Rails.application.routes.draw do
  resources :orders do
    resources :order_items, only: [:create, :update, :destroy]
  end
  get 'orders/count_by_customer/:customer_id', to: 'orders#count_by_customer'

  root "orders#index"
end
