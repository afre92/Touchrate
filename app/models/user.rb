class User < ActiveRecord::Base
  has_secure_password
  has_attached_file :avatar, styles: { small: "300x300"}, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # def self.to_csv
  #   CSV.generate do |csv|
  #     csv << column_names
  #     all.each do |users|
  # end
end
