class Image < ApplicationRecord
  belongs_to :product, inverse_of: :images
  mount_uploaders :img, ImageUploader
end
