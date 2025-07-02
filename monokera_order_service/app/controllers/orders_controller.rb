class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    orders = Order.all
    render json: orders
  end

  # GET /orders/:id
  def show
    require Rails.root.join('lib/http/customer_client')
    customer = CustomerClient.find_customer(@order.customer_id)
    render json: {
      order: @order,
      customer: customer
    }
  end

  # GET /orders/count_by_customer/:customer_id
  def count_by_customer
    count = Order.where(customer_id: params[:customer_id]).count
    p "Orders count for customer #{params[:customer_id]}: #{count}"
    render json: { orders_count: count }
  end


  # POST /orders
  def create
    status_param = params.dig(:order, :status)

    unless Order.statuses.keys.include?(status_param)
      return render json: { error: "Invalid status. Allowed: #{Order.statuses.keys.join(', ')}" }, status: :unprocessable_entity
    end

    order = Order.new(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /orders/:id
  def update
    status_param = params.dig(:order, :status)

    if status_param.present? && !Order.statuses.keys.include?(status_param)
      return render json: { error: "Invalid status. Allowed: #{Order.statuses.keys.join(', ')}" }, status: :unprocessable_entity
    end

    if @order.update(order_params)
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /orders/:id
  def destroy
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Order not found" }, status: :not_found
  end

  def order_params
    params.require(:order).permit(
      :customer_id,
      :status,
      :total,
      order_items_attributes: [:product_name, :quantity, :price]
    )
  end
end
