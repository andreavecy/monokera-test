class Customer < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create_commit :publish_created_event

  private

  def publish_created_event
    Rabbitmq::CustomerPublisher.publish(self)
  end

end
