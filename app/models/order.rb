class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  has_many :products, through: :order_items

  validates :total, :tax_amount, numericality: { greater_than_or_equal_to: 1 }, presence: true
  validates :order_num, presence: true
end