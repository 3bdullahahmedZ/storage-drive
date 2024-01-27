
class LocalStorageService < BaseStorageService

  def save_file(name, file)
    id = SecureRandom.uuid
    location = Rails.configuration.storage_drivers[:local_storage_path] + '/' + id
    File.write(location, file)
    Blob.create(id: id, name: name, storage_type: Blob.storage_types[:local], meta_data: {:location => location}).save!
  end

  public def get_file(blob)
    location = blob.meta_data['location']
    file = File.open(location, "r")
    encoded_file = Base64.strict_encode64(file.read)
    BlobDto.new(id: blob.name,data: encoded_file,size: file.size, created_at: blob.created_at)
  end

end
