class CategoriesProduct < ApplicationRecord
  belongs_to :category
  belongs_to :product

  validates :category_id, uniqueness: { scope: :product_id }
end
