require 'rails_helper'

RSpec.describe "Customers API", type: :request do
  describe "POST /customers" do
    let(:valid_attributes) do
      {
        customer: {
          name: "Andrea Vecino",
          email: "andrea@example.com",
          phone: "3001234567",
          address: "Calle 123"
        }
      }
    end

    context "Successful creation" do
      it "creates a customer" do
        post "/customers", params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq("Andrea Vecino")
      end
    end

    context "Failure cases" do
      it "fails without name" do
        invalid = valid_attributes.deep_merge(customer: { name: nil })
        post "/customers", params: invalid
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails without email" do
        invalid = valid_attributes.deep_merge(customer: { email: nil })
        post "/customers", params: invalid
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails without phone" do
        invalid = valid_attributes.deep_merge(customer: { phone: nil })
        post "/customers", params: invalid
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "fails without address" do
        invalid = valid_attributes.deep_merge(customer: { address: nil })
        post "/customers", params: invalid
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /customers" do
    it "returns a list of customers" do
      create_list(:customer, 3)
      get "/customers"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /customers/:id" do
    it "returns the customer" do
      customer = create(:customer)
      get "/customers/#{customer.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(customer.id)
    end

    it "returns 404 if not found" do
      get "/customers/9999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT /customers/:id" do
    it "updates the customer" do
      customer = create(:customer)
      put "/customers/#{customer.id}", params: { customer: { name: "New Name" } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq("New Name")
    end

    it "returns 404 if not found" do
      put "/customers/9999", params: { customer: { name: "New Name" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /customers/:id" do
    it "deletes the customer" do
      customer = create(:customer)
      delete "/customers/#{customer.id}"
      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 if not found" do
      delete "/customers/9999"
      expect(response).to have_http_status(:not_found)
    end
  end
end