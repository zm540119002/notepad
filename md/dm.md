# 语法

```
创建用户、授权
	使用 SYSDBA 账户 登录达梦，默认密码：SYSDBA 或者  SYSDBA123
命令：
    CREATE USER USER_NAME;      ---创建用户
    GRANT DBA TO USER_NAME;    ---授予DBA角色

修改用户密码命令：
	ALTER USER USER_NAME IDENTIFIED  BY “用户口令”;   ---设置密码
```

## 常用sql

```
授权：
	GRANT CREATE TABLE TO test;
撤销权限:
	REVOKE CREATE TABLE from test;
创建角色：
	create role r1;
删除角色：
	drop role R1;
角色授权：
	grant create table to r1;
角色授权用户：
	grant r1 to test;
查看角色有什么权限：
	select * from SYS.DBA_SYS_PRIVS WHere DBA_SYS_PRIVS.GRANTEE=‘R1’;
查看用户有什么权限,属于哪个角色：
	select * from SYS.DBA_ROLE_PRIVS WHere GRANTEE=‘TEST’;
修改密码：
	alter USER TEST IDENTIFIED BY “dm12345678”;
锁定和解锁：
	alter USER TEST ACCOUNT LOCK;
	alter USER TEST ACCOUNT UNLOCK;
删除用户：
	drop user test;
启用和禁用角色：
	sp_set_role(‘R1’,0); //启用
	sp_set_role(‘R1’,1); //禁用
	
内存池视图：
	SELECT * FROM V$MEM_POOL
	
获取锁和查会话的语句：
    select * from v$lock;
    select *from V$SESSIONS;
    select * from TB_UA_SYS_HOST;

    SP_CLOSE_SESSION(281467326370320);
    SP_CLOSE_SESSION(281466386846224);
```



# 概念

```

```

## 表空间

```
（一）表空间管理
    数据库的物理结构：文件系统–数据文件
    数据库的逻辑结构：数据库–表空间–段--簇–页
    注意：（一个表空间只属于一个数据库，表空间有多个文件，一个表空间有多个段，一个段有多个簇，一个簇有多个连续页）
    
查询默认的表空间
	select TABLESPACE_NAME from SYS.DBA_TABLESPACES;
	
在创建 DM 数据库时，会自动创建 5 个默认的表空间：
    1、　SYSTEM 系统表空间,存放数据字典信息，用户不能在 SYSTEM 表空间创建表和索引。
    2、　ROLL 回滚表空间,存放的回滚数据,支持MVCC(事务多版本机制)。完全由 DM 数据库自动维护，用户无需干预。
    3、　TEMP 临时表空间,存在临时数据，完全由 DM 数据库自动维护。当用户的 SQL 语句需要磁盘空间来完成某个操作时，DM 数据库会从 TEMP 表空间分配临时段。
    	如创建索引、无法在内存中完成的排序操作、SQL 语句中间结果集以及用户创建的临时表等都会使用到 TEMP表空间。
    4、　MAIN main表空间,如果用户创建数据库对象时不指定表空间,则会默认存放在main中
    5、　HMAIN 表空间属于 HTS 表空间，完全由 DM 数据库自动维护，用户无需干涉。当用户在创建 HUGE 表时，未指定 HTS 表空间的情况下，充当默认 HTS 表空间。

SYSTEM、ROLL、MAIN 和 TEMP 表空间查看语句：
	SELECT * FROM V$TABLESPACE;
HMAIN 表空间查看语句：
	SELECT * FROM V$HUGE_TABLESPACE;

DM8 中存储的层次结构如下：
    1. 数据库由一个或多个表空间组成；
    2. 每个表空间由一个或多个数据文件组成；
    3. 每个数据文件由一个或多个簇组成；
    4. 段是簇的上级逻辑单元，一个段可以跨多个数据文件；
    5. 簇由磁盘上连续的页组成，一个簇总是在一个数据文件中；
    6. 页是数据库中最小的分配单元，也是数据库中使用的最小的 IO 单元。 
```

## 用户

```

```

## 模式

```
版本：
	select * from SYS."V$VERSION";
默认用户：
	select DBA_USERS.USERNAME from SYS.DBA_USERS;

    ① SYS 内置管理账户,不能登录数据库
    ② SYSDBA 管理员
    ③ SYSAUDITOR 审计员
    ④ SYSSSO 安全员(安全版特性)
    注意:创建用户的时候会生成与用户名同名的模式,如果创建的用户模式名已经存在,用户无法创建.
```



# 日志

```
select * from v$dm_ini where para_name ='SVR_LOG';
-- 开启日志
alter system set 'SVR_LOG' = 1;
-- 关闭日志
alter system set 'SVR_LOG' = 0;
注： 执行会提示失败，但其实已经成功了。

-- 启用日志
sp_set_para_value(1,'svr_log',1);
-- 关闭日志
sp_set_para_value(1,'svr_log',0);

用户在 dm.ini中配置 SVR_LOG和 SVR_LOG_SWITCH_COUNT参数后就会打开跟踪日志。跟踪日志文件是一个纯文本文件，以“dm_commit_日期_时间”命名，默认生成在 DM安装目录的 log子目录下面，管理员可通过 ini参数 SVR_LOG_FILE_PATH设置其生成路径。

跟踪日志内容包含系统各会话执行的 SQL语句、参数信息、错误信息等。跟踪日志主要用于分析错误和分析性能问题，基于跟踪日志可以对系统运行状态有一个分析，比如，可以挑出系统现在执行速度较慢的 SQL语句，进而对其进行优化。

系统中 SQL日志的缓存是分块循环使用，管理员可根据系统执行的语句情况及压力情况设置恰当的日志缓存块大小及预留的缓冲块个数。当预留块不足以记录系统产生的任务时，系统会分配新的用后即弃的缓存块，但是总的空间大小由 ini 参数SVR_LOG_BUF_TOTAL_SIZE控制，管理员可根据实际情况进行设置。

打开跟踪日志会对系统的性能会有较大影响，一般用于查错和调优的时候才会打开，默认情况下系统是关闭跟踪日志的。若需要跟踪日志但对日志的实时性没有严格的要求，又希望系统有较高的效率，可以设置参数SQL_TRACE_MASK和SVR_LOG_MIN_EXEC_TIME 只记录关注的相关记录，减少日志总量;设置参数 SVR_LOG_ASYNC_FLUSH打开 SQL日志异步刷盘提高系统性能。
```



# 注意事项

## 扩展

```
达梦扩展需配置linux环境变量
    vim /etc/profile
    export LD_LIBRARY_PATH=/data/home/dmdbms/bin
	注意：有些系统LD_LIBRARY_PATH参数无效，得把达梦dmdbms/bin目录下的so copy到 /usr/bin目录下：cp -pi dmdbms/bin/*so /usr/bin
```

