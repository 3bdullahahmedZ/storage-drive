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
    case true
    when blob.local?
      service = LocalStorageService.new
    when blob.aws?
      service = AwsStorageService.new
    when blob.database?
      service = DatabaseStorageService.new
    else
      raise 'Unknown storage type'
    end

    service.get_file(blob)
  end

end
