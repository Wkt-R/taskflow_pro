redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

$redis = Redis.new(url: redis_url)

begin
  $redis.ping
  Rails.logger.info "Redis connected successfully"
rescue => e
  Rails.logger.error "Redis connection failed: #{e.message}"
end
