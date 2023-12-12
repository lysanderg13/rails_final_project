class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :price, numericality: { greater_than_or_equal_to: 1 }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end
