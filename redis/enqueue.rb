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
  x.report("redis.rpush (save)   ") { num.times {|i| redis.rpush "queue", data.merge(created_at: Time.now).to_json; redis.save } }
  x.report("redis.rpush (to_json)") { num.times {|i| redis.rpush "queue", data.merge(created_at: Time.now).to_json } }
  x.report("redis.rpush          ") { num.times {|i| redis.rpush "queue", '{"nickname":"sonots","email":"sonots@gmail.com","created_at":"' + Time.now.iso8601 + '"}' }}
end
redis.del "queue"

# sudo bundle exec ruby enqueue.rb
#        user     system      total        real
# redis.rpush (save)     0.440000   0.120000   0.560000 (  0.625842)
# redis.rpush (to_json)  0.480000   0.130000   0.610000 (  0.720960)
# redis.rpush            0.340000   0.120000   0.460000 (  0.515319)
