class User < ActiveRecord::Base

  has_secure_password
  mount_uploader :image, ImageUploader
end
