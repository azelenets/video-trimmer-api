RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :controller
  config.before :suite do
    Warden.test_mode!
  end
end
