# Sidekiq.configure_server do |config|
#   config.redis = { url: 'redis://redis.example.com:7372/0' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: 'redis://redis.example.com:7372/0' }
# end
# Sidekiq.configure_server do |config|
#   config.redis = {
#     url: 'rediss://red-xxx:xxx@ohio-redis.render.com:6379'
#   }
# end

# Sidekiq.configure_client do |config|
#   config.redis = {
#     url: 'rediss://red-xxx:xxx@ohio-redis.render.com:6379'
#   }
# end
Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] }
end
require 'sidekiq'
require 'sidekiq-cron'

# Sidekiq.configure_server do |config|
#   config.on(:startup) do
#     Sidekiq.schedule = YAML.load_file(File.expand_path('config/sidekiq_cron.yml', __dir__))
#     Sidekiq::Cron::Job.load_from_hash(Sidekiq.schedule)
#   end
# end

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

schedule_file = "config/sidekiq_cron.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
