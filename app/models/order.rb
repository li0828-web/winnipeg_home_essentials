class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum status: { pending: 0, paid: 1, shipped: 2, cancelled: 3 }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Required for ActiveAdmin search/filters
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "order_number", "status", "subtotal", "tax", "total", "updated_at", "user_id", "province_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "products", "province", "user"]
  end

  def calculate_taxes(subtotal, province)
    gst = subtotal * province.gst_rate
    pst = subtotal * province.pst_rate
    hst = subtotal * province.hst_rate
    gst + pst + hst
  end
end
