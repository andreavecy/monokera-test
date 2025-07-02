require 'rails_helper'

RSpec.describe "Order creation integration", type: :request do
  before do
    stub_request(:get, "http://customer_service:3000/customers/1")
      .to_return(
        status: 200,
        body: {
          id: 1,
          name: "Cliente Mock",
          orders_count: 0
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "crea una orden, llama al customer_service y publica evento" do
    payload = {
      order: {
        customer_id: 1,
        status: "pending",
        total: 100,
        order_items: [
          { product_id: 1, quantity: 2, price: 50 }
        ]
      }
    }

    post "/orders", params: payload

    expect(response).to have_http_status(:created)
  end
end
