class Product < ApplicationRecord
  has_many :categories_products, dependent: :destroy
  has_many :categories, through: :categories_products

  # ... rest of your existing Product model code ...
end
