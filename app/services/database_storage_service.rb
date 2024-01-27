
class DatabaseStorageService < BaseStorageService

  def save_file(name, file)
    id = SecureRandom.uuid
    encoded_file = Base64.encode64(file)
    stored_file = StoredFile.create(file: encoded_file)

    Blob.create(id: id, name: name, storage_type: Blob.storage_types[:database], meta_data: {:stored_file_id => stored_file.id}).save!
  end

  public def get_file(blob)
    stored_file_id = blob.meta_data['stored_file_id']

    file = StoredFile.find(stored_file_id).file
    decoded_file = Base64.decode64(file)

    BlobDto.new(id: blob.name,data: file,size: decoded_file.size, created_at: blob.created_at)
  end

end
