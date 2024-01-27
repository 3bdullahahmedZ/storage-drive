namespace :make do
  task :token => [:environment] do
    random_string = SecureRandom.hex(20)
    access_token = AccessToken.create(token: Digest::SHA256.hexdigest(random_string))
    access_token.save!

    token = Base64.strict_encode64("#{access_token.id}:#{random_string}")
    puts token
  end
end
