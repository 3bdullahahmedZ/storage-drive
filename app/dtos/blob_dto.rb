
class BlobDto
  attr_reader :id, :data, :size, :created_at

  def initialize(id:, data:, size:, created_at:)
    @id = id
    @data = data
    @size = size
    @created_at = created_at
  end
end
