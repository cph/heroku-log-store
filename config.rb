require "bundler/setup"
Bundler.require

STDOUT.sync = true

require "./config_sequel"

Airbrake.configure do |config|
  config.project_id = 224
  config.project_key = "5034c8a70019058e42c21b9ce43c3e10"
  config.host = "https://errbit.cphepdev.com:443"
  config.environment = ENV.fetch("RACK_ENV") { "development" }
  config.ignore_environments = %i{development test}
end
