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
  x.report("redis.lpop (save)      ") { num.times { redis.lpop "queue"; redis.save } }
end
# puts redis.llen "queue"
redis.del "queue"

# sudo bundle exec ruby dequeue.rb
#        user     system      total        real
# redis.lpop (json parse)  0.240000   0.080000   0.320000 (  0.365112)
# redis.lpop               0.140000   0.090000   0.230000 (  0.271107)
# redis.lpop (save)        0.530000   0.210000   0.740000 ( 17.966775)
