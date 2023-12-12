class Category < ApplicationRecord
  validates :category_name, uniqueness: true
  validates :category_name, length: { maximum: 255 }
end
