class Api::V1::BlobsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def save_blob
    name = params[:id]
    file = params[:data]

    unless name.blank? && file.blank?
      return render json: { status: 422, message: 'Input missing.' }, status: :unprocessable_entity
    end

    if Blob.find_by_name(name)
      return render json: { status: 409, message: 'Object with given id exists.' }, status: :conflict
    end

    unless self.is_base64(file)
      return render json: { status: 422, message: 'Invalid base64.' }, status: :unprocessable_entity
    end

    StorageService.new.save_file(name, file)
    render json: {}, status: :created
  end

  def get_blob
    params.require(:id)
    blob = Blob.find_by_name(params[:id])
    if blob
      dto = StorageService.new.get_file(blob)
      render json: { id: blob.name, data: dto.data, size: dto.size, created_at: dto.created_at }, status: :ok
    else
      render json: { status: 404, message: 'Blob not found' }, status: :not_found
    end
  end

  private def is_base64(value)
    value.is_a?(String) && Base64.strict_encode64(Base64.decode64(value)) == value
  end
end
