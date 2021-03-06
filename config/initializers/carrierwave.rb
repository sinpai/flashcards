CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['S3_KEY'],
    aws_secret_access_key: ENV['S3_SECRET'],
    region: ENV['S3_REGION'],
    host: ENV['S3_ASSET_URL']
  }

  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory    = ENV['S3_BUCKET_NAME']
end
