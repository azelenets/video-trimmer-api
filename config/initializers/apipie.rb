Apipie.configure do |config|
  config.app_name                = 'Video Trimmer'
  config.api_base_url            = ''
  config.doc_base_url            = '/api/documentation'
  config.validate                = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.reload_controllers      = Rails.env.development?
end
