class Category < ApplicationRecord
  has_many :categories_products, dependent: :destroy
  has_many :products, through: :categories_products

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end
end
