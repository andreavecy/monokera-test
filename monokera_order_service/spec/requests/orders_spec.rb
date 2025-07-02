
require 'rails_helper'

RSpec.describe "Orders API", type: :request do
  let!(:customer) { create(:customer, id: 1) }

  describe "POST /orders" do

    before do
      customer
    end

    let(:valid_params) do
      {
        order: {
          customer_id: 1,
          status: "pending",
          total: 100.5,
          order_items_attributes: [
            { product_name: "Item 1", quantity: 2, price: 50.25 }
          ]
        }
      }
    end

    it "creates an order successfully" do
      post "/orders", params: valid_params
      expect(response).to have_http_status(:created)
    end

    it "fails without customer_id" do
      invalid_params = valid_params.deep_dup
      invalid_params[:order].delete(:customer_id)
      post "/orders", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails without status" do
      invalid_params = valid_params.deep_dup
      invalid_params[:order].delete(:status)
      post "/orders", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails without total" do
      invalid_params = valid_params.deep_dup
      invalid_params[:order].delete(:total)
      post "/orders", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails without order_items" do
      invalid_params = valid_params.deep_dup
      invalid_params[:order].delete(:order_items_attributes)
      post "/orders", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
