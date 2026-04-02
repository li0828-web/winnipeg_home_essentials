class Province < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :orders, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, length: { is: 2 }
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  def self.ransackable_attributes(auth_object = nil)
    ["code", "created_at", "gst_rate", "hst_rate", "id", "name", "pst_rate", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders", "users"]
  end

  def total_tax_rate
    gst_rate + pst_rate + hst_rate
  end
end
