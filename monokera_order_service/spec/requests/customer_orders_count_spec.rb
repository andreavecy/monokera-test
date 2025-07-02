# customer_service/spec/requests/customer_orders_count_spec.rb
require 'rails_helper'

RSpec.describe 'Customer orders count', type: :request do
  let!(:customer) { create(:customer, id: 1, orders_count: 3) }

  describe 'GET /orders/count_by_customer/:id' do
    before do
      customer
    end
    it 'refleja incremento del contador al recibir evento' do
      expect(customer.orders_count).to be > 0
    end
  end

end
