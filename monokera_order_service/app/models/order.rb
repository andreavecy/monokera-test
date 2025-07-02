class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  enum :status, { pending: "pending", completed: "completed", cancelled: "cancelled" }

  validates :customer_id, presence: true
  validates :status, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :order_items, presence: true

  validate :validate_status_enum

  accepts_nested_attributes_for :order_items, allow_destroy: true

  after_create_commit :publish_created_event

  validate :validate_customer_exists

  private

  def validate_customer_exists
    require Rails.root.join('lib/http/customer_client')
    customer = CustomerClient.find_customer(self.customer_id)
    errors.add(:customer_id, "Customer does not exist") if customer.nil?
  end


  def validate_status_enum
    unless status.in?(self.class.statuses.keys)
      errors.add(:status, "is invalid. Allowed values are: #{self.class.statuses.keys.join(', ')}")
    end
  end

  def publish_created_event
    Rabbitmq::Publisher.publish('order_created', {
      id: self.id,
      customer_id: self.customer_id,
      status: self.status,
      total: self.total,
      items: self.order_items.map do |item|
        {
          id: item.id,
          product_name: item.product_name,
          quantity: item.quantity,
          price: item.price
        }
      end
    })
  end
end
