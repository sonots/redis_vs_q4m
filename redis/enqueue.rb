require 'benchmark'
num = (ARGV[0] || 10000).to_i

require 'hiredis'
require 'redis'
require 'json'
require 'time'

redis = Redis.new(driver: :hiredis, path: '/dev/shm/redis.sock')
# Redis.new(driver: :hiredis, :host => "10.0.1.1", :port => 6380, :db => 15)
data = {nickname: 'sonots', email: 'sonots@gmail.com'}

Benchmark.bm do |x|
  # x.report("redis.rpush (save)   ") { num.times {|i| redis.rpush "queue", data.merge(created_at: Time.now).to_json; redis.save } }
  x.report("redis.rpush (to_json)") { num.times {|i| redis.rpush "queue", data.merge(created_at: Time.now).to_json } }
  x.report("redis.rpush          ") { num.times {|i| redis.rpush "queue", '{"nickname":"sonots","email":"sonots@gmail.com","created_at":"' + Time.now.iso8601 + '"}' }}
end
# redis.del "queue"

# redis.conf
#        user     system      total        real
# redis.rpush (to_json)  0.410000   0.120000   0.530000 (  0.573746)
# redis.rpush            0.320000   0.100000   0.420000 (  0.460380)

# redis.aof.conf
#        user     system      total        real
# redis.rpush (to_json)  0.430000   0.110000   0.540000 (  0.634829)
# redis.rpush            0.320000   0.110000   0.430000 (  0.517071)
