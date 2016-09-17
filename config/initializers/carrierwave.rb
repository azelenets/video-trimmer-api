$LOAD_PATH.unshift(Rails.root.join('lib', 'movie_processing'))
Dir[Rails.root.join('lib', 'movie_processing', '*.rb')].each {|file| require File.basename(file) }

CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777
  config.storage = :file
end
