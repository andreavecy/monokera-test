class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  enum status: {
    pending: 'pending',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  validates :customer_id, presence: true
  validates :status, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  accepts_nested_attributes_for :order_items, allow_destroy: true

  after_create_commit :publish_created_event

  private

  def publish_created_event
    # Rabbitmq::Publisher.publish('order_created', {
    #   id: self.id,
    #   customer_id: self.customer_id,
    #   status: self.status,
    #   total: self.total
    # })
    Rabbitmq::OrderPublisher.publish(self)
  end
end
