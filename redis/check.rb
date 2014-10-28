require 'hiredis'
require 'redis'

redis = Redis.new(driver: :hiredis, path: '/dev/shm/redis.sock')
puts redis.llen "queue"
