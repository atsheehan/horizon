redis_url = ""
if Rails.env.test? || Rails.env.development?
  redis_url = "redis://localhost:6379"
else
  redis_url = ENV["REDISTOGO_URL"]
end

uri = URI.parse(redis_url)
Redis.current = Redis.new(host: uri.host, port: uri.port, password: uri.password)
