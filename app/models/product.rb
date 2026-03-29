class Product < ApplicationRecord
  belongs_to :category, optional: true
  
  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  # Scopes for filtering
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ?', 3.days.ago).where('created_at < ?', 3.days.ago) }
  scope :on_sale, -> { where('sale_price IS NOT NULL AND sale_price < price') }
  
  # Required for Ransack search
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "stock_quantity", "updated_at", "category_id", "sale_price"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
  
  # Helper methods
  def is_new?
    created_at >= 3.days.ago
  end
  
  def recently_updated?
    updated_at >= 3.days.ago && !is_new?
  end
  
  def on_sale?
    sale_price.present? && sale_price < price
  end
end
class Product < ApplicationRecord
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
  scope :on_sale, -> { where('sale_price IS NOT NULL') }
end
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # Custom validation messages
  # Calculate discount percentage for sale items
  def discount_percentage
    return 0 unless on_sale?
    ((price - sale_price) / price * 100).round
  end
  # Return sale price if on sale, otherwise regular price
  def current_price
    on_sale? ? sale_price : price
  end
