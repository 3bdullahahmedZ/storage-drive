class AwsStorageService < BaseStorageService

  def save_file(name, file)
    id = SecureRandom.uuid
    is_saved = AwsService.new.upload_object(id, file)
    if is_saved
      Blob.create(id: id, name: name, storage_type: Blob.storage_types[:s3], meta_data: {}).save!
    else
      raise 'External service error.'
    end
  end

  public def get_file(blob)
    file = AwsService.new.get_object(blob.id)
    encoded_file = Base64.encode64(file)
    BlobDto.new(id: blob.name,data: encoded_file,size: file.size, created_at: blob.created_at)
  end

end
