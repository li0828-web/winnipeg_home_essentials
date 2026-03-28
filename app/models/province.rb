class Province < ApplicationRecord
  has_many :users
  has_many :orders

  validates :code, presence: true, uniqueness: true, length: { is: 2 }
  validates :name, presence: true
  validates :gst_rate, :pst_rate, :hst_rate, numericality: { greater_than_or_equal_to: 0 }

  def tax_rate
    if hst_rate > 0
      hst_rate
    else
      gst_rate + pst_rate
    end
  end
end