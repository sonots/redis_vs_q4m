redis_vs_q4m
============

benchmark to evaluate redis vs q4m as a queue engine

# RESULT

Benchmarking enqueue/dequeue 10,000 messages. 

|                         | enqueue (sec) | dequeue (sec) |
|-------------------------|---------------|---------------|
| q4m (--with-sync=yes)   | 1.886356      | 3.476402      |
| redis                   | 0.460380      | 0.271107      |
| redis(to_json)          | 0.573746      | 0.402243      |
| redis(persistence)      | 0.517071      | 0.310961      |

In throughputs (#/sec) form:

|                       | enqueue (#/sec) | dequeue (#/sec) |
|-----------------------|-----------------|-----------------|
| q4m (--with-sync=yes) | 5301            | 2876            |
| redis                 | 21721           | 36885           |
| redis(to_json)        | 17429           | 24860           |
| redis(persistence)    | 19339           | 32158           |

CONCLUSION: Redis won. But, please note that redis' rpop does not have rollback functionality. 

# Machine Spec

```
CPU Xeon E5-2670 2.60GHz x 2 (32 Cores)
Memory  24G
Disk    300G(10000rpm) x 2 [SAS-HDD]
OS CentOS release 6.2 (Final)
```

Q4M

```
q4m-0.9.13-1.mysql_5.6.20
```

Redis

```
redis-2.8.17
```

# conf

Q4M

* [my.cnf](q4m/my.cnf)

Redis

* [redis.conf](redis/redis.conf)
* [redis.aof.conf](redis/redis.aof.conf) for presistence

# ToDo

* benchmark in multithreads
  * redis is single thread, mysql (q4m) is multi thread. So, q4m would overcome redis
* create docker container or AMI to make it easy to rerun the benchmark
