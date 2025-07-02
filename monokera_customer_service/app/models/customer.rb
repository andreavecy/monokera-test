class Customer < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :address, presence: true

  after_create_commit :publish_created_event

  private

  def publish_created_event
    Rabbitmq::Publisher.publish('customer_created', {
      id: self.id,
      name: self.name,
      email: self.email,
      phone: self.phone,
      address: self.address
    })
  end
end
