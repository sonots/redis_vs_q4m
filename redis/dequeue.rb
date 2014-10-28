require 'benchmark'
num = (ARGV[0] || 10000).to_i

require 'hiredis'
require 'redis'
require 'json'
require 'time'

redis = Redis.new(driver: :hiredis, path: '/dev/shm/redis.sock')
# Redis.new(driver: :hiredis, :host => "10.0.1.1", :port => 6380, :db => 15)
data = {nickname: 'sonots', email: 'sonots@gmail.com'}
redis.del "queue"
(num * 3).times {|i| redis.rpush "queue", data.merge(created_at: Time.now).to_json }

Benchmark.bm do |x|
  x.report("redis.lpop (json parse)") { num.times { JSON.parse(redis.lpop "queue") } }
  x.report("redis.lpop             ") { num.times { redis.lpop "queue" } }
  # x.report("redis.lpop (save)      ") { num.times { redis.lpop "queue"; redis.save } }
end
# puts redis.llen "queue"
redis.del "queue"

# sudo bundle exec ruby dequeue.rb
#
# redis.conf
#        user     system      total        real
# redis.lpop (json parse)  0.250000   0.100000   0.350000 (  0.402243)
# redis.lpop               0.160000   0.070000   0.230000 (  0.274294)
#
# redis.aof.conf
#        user     system      total        real
# redis.lpop (json parse)  0.240000   0.090000   0.330000 (  0.410211)
# redis.lpop               0.170000   0.050000   0.220000 (  0.310961)
