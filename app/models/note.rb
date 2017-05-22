class Note < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  has_many :tags
  
end
