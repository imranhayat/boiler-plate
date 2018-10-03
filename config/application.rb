require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)
module Freelance
  class Application < Rails::Application
    config.load_defaults 5.1
    config.app_generators.scaffold_controller = :scaffold_controller
    config.time_zone = "Asia/Karachi"
    config.active_record.default_timezone = :local
    config.generators do |g|
      g.assets  false
      g.helper  false
      g.test_framework  nil
      g.jbuilder  false
      g.decorator false
    end
  end
end
