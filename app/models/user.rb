class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, length: { maximum: 255 }, allow_blank: true
  validates :city, length: { maximum: 100 }, allow_blank: true
  validates :postal_code, length: { maximum: 10 }, format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/, message: "should be valid Canadian postal code" }, allow_blank: true

  # Required for ActiveAdmin search/filters
  def self.ransackable_attributes(auth_object = nil)
    ["address", "admin", "city", "created_at", "email", "id", "postal_code", "province_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders", "province"]
  end

  def has_address?
    address.present? && city.present? && postal_code.present? && province.present?
  end
end
