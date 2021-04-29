# 注意

## 死锁问题排查

```
参考：https://blog.csdn.net/guanfengliang1988/article/details/80356648
```

总结：

```
不应该存在仅根据非主键的几个字段一查就要update/delete的场景。即使有，也应该改为先把要更新的记录查出来然后逐条按主键id更新。
```

# 知识点

## mysql锁

```
表级锁：锁住整张表
行级锁：锁住一行或者多行
ps: 如果数据库表没有加索引，那么更新操作的时候会锁住整张表，也就是所谓的表级锁；如果有索引，并且查询条件中也带有这些字段，那么就会使用行级锁。行级锁并不是锁记录，而是锁索引。
```

# 常见问题

## ONLY_FULL_GROUP_BY

```
SELECT @@GLOBAL.sql_mode ：			ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
SELECT @@SESSION.sql_mode ：
ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION

set @@GLOBAL.sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
set @@SESSION.sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

或者： 
    vim /etc/my.cnf
添加：  	


sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

# 概念解析

## innodb锁机制

```
1.在表中必须要有一个主键，如果一张表中没有主键的话,非常建议添加一个主键.添加主键以后再数据插入的时候
不会将所有的行都锁定.大大提高数据插入效率.

2.选择在where字段添加索引的原因是因为不添加索引的话会将所有的字段都锁住
在数据库中对表进行update的操作时.一般需要将update语句中where条件后面的字段添加
一个索引为了减少innodb锁的情况,一般情况要在where条件后面的字段添加一个索引.否
则会出现全表锁,添加了索引以后会将制定的条件对应的行进行锁定.

3.间隙锁
间隙锁,如果在进行表修改或数据插入的时候出现范围操作的话.例如>= and<
这样的范围修改或插入的话,会出现区间批量枷锁.符合前者插入条件的所有条目
都会被锁住.这种锁成为间隙锁,也叫 gap,锁定范围是 >3 and <6 那么范围
就是3-6都会锁定.如果data_locks里面直接出现了gap的话那就是gap锁.
如果出现row相关的话可以理解成行级锁.例如两次update冲突就是行级锁.
如果第一个update第二个insert的话会出现gap锁

4.自增锁
自增锁,参数 innodb_autoinc_lock_	mode当插入一个事务的时候必须要等到
前一个事务的插入完成后才可以进行插入.例如auto_increment这样的自增列自
己加的锁操作,
 
5.查看事务的隔离级别:
	show variables like "%transaction_isolation%";进行查询事务的隔离级别.具体的values级别可以自己查一下.
 	并发度最高的是 
        1.read-uncommitted.  #只有读不加锁,没有间隔锁
        2.read-committed   #没有间隔锁.提交后读跟3差不多
        3.repeatable read   #会有间隔锁.可重复读
        4.serializable  #并发度最低 隔离级别最高.
 
Repeatable read（可重复读）
该级别保证了在同一个事务中多次读取同样的记录结果是一致的，解决了脏读问题，
但存在幻读问题。这是 MySQL 的默认隔离级别。(本链接开启一个事务,然后查询
某张表中的某个数据.然后再其他连接中再将这张表中的数据进行修改.此时返回
原事务中进行查看,发现数据依旧没有改变.还是原来的,未经过修改之前的数据.)
 
Read committed（提交读）
一个事务开始的时候，只能“看见”已经提交的事务所做的修改。即一个事务从开始直到提交
之前，所做的任何修改对其他事务都是不可见的。有些时候也成为不可重复读，因为执行两
次同样的查询，可能会得到不一样的结果。这是大多数的数据库默认的隔离级别。(只能看
到已经提交过的事务.只要其他连接中的事务已经做了提交,那么即是再原连接中开启事务
查询信息,同一个事务前后两次查到的数据也不一样,原事务中将另一个链接提交的事务也一
并纳入可查看内容中.)
对于间隔锁的处理:
        如果两个连接都开启read-committed的话,那么在第一个连接中事务被锁定的话
   第二个连接中还是可以插入间隔锁中看似被锁定的数据,id <=1 and id <=3 如果是 
   REPEATABLE-READ的隔离级别的话是无法插入数据的.但是read-committed是可以的.
   默认是将gap锁取消掉.如果提高并发的话可以使用这种隔离级别
 
 
Read uncommitted（未提交读）
事务中的修改，即使没有提交，对其他事务也都是可以见的。事务可以读取未提交的数据，
这也被称为脏读。这个级别会有一堆问题，基本不会在实战中使用。(开启一个事务,然后
查询某张表的内容,然后重新创建一个新连接,再开启一个事务,并且不设置自动提交,修改同
一张表中的数据,然后返回原链接再次查看数据,发现可以查看到另一个链接中未提交的事务
中修改的数据.)
 
Serializable（可串行化）
这是数据库最高的隔离级别，通过强制事务串行执行，避免了幻读的问题。会对所有的读操
作添加一个select ....lock in share mode.默认就会添加一个共享锁, 简单来说，
Serializable 会在读取的每一行数据上都加锁，所以可能导致大量的超时和锁争用的问题
，实际应用中很少使用这个隔离级别。(只要读就枷锁,只有事务读完解锁后其他的事务才可
以读或者写.)一般不会设置这样的隔离级别.添加共享锁不允许插入数据.但是可以查询数据.
修改事务的隔离级别:
设置当前会话的事务隔离级别;
set session transaction isolation level read committed;
或者
set transaction_isolation = "read-committed";
 
6.执行ddl语句的时候会隐含的将上一个事务提交一次.因为ddl语句只能是一个独立的事务.
这时候如果开启一个事务,没用手动提交的话,那么数据修改后出现create等ddl语句,那么
都会将上一个事务隐含提交.那么在其他链接中间就会查到相应的数据信息.

7.共享锁与共享锁之间是没有排斥关系的. lock in share mode
例如select 和select 是不会排斥的.但是select 添加共享锁的话那么再进行alter insert
的话就会出现锁等待.

8.读取数据添加排它锁: select * from temp for update 会将表中所有的数据行添加一个排它锁;
那么在进行数据查询的时候,如果查询有共享锁那么就会出现所等待.解除所等待就是在之前的
连接中执行 commit 或者 rollback.
后续分析慢日志的时候会有所等待时间和语句执行时间.
 
9.在命令行给某张表设置只读.
lock table temp read;
解锁:
    unlock table;
共享写锁一般不用.会导致所有操作都不可执行.
读操作添加锁的场景
如果要修改外键表中的某条数据,那么可以为防止其他连接在数据修改的过程中出现异常.
例如第一次查询成功,但是要修改的时候却已经被其他连接提前修改,或者删除.那么可以再
自己修改前提前加一个所,这个枷锁类似于开启一个手动的事务.
select * from temp lock in share mode,或者select * from temp for update ,
那么当前查询成功的数据就不会被其他连接修改.当自己增删改查完成以后手动提交一下事务.
commit.即可解除共享锁或者排它锁.
 
10.如果要将某张表设置成临时只读. 那么可以将这张表添加临时锁.
lock table A1 read;
一种极端现象.如果某张表被设置成 lock table A1 read;将表设置成只读.那么在后续
的插入过冲中数据是插入不进去的,并且不会出现超时的情况,会一直出现卡主,等待,那么这
时候需要查看`performance_schema`.events_statements_current 这张表中有关A1表
的记录是什么,有种情况是遇到了只读锁表.
如果使用
lock table A1 write;
这种更极端的现象是将表完全锁定.读写操作都是不允许的.闲得蛋疼才会用这个.
死锁:
大概意思就是两个连接分别都在对方事务未结束的情况下修改对方修改的数据,
第一次修改连接1:id=1
然后修改连接2:id=2
事务未提交,
连接2修改id = 1;
然后连接1 要修改id=2 的时候就会出现死锁 
deadlock
默认情况下innodb死锁处理功能是开启的.
innodb_deadlock_detect参数是否开启.如果开启的话就会在遇到死锁的时候牺牲一个
事务然后将死锁解开.会将代价最小的事务牺牲掉将死锁解开.一般都是处理数据少的被杀处理掉.
如果出现死锁的话,那么事后可以通过show engine innodb status;查看最近一次发生的
死锁是那两条语句造成的.
如果要记录所有的死锁的话,那么需要修改系统环境变量,
innodb_print_all_deadlocks = 1 即可在mysql错误日志中查看到相应的死锁信息.
日志文件查看环境变量或者查看系统进程都可以.
推荐要看的:
https://www.cnblogs.com/dogtwo0214/p/10472405.html

11.如何规避死锁?
尽可能保持事务小型化,减少食物执行的时间可以减少发生影响的概率.
及时执行commit,或者rollback,来快的释放锁.
可以选用较低的合理级别,比如如果要使用selet...for update和 select ..lock in share mode 
使用uncommitted级别.一半不太使用.
增加合适的索引,然后就会出现锁定对应的行数据,如果对应字段没有索引,那么会将所有的行全部锁定.

字符集 show character set ; 查看系统中支持的字符集.
字符集中结尾符号 如果是ci表示大小写不敏感,如果是cs的话表示大小写敏感.
实力级别指定字符集.在配置文件中指定,那么在创建新数据库的时候会成为默认的数据库字符集;
当创建表的时候没有指定字符集的话会直接继承数据库的字符集.如果数据库没指定字符集
就会继承配置文件的字符集.字段的字符集会继承表的字符集.....
对于已经创建好的表中,修改表的字符集对于已经创建好的字段的字符集没有影响.

拉丁为啥可以存储中文.课后作业.
规避乱码:
要连接,服务,和数据库,以及表上的字符集需要一致才不会出现乱码.
set names utf8;将连接设置成指定的字符集编码.
```

## **definer**

```
在mysql创建view、trigger、function、procedure、event时都会定义一个Definer=‘xxx’,类似如下：
CREATE
    ALGORITHM = UNDEFINED
    DEFINER = `root`@`%`
    SQL SECURITY DEFINER
VIEW `v_ questions` AS
    SELECT
        `q`.`id` AS `id`,
        `q`.`title` AS `title`
    FROM
         Test q;
或者像这样的：

CREATE DEFINER=`root`@`%` PROCEDURE `user_count`()
  LANGUAGE SQL
  NOT DETERMINISTIC
  CONTAINS SQL
  SQL SECURITY DEFINER
  COMMENT ''
BEGIN
    select count(*) from mysql.user;
END
加红的部分SQL SECURITY 其实后面有两个选项，一个为DEFINER，一个为INVOKER

SQL SECURITY { DEFINER | INVOKER } ：指明谁有权限来执行。DEFINER 表示按定义者拥有的权限来执行

INVOKER 表示用调用者的权限来执行。默认情况下，系统指定为DEFINER 
```



# 常用命令

## 查看版本

```
select version();
```

## 判断表是否存在

```
1、判断数据库是否存在
	select * from information_schema.SCHEMATA where SCHEMA_NAME = '需要查找的数据库名'; 
	select * from information_schema.SCHEMATA where SCHEMA_NAME like '%需要查询的数据库名的部分名称%'; 

2、判断数据表是否存在
	select * from information_schema.TABLES where TABLE_NAME = '需要查询的数据表名';
```

## 用户权限

### 示例

```
select version()
SELECT @@VERSION

show databases;
show tables;

select * from mysql.user
select * from performance_schema.accounts
select * from information_schema.SCHEMATA

#锁定|解锁用户
alter user 'dev'@'%' account lock;
alter user 'dev'@'%' account unlock;

#root的权限收回
update user set host='localhost' where user='root'
#修改root密码
alter user 'root'@'localhost' identified with mysql_native_password by 'htgx#!1024';

#查询当前mysql8中有什么角色:
select * from mysql.user
select * from mysql.role_edges
select distinct 
	user 'role name', 
	if(from_user is null,0, 1) active
from mysql.user left join mysql.role_edges on from_user=user
where account_locked='y' and password_expired='y' and authentication_string='';

#权限查询
show grants;
show grants for 'dev'@'%'

#用户创建&赋权
create user zm_test identified by 'htgx#!1024';
grant all privileges on *.* to 'zm_test'@'%' identified by 'htgx#!1024';
flush privileges;

#角色和用户同一个？
select * from mysql.user
select current_user()
select current_role()
create role zm_test_role1,zm_test_role2,zm_test_role3
drop user zm_test_role2
drop role zm_test_role3
set password for 'zm_test_role1'@'%'='12345678'
alter user 'zm_test_role1'@'%' identified with mysql_native_password by '123456';

#需要有grant_priv权限的用户
grant all on *.* to 'zm_test_role1'@'%' identified by '123456' with grant option;
grant all privileges on *.* to 'zm_test_role1'@'%' identified by '123456' ;
revoke all privileges on *.* to 'zm_test_role1'@'%' identified by '123456';

create user 'root'@'%' identified by '123456';
grant all privileges on *.* to 'root'@'%' ;

```

### 摘抄

```
grant 权限列表 on 数据库 to '用户名'@'访问主机' identified by '密码'; 

grant all privileges *.* to '要创建的用户'@'localhost' identified by '自定义密码';
flush privileges;刷新权限
    其中localhost指本地才可连接
    可以将其换成%指任意ip都能连接
    也可以指定ip连接

# 授权
    grant all privileges on dbname.tablename to 'username'@'ip';
    grant all privileges on *.* to 'test1'@'localhost' with grant option;
    grant SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, INDEX, CREATE VIEW, SHOW VIEW, CREATE TEMPORARY TABLES 
    on dbname.tablename to 'username'@'ip';

    with gran option表示该用户可给其它用户赋予权限，但不可能超过该用户已有的权限
    比如a用户有select,insert权限，也可给其它用户赋权，但它不可能给其它用户赋delete权限，除了select,insert以外的都不能
    这句话可加可不加，视情况而定。

	all privileges 可换成select,update,insert,delete,drop,create等操作
	如：grant select,insert,update,delete on *.* to 'test1'@'localhost';

    第一个*表示通配数据库，可指定新建用户只可操作的数据库
        如：grant all privileges on 数据库.* to 'test1'@'localhost';
    第二个*表示通配表，可指定新建用户只可操作的数据库下的某个表
        如：grant all privileges on 数据库.指定表名 to 'test1'@'localhost';
	
# 查看权限
	show GRANTS;
# 查看指定用户权限
	show GRANTS for 'username'@'ip';
	show grants for 'test1'@'localhost';
	示例：show grants for 'dev'@'%'
	
# 撤销权限
	revoke all on *.* from 'username'@'ip';
	revoke all privileges on *.* from 'test1'@'localhost';

# 删除用户
	drop user 'test1'@'localhost';
	drop user 'username'@'ip';
# 删除以后要刷新权限
	FLUSH PRIVILEGES;
	
# 创建用户，ip填'%'表示允许所有ip
	create user 'username'@'ip' IDENTIFIED by 'password';

# 允许远程客户端通过密码访问
	alter user 'username'@'ip' IDENTIFIED WITH mysql_native_password by 'password';

# 直接创建能够通过远程客户端访问的账户
	create user 'username'@'ip' IDENTIFIED WITH mysql_native_password by 'password';

# 修改用户
	rename user 'username'@'ip' to 'new_username'@'new_ip';

# 修改密码
	set password for 'username'@'ip'='new_password';
	or
    alter user 'test1'@'localhost' identified by '新密码';
    flush privileges;
```

### 注意

```
MySQL 8.0已经不支持下面这种命令写法
	grant all privileges on *.* to root@"%" identified by ".";

正确的写法是先创建用户
	create user 'root'@'%' identified by '123456';
再给用户授权
	grant all privileges on *.* to 'root'@'%' ;
```



# 启动

```
su - mysql
sh /home/mysql/support-files/mysql.server start
```

