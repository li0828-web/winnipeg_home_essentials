class Customer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :province, optional: true
  has_many :orders

  validates :first_name, :last_name, :email, :address, :city, :postal_code, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/, message: "must be in format A1A 1A1" }

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address}, #{city}, #{province&.code || 'Unknown'} #{postal_code}"
  end
end