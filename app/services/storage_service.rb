class StorageService < BaseStorageService

  def save_file(name, file)
    file = Base64.decode64(file)
    case Rails.configuration.storage_drivers[:driver]
    when StorageDrivers::LOCAL
      service = LocalStorageService.new
    when StorageDrivers::AWS
      service = AwsStorageService.new
    when StorageDrivers::DATABASE
      service = DatabaseStorageService.new
    else
      raise 'Invalid driver'
    end

    service.save_file(name, file)
  end

  def get_file(blob)
    case blob.storage_type
    when Blob.storage_types[:local]
      service = LocalStorageService.new
    when Blob.storage_types[:aws]
      service = AwsStorageService.new
    when Blob.storage_types[:database]
      service = DatabaseStorageService.new
    else
      raise 'Unknown storage type'
    end

    service.get_file(blob)
  end

end
