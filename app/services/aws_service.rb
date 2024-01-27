require "uri"
require "net/http"

class AwsService
  def upload_object(name, file)
    aws_config = Rails.configuration.aws

    url = URI("#{aws_config[:url]}/#{aws_config[:bucket]}/#{name}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = set_headers(aws_config, Net::HTTP::Put.new(url), url, file)
    request.body = file

    response = https.request(request)

    response.code=="200"
  end

  def get_object(name)
    aws_config = Rails.configuration.aws

    url = URI("#{aws_config[:url]}/#{aws_config[:bucket]}/#{name}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = set_headers(aws_config, Net::HTTP::Get.new(url), url, '')

    response = https.request(request)

    response.body
  end

  private def set_headers(aws_config, request, url, body = '')
    request["Host"] = url.host

    date_time = Time.now.utc.strftime('%Y%m%dT%H%M%SZ')
    request["X-Amz-Date"] = date_time
    formatted_date = Time.now.utc.strftime('%Y%m%d')
    credential = "#{aws_config[:access_key]}/#{formatted_date}/us-east-1/s3/aws4_request"

    hashed_body = Digest::SHA256.hexdigest(body)
    request["x-amz-content-sha256"] = hashed_body
    canonical_request = "#{request.method}\n#{request.path}\n\nhost:#{url.host}\nx-amz-content-sha256:#{hashed_body}\nx-amz-date:#{date_time}\n\nhost;x-amz-content-sha256;x-amz-date\n#{hashed_body}"
    string_to_sign = "AWS4-HMAC-SHA256\n#{date_time}\n#{formatted_date}/us-east-1/s3/aws4_request\n#{Digest::SHA256.hexdigest(canonical_request)}"

    signing_key = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), "AWS4#{aws_config[:secret_access_key]}", formatted_date)
    signing_key = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing_key, aws_config[:region])
    signing_key = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing_key, 's3')
    signing_key = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing_key, 'aws4_request')
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), signing_key, string_to_sign)

    request["Authorization"] = "AWS4-HMAC-SHA256 Credential=#{credential},SignedHeaders=host;x-amz-content-sha256;x-amz-date,Signature=#{signature}"

    request
  end

end
