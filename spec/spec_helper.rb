require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Configure Rails Envinronment
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment.rb',  __FILE__)
require 'rspec/rails'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f  }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.active_support.test_order = :random

  config.include FactoryGirl::Syntax::Methods
  config.include BzCore::SpecUtility

  config.include Devise::TestHelpers, type: :controller

  config.include BzCore::AuthenticationHelper, type: :feature
  config.include BzCore::ClickOnHelper, type: :feature
  config.include BzCore::ExpectationHelper, type: :feature
  config.include BzCore::FeaturesHelper, type: :feature
  config.include BzCore::ModalHelper, type: :feature

  config.before :suite do
    FactoryGirl.reload
  end

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end

    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
