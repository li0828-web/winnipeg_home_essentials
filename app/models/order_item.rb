class OrderItem < ApplicationRecord
  belongs_to :order
  
  validates :product_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  before_validation :calculate_subtotal
  
  private
  
  def calculate_subtotal
    self.subtotal = (quantity * unit_price).round(2)
  end
end
