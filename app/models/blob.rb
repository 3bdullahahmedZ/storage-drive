class Blob < ApplicationRecord
  validates :name, presence: true
  validates :storage_type, presence: true
  validates :meta_data, presence: true
  enum storage_type: [:s3, :local, :database]
end
