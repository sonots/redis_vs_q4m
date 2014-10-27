require 'benchmark'
num = (ARGV[0] || 10000).to_i

require 'mysql2'

client = Mysql2::Client.new(username: 'root', database: 'test', socket: '/dev/shm/mysql.sock')
data = {nickname: 'sonots', email: 'sonots@gmail.com'}

Benchmark.bm do |x|
  x.report("q4m.insert") { num.times {|i|
    client.query("INSERT INTO welcome (nickname,email,created_on) VALUES ('#{data[:nickname]}','#{data[:email]}',UNIX_TIMESTAMP())")
  }}
end
client.query("DELETE FROM welcome")

# bundle exec ruby enqueue.rb
#        user     system      total        real
# q4m.insert  0.240000   0.110000   0.350000 (  1.886356)
