class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy

  before_create :generate_order_number
  before_create :calculate_taxes

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, :tax, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  enum status: {
    pending: 0,
    paid: 1,
    shipped: 2,
    cancelled: 3
  }

  def generate_order_number
    self.order_number = "ORD-#{Time.now.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end

  def calculate_taxes
    # Calculate taxes based on province
    tax_calculation = TaxCalculator.calculate(subtotal, province.code)
    self.tax = tax_calculation[:total_tax]
    self.total = tax_calculation[:total]
  end

  def gst_amount
    tax_calculation[:gst]
  end

  def pst_amount
    tax_calculation[:pst]
  end

  def hst_amount
    tax_calculation[:hst]
  end

  private

  def tax_calculation
    @tax_calculation ||= TaxCalculator.calculate(subtotal, province.code)
  end
endclass Order < ApplicationRecord
  belongs_to :user
end
  validates :subtotal, presence: true
  validates :tax, presence: true
  validates :total, presence: true
