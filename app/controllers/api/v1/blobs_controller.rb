class Api::V1::BlobsController < ApplicationController
  def save_blob
    params.require([:id, :data])
    name = params[:id]
    file = params[:data]
    if self.is_base64(file)
      if Blob.find_by_name(name)
        render json: { status: 422, message: 'Object with given id exists.' }, status: :conflict
      else
        StorageService.new.save_file(name, file)
        render status: :created
      end
    else
      render json: { status: 422, message: 'Invalid base64.' }, status: :unprocessable_entity
    end
  end

  def get_blob
    params.require(:id)
    blob = Blob.find_by_name(params[:id])
    if blob
      data = StorageService.new.get_file(blob)
      render json: { id: blob.name, data: data.file, size: data.size, created_at: blob.created_at }, status: :ok
    else
      render json: { status: 404, message: 'File not found' }, status: :not_found
    end
  end

  private def is_base64(value)
    value.is_a?(String) && Base64.strict_encode64(Base64.decode64(value)) == value
  end
end
