class Post < ApplicationRecord
  belongs_to :user

  include ImageUploader[:image]

  validates :image, presence: true
end
