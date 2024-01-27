# frozen_string_literal: true

class Authenticator
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    authorization_header = request.env["HTTP_AUTHORIZATION"]

    unless authorization_header
      return [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
    end

    authorization_header = authorization_header.split(' ').last
    decoded_token = Base64.decode64(authorization_header)

    parts = decoded_token.split(':')
    unless parts.length == 2
      return [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
    end

    token_id = parts[0]
    hashed_token = Digest::SHA256.hexdigest(parts[1])
    access_token = AccessToken.find(token_id)

    unless access_token
      return [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
    end

    if hashed_token == access_token.token
      @app.call(env)
    else
      [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
    end
  end
end

