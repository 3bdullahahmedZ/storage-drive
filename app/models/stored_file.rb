class StoredFile < ApplicationRecord
  validates :file, presence: true
end
