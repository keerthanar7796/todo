config = YAML::load_file(File.join(Rails.root,'config','sidekiq.yml'))[Rails.env]
sidekiq_config = YAML::load_file(File.join(Rails.root, 'config', 'sidekiq_client.yml'))[Rails.env]

$sidekiq_conn = Redis.new(:host => config["host"], :port => config["port"])
$sidekiq_datastore = proc { Redis::Namespace.new(config["namespace"], :redis => $sidekiq_conn) }
$sidekiq_redis_pool_size = sidekiq_config[:concurrency]
$sidekiq_redis_timeout = sidekiq_config[:timeout]

Sidekiq.configure_server do |config|
	config.redis = ConnectionPool.new(size: 1, timeout: $sidekiq_redis_timeout, &$sidekiq_datastore)
end

Sidekiq.configure_client do |config|
	config.redis = ConnectionPool.new(size: @sidekiq_redis_pool_size, timeout: $sidekiq_redis_timeout, &$sidekiq_datastore)
end