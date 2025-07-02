class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  # GET /customers
  def index
    customers = Customer.all
    render json: customers
  end

  # GET /customers/:id
  def show
    require Rails.root.join('lib/http/order_client')

    customer = Customer.find(params[:id])
    orders_count = OrderClient.get_orders_count(customer.id)
    p "Orders count for customer #{customer.id}: #{orders_count}"
    render json: {
      id: customer.id,
      customer_name: customer.name,
      address: customer.address,
      orders_count: orders_count
    }
  end


  # POST /customers
  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer, status: :created
    else
      render json: customer.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /customers/:id
  def update
    if @customer.update(customer_params)
      render json: @customer
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /customers/:id
  def destroy
    @customer.destroy
    head :no_content
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Customer not found" }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :address)
  end
end
