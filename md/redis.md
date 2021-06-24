# 常用

## 参考

```
https://www.runoob.com/redis/connection-select.html
```

## 基本设置

```
daemonize 如果需要将Redis服务以守护进程在后台运行，则把该项的值改为yes
pidfile 配置多个pid的地址，默认在/var/run/redis/pid
bind 绑定ip，设置后只接受来自该ip的请求
port 监听端口，默认是6379
timeout 客户端连接超时的设定，单位是秒
loglevel 分为4级，debug、verbose、notice、warning
logfile 配置log文件地址
databases 设置数据库的个数，默认使用的数据库为0
save 设置redis进行数据库镜像的频率
rdbcompression 在进行镜像备份时，是否进行压缩
Dbfilename 镜像备份文件的文件名
Dir 数据库镜像备份文件的存放路径
Slaveof 设置数据库为其他数据库的从数据库
Masterauth 主数据库连接需要的密码验证
Requirepass 设置登录时，需要使用的密码
Maxclients 设置同时连接的最大客户端数量
Maxmemory 设置redis能够使用的最大内存
Appendonly 开启append only模式
Appendfsync 设置对appendonly.aof文件同步的频率
```



## 服务器

```
redis服务启动：redis-server /myredis/redis.conf
    –>指定redis配置文件路径；
    –>在/usr/local/bin路径下有redis-server命令；
    否则，就只能去redis安装路径的src路径下执行命令；
    可以手动将src下的redis-server命令复制到/usr/local/bin路径下，并使用“chmod u+x redis-*”命令修改权限；
    
redis服务关闭：redis-cli -p 6379 shutdown
远程连接redis：redis-cli -h host -p port -a password
查看redis线程：ps aux | grep redis
查看主从关系：info replication
设置成为从节点：slaveof 127.0.0.1 6379
取消从节点身份：slaveof no one
查看当前的redis连接数：info clients
查看 redis允许的最大连接数：config get maxclients

```

## 客户端

```
redis-cli -h host -p port -a password
示例：
	redis-cli
	redis-cli -h 172.16.7.57 -p 26379 -a 123456
```

### 创建密码或者修改密码

```
1.进入redis的容器 docker exec -it 容器ID bash
2.进入redis目录 cd /usr/local/bin 
3.运行命令：redis-cli
4.查看现有的redis密码：config get requirepass
5.设置redis密码config set requirepass 123456（123456为你要设置的密码）
6.若出现(error) NOAUTH Authentication required.错误，则使用 auth 密码 来认证密码
```



## 命令

```
ping 
select index //备注：index为(0-15)
keys '*'

redis的连接：
    1、redis-cli 连接本地redis
    2、redis-cli -p<port>  连接指定端口的redis
    3、redis-cli -h 192.168.1.1  连接远端或本地redis

查看所有key：key *
查询内容：get 或smembers  后加对应key值

key的添加删除：
    SADD添加；
    DEL删除；

切库：
	redis有16个库，分别为0-15，默认为0库，可以通过select 1切到1库；其他同理；

批量删除：redis自身不带批量删除命令，可以通过linux的xargs实现如：
	redis-cli -h 192.168.1.1 KEYS ‘模糊匹配key的字符串’| xargs redis-cli -h 192.168.1.1 DEL

批量删除指定库（非0库）的key：
	redis-cli -h 192.168.1.1 -n 1 KEYS '模糊匹配key的字符串'| xargs redis-cli -h -n 1 192.168.1.1 DEL 6
	
全量删除当前库中的所有key：
	flushdb

全量删除所有库（0-15）中的所有key：
	flushall

redis针对key值的一下操作:
    1. 删除key         ---           DEL 'mykey'                                      
    2. 序列化给定的key    ----    DUMP 'ke'
    3. 判断给定的key是否存在   ---   EXISTS 'key'
    4. 给一个key设定过期时间   ---   EXPIRE 'key'  1
    5. 匹配key查询                    ---    KEYS '*'
    6. 将当前数据库的key移动到数据库db中   ---  MOVE 'key'  db
    7. 返回给定key剩余的过期时间   ---    PTTL 'key'
    8. 返回给定key的剩余生存时间   ---    TTL 'key'
    9. 从数据库随机返回一个key      ----    RANDOMKEY
    10. 修改key的名称                      -----   RENAMENX key newkey
    11. 查看key 所存储的数值类型    -----   TYPE key
    12. 持久化key                             -----     PERSIST key

redis 是以key-value的形式存储的(内存),value可以是String, List, Hash,Set

String操作:
    1. 设定key的值 （可覆盖）     ----    SET key mydata
    2. 获取key的值                        ----    GET key
    3. 获取key值中0-2的字符串    ----    GETRANGE key 0 2
    4. 获取当前值并且设置新的值 ----    GETSET key newdata
    5. 获取多个可以值                   ----    MGET key key2
    6. 设定key的值并且设定过期时间    ----   SETEX 23 key ddd
    7. 设定key的值，只有在key不存在时  ----  SETNX key1  dsfsdf
    8. 返回key存储字符串的长度               ----  STRLEN key
    9. 同时设定多个值                              ----   MSET key dsd key5 sdfs
    10. 给key数值(值为整型)加一/减一    ----  NCR key/DECR key
    11. 给key数值(值为整型)减去给定的值   ---   DECRBY key 2
    12. 在原有的key值(值为字符串)上添加字符串  ---  APPEND key eee

Hash操作:
    1. 设定 key  a:10, b: wujq       ---     HMSET key a 10 b wujq
    2. 删除key 中 a                       ---     HDEL key a
    3. 获取 key的值                      ---      HGETALL key
    4. 获取key 中a的值                ---      HGET key a
    5. key值中a是否存在             ---      HEXISTS key a
    6. 删除key的值                      ---      DEL key
    7. 获取key所有的key             ---      HKEYS key
    8. 获取key所有的value          ---      HVALS  key
    9. 设置key中a的值                 ---      HSET key a 13
    10. a自增1                             ---      HINCRBY key a 1

队列操作:
    插入有两种
       1. 从头部插入 LPUSH
       2.从尾部插入  RPUSH

    1. 遍历所有的值        ---     LRANGE KEY 0 -1
    2. 移除出列表(第一个/最后一个)并获取这个值:
        BLPOP key[key1] timeout (没有元素会阻塞直到timeout)
        BRPOP key[key1] timeout (没有元素会阻塞直到timeout)
    3.移除出第一个元素并获取     ---   LPOP key
    4. 移除出最后一个元素并获取   ---  RPOP key
    5.获取列表长度                         ---   LLEN key
    6.移除列表多个相同value的纪录(从头开始)    ---   LREM key count value
    7.保留一定范围内的数据其它的都删除:数据修剪    ---   LTRIM key start_index stop_index
    8. 弹出列表a最后一个元素，添加到另一个b列表中去,并返回这个值   ---  RPOPLPUSH source destination
    9.通过索引获取列表中的值                 ---   LINDEX key index
    10. 通过索引设置列表中的值              ---   LSET key index value
    11.向已存的列表追加值                       ---   RPUSHX key value

Set集合操作:  集合是无序集合， 成员是唯一的
    1.添加集合     ---   SADD  key redis[...]
    2.获取集合数据    ---    SMEMBERS  key
    3.返回两个集合的差集    ---  SDIFF  key1 [key2]
    4.返回两个集合的交集    ----   SINTER  key1 [key2]
    5.判断集合是否包含a     ----  SISMEMBER key a
    6.移除集合中一个随机元素并返回   ---  SPOP key
    7.返回集合中多个随机数          ---   SRANDOMMEMBER key count
    8. 移除指定的多个成员             ---    SREM key mem1 mem2
    9.两个集合并集                        ---    SUNION key1 key2
    10.两个集合并集存储到新的集合中      ---   SUNIONSTORE destination key1 key2
    11.获取集合大小                                  ---   SCARD yu
    12.匹配迭代一个集合                          ----   SSCAN key cursor [MATCH pattern] [COUNT count]                                                            eg: SSCAN key 0 match h*

还提供有序的Set集合

发布订阅模式:
发布:
    PUBLISH channel  "dsdsf"
订阅:
	SUBSCRIBE  channel  就可以接收消息

为redis设置密码:
    CONFIG get requirepass     查看 
    CONFIG set requirepass "123456"
    redis认证: AUTH  123456
```

