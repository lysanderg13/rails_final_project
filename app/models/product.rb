class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_one_attached :image

  validates :price, :stock_quantity, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :category_id, presence: true
end
