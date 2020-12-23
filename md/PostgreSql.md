# 配置

## 配置优化

参考：	https://www.kancloud.cn/taobaomysql/monthly/140098

```
show max_connections;
允许客户端连接的最大数目

show shared_buffers;
PostgreSQL既使用自身的缓冲区，也使用内核缓冲IO。这意味着数据会在内存中存储两次，首先是存入PostgreSQL缓冲区，然后是内核缓冲区。这被称为双重缓冲区处理。对大多数操作系统来说，这个参数是最有效的用于调优的参数。此参数的作用是设置PostgreSQL中用于缓存的专用内存量。
shared_buffers的默认值设置得非常低，因为某些机器和操作系统不支持使用更高的值。但在大多数现代设备中，通常需要增大此参数的值才能获得最佳性能。
建议的设置值为机器总内存大小的25％，但是也可以根据实际情况尝试设置更低和更高的值。实际值取决于机器的具体配置和工作的数据量大小。举个例子，如果工作数据集可以很容易地放入内存中，那么可以增加shared_buffers的值来包含整个数据库，以便整个工作数据集可以保留在缓存中。
在生产环境中，将shared_buffers设置为较大的值通常可以提供非常好的性能，但应当时刻注意找到平衡点。

show wal_buffers;
PostgreSQL将其WAL（预写日志）记录写入缓冲区，然后将这些缓冲区刷新到磁盘。由wal_buffers定义的缓冲区的默认大小为16MB，但如果有大量并发连接的话，则设置为一个较高的值可以提供更好的性能。

show checkpoint_completion_target;
show checkpoint_timeout;
PostgreSQL将更改写入WAL。检查点进程将数据刷新到数据文件中。发生CHECKPOINT时完成此操作。这是一项开销很大的操作，整个过程涉及大量的磁盘读/写操作。用户可以在需要时随时发出CHECKPOINT指令，或者通过PostgreSQL的参数checkpoint_timeout和checkpoint_completion_target来自动完成。
checkpoint_timeout参数用于设置WAL检查点之间的时间。将此设置得太低会减少崩溃恢复时间，因为更多数据会写入磁盘，但由于每个检查点都会占用系统资源，因此也会损害性能。此参数只能在postgresql.conf文件中或在服务器命令行上设置。
checkpoint_completion_target指定检查点完成的目标，作为检查点之间总时间的一部分。默认值是 0.5。 这个参数只能在postgresql.conf文件中或在服务器命令行上设置。高频率的检查点可能会影响性能。

show fsync;
强制把数据同步更新到磁盘,如果系统的IO压力很大，把改参数改为off
在fsync打开的情况下，优化后性能能够提升30%左右。因为有部分优化选项在默认的SQL测试语句中没有体现出它的优势，如果到实际测试中，提升应该不止30%。
测试的过程中，主要的瓶颈就在系统的IO，如果需要减少IO的负荷，最直接的方法就是把fsync关闭，但是这样就会在掉电的情况下，可能会丢失部分数据。

show commit_delay;
事务提交后，日志写到wal log上到wal_buffer写入到磁盘的时间间隔。需要配合commit_sibling。能够一次写入多个事务，减少IO，提高性能

show commit_siblings;
设置触发commit_delay的并发事务数，根据并发事务多少来配置。减少IO，提高性能

show autovacuum_work_mem;

show effective_cache_size;
effective_cache_size提供可用于磁盘高速缓存的内存量的估计值。它只是一个建议值，而不是确切分配的内存或缓存大小。它不会实际分配内存，而是会告知优化器内核中可用的缓存量。在一个索引的代价估计中，更高的数值会使得索引扫描更可能被使用，更低的数值会使得顺序扫描更可能被使用。在设置这个参数时，还应该考虑PostgreSQL的共享缓冲区以及将被用于PostgreSQL数据文件的内核磁盘缓冲区。默认值是4GB。

show maintenance_work_mem;
maintenance_work_mem是用于维护任务的内存设置。默认值为64MB。设置较大的值对于VACUUM，RESTORE，CREATE INDEX，ADD FOREIGN KEY和ALTER TABLE等操作的性能提升效果显著。

show work_mem;
此配置用于复合排序。内存中的排序比溢出到磁盘的排序快得多，设置非常高的值可能会导致部署环境出现内存瓶颈，因为此参数是按用户排序操作。如果有多个用户尝试执行排序操作，则系统将为所有用户分配大小为work_mem *总排序操作数的空间。全局设置此参数可能会导致内存使用率过高，因此强烈建议在会话级别修改此参数值。默认值为4MB。

show synchronous_commit;
此参数的作用为在向客户端返回成功状态之前，强制提交等待WAL被写入磁盘。这是性能和可靠性之间的权衡。如果应用程序被设计为性能比可靠性更重要，那么关闭synchronous_commit。这意味着成功状态与保证写入磁盘之间会存在时间差。在服务器崩溃的情况下，即使客户端在提交时收到成功消息，数据也可能丢失。

vim postgresql.conf
    shared_buffers = 128MB | 4GB
    max_wal_size = 1GB | 4GB
```

```
max_connections = 300       # (change requires restart)
unix_socket_directories = '.'   # comma-separated list of directories
shared_buffers = 194GB       # 尽量用数据库管理内存，减少双重缓存，提高使用效率
huge_pages = on           # on, off, or try  ，使用大页
work_mem = 256MB # min 64kB  ， 减少外部文件排序的可能，提高效率
maintenance_work_mem = 2GB  # min 1MB  ， 加速建立索引
autovacuum_work_mem = 2GB   # min 1MB, or -1 to use maintenance_work_mem  ， 加速垃圾回收
dynamic_shared_memory_type = mmap      # the default is the first option
vacuum_cost_delay = 0      # 0-100 milliseconds   ， 垃圾回收不妥协，极限压力下，减少膨胀可能性
bgwriter_delay = 10ms       # 10-10000ms between rounds    ， 刷shared buffer脏页的进程调度间隔，尽量高频调度，减少用户进程申请不到内存而需要主动刷脏页的可能（导致RT升高）。
bgwriter_lru_maxpages = 1000   # 0-1000 max buffers written/round ,  一次最多刷多少脏页
bgwriter_lru_multiplier = 10.0          # 0-10.0 multipler on buffers scanned/round  一次扫描多少个块，上次刷出脏页数量的倍数
effective_io_concurrency = 2           # 1-1000; 0 disables prefetching ， 执行节点为bitmap heap scan时，预读的块数。从而
wal_level = minimal         # minimal, archive, hot_standby, or logical ， 如果现实环境，建议开启归档。
synchronous_commit = off    # synchronization level;    ， 异步提交
wal_sync_method = open_sync    # the default is the first option  ， 因为没有standby，所以写xlog选择一个支持O_DIRECT的fsync方法。
full_page_writes = off      # recover from partial page writes  ， 生产中，如果有增量备份和归档，可以关闭，提高性能。
wal_buffers = 1GB           # min 32kB, -1 sets based on shared_buffers  ，wal buffer大小，如果大量写wal buffer等待，则可以加大。
wal_writer_delay = 10ms         # 1-10000 milliseconds  wal buffer调度间隔，和bg writer delay类似。
commit_delay = 20           # range 0-100000, in microseconds  ，分组提交的等待时间
commit_siblings = 9        # range 1-1000  , 有多少个事务同时进入提交阶段时，就触发分组提交。
checkpoint_timeout = 55min  # range 30s-1h  时间控制的检查点间隔。
max_wal_size = 320GB    #   2个检查点之间最多允许产生多少个XLOG文件
checkpoint_completion_target = 0.99     # checkpoint target duration, 0.0 - 1.0  ，平滑调度间隔，假设上一个检查点到现在这个检查点之间产生了100个XLOG，则这次检查点需要在产生100*checkpoint_completion_target个XLOG文件的过程中完成。PG会根据这些值来调度平滑检查点。
random_page_cost = 1.0     # same scale as above  , 离散扫描的成本因子，本例使用的SSD IO能力足够好
effective_cache_size = 240GB  # 可用的OS CACHE
log_destination = 'csvlog'  # Valid values are combinations of
logging_collector = on          # Enable capturing of stderr and csvlog
log_truncate_on_rotation = on           # If on, an existing log file with the
update_process_title = off
track_activities = off
autovacuum = on    # Enable autovacuum subprocess?  'on'
autovacuum_max_workers = 4 # max number of autovacuum subprocesses    ，允许同时有多少个垃圾回收工作进程。
autovacuum_naptime = 6s  # time between autovacuum runs   ， 自动垃圾回收探测进程的唤醒间隔
autovacuum_vacuum_cost_delay = 0    # default vacuum cost delay for  ， 垃圾回收不妥协
```

```
其他优化总结：
    1、尽量减少费的IO请求，所以本文从块设备，到逻辑卷，到文件系统的块大小都尽量和数据库块大小靠齐；
    2、通过对齐，减少IO覆盖写；
    3、通过大页减少内存管理开销；
    4、通过多个客户端将数据库硬件资源充分利用起来；
    5、减少客户端输出日志的开销，降低客户端性能干扰；
    6、使用新的编译器，优化编译后的可执行程序质量。
```

# 语法

```
#查看版本
	pg_ctl -V
    template1=# \l 查看系统中现存的数据库
    template1=# \q 退出客户端程序psql
    template1=# \c 从一个数据库中转到另一个数据库中，如template1=# \c sales 从template1转到sales
    template1=# \dt 查看表
    template1=# \d 查看表结构
    template1=# \di 查看索引
```

```
登录数据库：psql -U user_name -d database_name -h serverhost -p port -W password
    -h 主机名
    -p 端口号
    -U 用户名
    -d 数据库
 	 示例：psql -h 127.0.0.1 -p 5432 -U postgre -d dev -W huitone2214
 	 注意： 实测密码不行，得配环境变量
        vim /etc/profile
        export PGPASSWORD="huitone2214"
        source /etc/profile
    
退出pg连接：\q
查看所有数据库：\l
切换数据库：\c database_name
查看当前数据库所有表：\d

执行sql(必须加;)：select * from xxx ;
查询时会出现把结果输出到more，可以重定向到/dev/stdout,命令：	\o /dev/stdout
示例：
    1、time psql -h 127.0.0.1 -p 5432 -U postgre -d dev   <<< "select * from tb_uc_task_sched_copy" > /dev/null
    2、psql -h 127.0.0.1 -p 5432 -U postgre -d dev
    \o /dev/null
    \timing on
    select * from tb_uc_task_sched_copy ;
```

```
删除schema（例如：public）：（删除数据库下所有表数据和表结构和存储过程等等） 
	DROP SCHEMA public CASCADE;

新建schema：
	create schema public;

授权：
	grant all on schema to user1; 
```

```
查看所有序列：
	select *  from pg_class where relkind='S' ;（r =普通表， i =索引，S =序列，v =视图，m =物化视图， c =复合类型，t = TOAST表，f =外部表）

查看当前序列的值：
	select currval('table_id_seq')

查看下一个序列：
	select nextval('table_id_seq')

设置序列：
	select setval('table_id_seq',1,false)

创建序列：
    CREATE SEQUENCE public.user_id_seq
        INCREMENT 1
        START 1
        MINVALUE 1
        MAXVALUE 99999999
        CACHE 1;

赋予权限：ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

给主键设备序列：alter table public.user alter column id set default nextval('public.user_id_seq');

修改序列初始值：alter sequence public.user_id_seq restart with 7;
```

```
查询所有的数据库：
	select * from pg_database;
查询指定名字的数据库：
	select * from pg_database where datname='myDB'; 
查询所有表信息：
	select * from pg_tables;
查询指定数据表信息：
    select * from pg_tables where schemaname='public';
    select * from pg_tables where tablename='myTableName';
查询指定表结构（包含字段名称，字段类型，是否可空等）：
	SELECT 
        col_description(a.attrelid,a.attnum) as comment,
        format_type(a.atttypid,a.atttypmod) as type,
        a.attname as name,
        a.attnotnull as notnull
	FROM pg_class as c,pg_attribute as a
	where c.relname ='myTableName' and a.attrelid = c.oid and a.attnum>0;
```

## insert

```
参考：	https://www.yiibai.com/postgresql/postgresql-insert.html
INSERT INTO TABLE_NAME (column1, column2, column3,...columnN)  
VALUES (value1, value2, value3,...valueN);
```

## update

```
UPDATE table_name  
SET column1 = value1, column2 = value2...., columnN = valueN  
WHERE [condition];
```

## Update 根据B表更新A表

```
参考：	https://www.cnblogs.com/xuenb/p/8385973.html
```

## merge

```
参考：	https://blog.csdn.net/qq_43303221/article/details/84951300
WITH upsert AS (
		UPDATE test1
		SET col1 = test2.col1
		FROM test2
		WHERE test1.id = test2.id
		RETURNING test1.*
	)
INSERT INTO test01
SELECT *
FROM test2
WHERE NOT EXISTS (
	SELECT 1
	FROM upsert b
	WHERE test2.id = b.id
);

示例：
drop table if exists test1;
create table test1(
	id int,
	name varchar(20)
);
insert into test1 values (1,'a');
insert into test1 values (2,'b');
insert into test1 values (3,'c');
insert into test1 values (4,'d');
insert into test1 values (5,'e');

drop table if exists test2;
create table test2(
	id int,
	name varchar(20)
);
insert into test2 values (1,'001');
insert into test2 values (2,'002');
insert into test2 values (3,'003');
insert into test2 values (6,'006');
insert into test2 values (7,'007');

select * from test1 order by id
select * from test2

WITH upsert AS (
		UPDATE test1 a
		SET name = b.name
		FROM test2 b
		WHERE a.id = b.id
		RETURNING a.*
	)
INSERT INTO test1
SELECT *
FROM test2 c
WHERE NOT EXISTS (
	SELECT 1
	FROM upsert d
	WHERE c.id = d.id
)
```

