require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require 'rails/application'
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  require_relative '../config/environment'
  require 'rspec/rails'

  Dir[Rails.root.join('spec/support/**/*.rb')].each{|f| require f}

  RSpec.configure do |config|
    config.before :suite do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with :truncation
    end

    config.before do
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end

    config.include FactoryGirl::Syntax::Methods
    config.mock_with :rspec
    config.fixture_path = "#{Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run :focus
    config.order = :random
  end

  require 'capybara/rspec'
  require 'capybara/rails'
end

Spork.each_run do
  FactoryGirl.reload
end
