require 'benchmark'
num = (ARGV[0] || 10000).to_i

require 'mysql2'

client = Mysql2::Client.new(username: 'root', database: 'test', socket: '/dev/shm/mysql.sock')
data = {nickname: 'sonots', email: 'sonots@gmail.com'}
num.times { client.query("INSERT INTO welcome (nickname,email,created_on) VALUES ('#{data[:nickname]}','#{data[:email]}',UNIX_TIMESTAMP())") }

Benchmark.bm do |x|
  x.report("q4m.dequeue") { num.times {
    client.query("select queue_wait('welcome')")
    client.query("select * from welcome")
    client.query("select queue_end()")
  }}
end
client.query("DELETE FROM welcome")

# bundle exec ruby dequeue.rb
#        user     system      total        real
# q4m.dequeue  0.840000   0.400000   1.240000 (  3.476402)
