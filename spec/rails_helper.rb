require 'spec_helper'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rails-controller-testing'

require 'devise'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include ActionDispatch::TestProcess

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  FactoryBot::SyntaxRunner.class_eval do
    include ActionDispatch::TestProcess
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  %i[controller view request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, type: type
    config.include ::Rails::Controller::Testing::TemplateAssertions, type: type
    config.include ::Rails::Controller::Testing::Integration, type: type
  end

  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
end
