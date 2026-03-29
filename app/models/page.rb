class Page < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :content, presence: true
  
  # Required for ActiveAdmin search/filters
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "slug", "title", "updated_at"]
  end
  
  # Required for ActiveAdmin associations
  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  # Find page by slug
  def self.find_by_slug(slug)
    find_by(slug: slug)
  end
end
# Page model for editable about and contact pages
