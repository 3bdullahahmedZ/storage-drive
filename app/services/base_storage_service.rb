
class BaseStorageService

  def save_file(name, file)
    raise 'Did not implement save_file'
  end

  def get_file(blob)
    raise 'Did not implement get_file'
  end

end
