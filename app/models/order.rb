class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy

  enum status: { pending: 0, paid: 1, shipped: 2, cancelled: 3 }

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def calculate_taxes(subtotal, province)
    gst = subtotal * province.gst_rate
    pst = subtotal * province.pst_rate
    hst = subtotal * province.hst_rate
    gst + pst + hst
  end
end

