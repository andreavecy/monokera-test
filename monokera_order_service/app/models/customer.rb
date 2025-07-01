class Customer < ApplicationRecord
  validates :name, :email, presence: true
end
