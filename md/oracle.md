# 错误及解决：

## ora-01502

https://www.cnblogs.com/lijiaman/p/9277149.html

```
Oracle分区表删除分区引发错误ORA-01502: 索引或这类索引的分区处于不可用状态
（一）问题：

最近在做Oracle数据清理，在对分区表进行数据清理时，采用的方法是drop partition，删除的过程中，没有遇到任何问题，大概过了10分钟，开发人员反馈部分分区表上的业务失败。具体错误为：

ORA-01502错误：索引或这类索引的分区处于不可用状态（英文：ora-01502:index 'schema.index_name' or partition of such index is in unusable state）。

（二）原因分析

查看出现问题的分区表，均有一个共同点：表上以“pk_”开头的索引为unusable状态，以“pk_”开头的索引是随创建主键约束而创建的。当用户在创建主键约束或唯一性约束的时候，会在相应的列上创建唯一性索引

经过查证，发现是在删除分区的时候，导致分区表上的唯一性全局索引为不可用状态，导致新的数据无法正常插入，从而引发了该错误。

是不是索引不可用会导致DML操作失败呢？经过验证，发现以下特点：

1.对于非唯一性索引，如果索引不可用，是不会影响到到DML操作的；

2.对于唯一性索引，如果索引不可用，在进行DML操作时，会触发ORA-01502错误；



```

这里记录一下哪些操作会导致索引失效：

![img](https://images2018.cnblogs.com/blog/823295/201807/823295-20180707141454626-1025330487.png)

```
（三）解决方案

（3.1）了解唯一性索引

在解决问题之前，我们来分析一下，哪些行为会创建唯一性索引(3种)：

--直接创建唯一性索引。
     语法为：CREATE UNIQUE INDEX index_name on table_name(col1，col2,…);

--创建主键约束时自动创建唯一性索引。
     语法为：ALTER TABLE table_name ADD CONSTRAINT constraint_name PRIMARY KEY(col1,col2,..);

--创建唯一性约束时自动创建唯一性索引。
     语法为：ALTER TABLE table_name ADD CONSTRAINT constraint_name UNIQUE(col1,col2,…);


这里，我总结了3套方案来对应ORA-01502问题。

（3.2）方案一：删除唯一性索引

与业务方面沟通，确认唯一性索引是否可以删除，如果可以，直接删除索引，删除语法为：

SQL> DROP INDEX schema.index_name;
对于由主键约束或唯一性约束创建的唯一性索引，不能直接删除

SQL> drop index lijiaman.sale_pk;
drop index lijiaman.sale_pk

ORA-02429: cannot drop index used for enforcement of unique/primary key
正确的方法是删除相应的约束。

SQL> alter table sales drop constraint sale_pk;

Table altered
小结：该方法简单粗暴，前提是在约束或索引在业务方面可以删除的情况下才能使用。

（3.3）方案二：重建唯一性索引（针对非分区表）
语法为：
SQL> ALTER INDEX [schema.]index_name REBUILD [ONLINE] [TABLESPACE tablespace name]
小结：该方法可以使索引可用。但对于分区表而言，依然存在问题：在下一次删除分区后，索引状态又会变为不可用。

（3.4）方案三：删除不可用的索引，创建唯一性分区索引（针对分区表）
创建唯一性分区索引：
SQL> CREATE UNIQUE INDEX index_name on [schema.]table(col1,col2,...);
对于主键约束、唯一性约束，可以使用以下语法添加唯一性局部分区索引：

SQL> ALTER TABLE [schema.]table_name ADD CONSTRAINT constarint [PRIMARY KEY | UNIQUE](col1,col2)
     USING INDEX LOCAL TABLESPACE tablespace_name;
小结：该方法可以有效解决分区表因删除分区导致的索引不可用问题。
```

## ora-01810

```
select to_date('2011-03-21 10:10:10','YYYY-MM-DD HH24:MM:SS') from dual; 
改成：
select to_date('2011-03-21 10:10:10','YYYY-MM-DD HH24:MI:SS') from dual; 
```

## ora-01843

```

```

## 乱码

```
配置前端（php）服务器的环境变量：
	vim ~/.bash_profile
	export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
	source ~/.bash_profile
重启apache（注意：不能restart，需先stop，再start）：
```

## plsql可以连接oracle但是OCILogon连接不上

https://jingyan.baidu.com/article/fc07f98977ec0f12fee51941.html

```
------解决方案--------------------
print_r(oci_error());
发现报：ora-28001

--查看用户密码默认管理方式
select profile from dba_users where username='ua_dbg';
select profile from dba_users where username='ltdba';

--查看数据库默认的密码管理方式有效期
SELECT * FROM dba_profiles WHERE profile='DEFAULT' AND resource_name='PASSWORD_LIFE_TIME';

--修改用户密码并设置数据库默认密码为永久有效
alter user ua_dbg identified by ua_dbgrica;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED ;
```

## 表空间不足的两种解决办法

https://www.cnblogs.com/xiaoxiaoliu888/p/9390857.html

```

```



# 环境变量(linux)

```
export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib

env：
LANG=zh_CN.UTF-8
NLS_LANG=SIMPLIFIED CHINESE_CHINA.ZHS16GBK

export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
export NLS_LANG=SIMPLIFIED CHINESE_CHINA.ZHS16GBK
```



# 字符集

```
查看数据库字符集，涉及三方面的字符集，
    1. oracel server端的字符集;
    2. oracle client端的字符集（比如：apache所在服务器）;
    3. dmp文件的字符集。
    
查询oracle server端的字符集
	select userenv('language') from dual;
	
修改server端字符集(不建议使用)

客户端字符集设置方法
     1)UNIX环境
         $NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
         $export NLS_LANG
         编辑oracle用户的profile文件
    2)Windows环境
        编辑注册表
        Regedit.exe ---》 HKEY_LOCAL_MACHINE ---》SOFTWARE ---》 ORACLE-HOME
  		或者在窗口设置：
        set nls_lang=AMERICAN_AMERICA.ZHS16GBK
        
LANG是针对Linux系统的语言、地区、字符集的设置,对linux下的应用程序有效，如date；NLS_LANG是针对Oracle语言、地区、字符集的设置，对oracle中的工具有效
```



# linux 启动oracle

## 1、启动lsnrctl监听

```
先登陆服务器，切换到oracle用户：su - oracle
lsnrctl status
lsnrctl start
相关文件：listener.ora
```

## 2、启动数据库实例

```
以system用户身份登陆oracle：	sqlplus /nolog
SQL> conn as sysdba
ua_dbg	/ ua_dbgrica
SQL> startup
SQL> shutdown
```

# 语法

## merge into

```
merge into的形式：

MERGE INTO [target-table] A USING [source-table sql] B ON([conditional expression] and [...]...)
WHEN MATCHED THEN
[UPDATE sql]
WHEN NOT MATCHED THEN
[INSERT sql]

作用:判断Ｂ表和Ａ表是否满足ON中条件，如果满足则用B表去更新A表，如果不满足，则将B表数据插入A表但是有很多可选项，如下:
    1.正常模式
    2.只update或者只insert
    3.带条件的update或带条件的insert
    4.全插入insert实现
    5.带delete的update(觉得可以用3来实现)
```

## create table

```

```

### Oracle 将旧表插入表结构一致的新表中，并添加自增主键

https://www.cnblogs.com/leeniux/p/13560514.html

```
select * from SJY_ZNW3GCWBB

alter table SJY_ZNW3GCWBB drop column id;

drop table zm_test
create table zm_test as select * from SJY_ZNW3GCWBB where 1=0
select * from zm_test 
alter table zm_test add id number
alter table zm_test add constraint pk_id primary key (id)

create sequence zm_sequence
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
cache 20;

 select zm_sequence.nextval from dual
 
insert into zm_test select to_number(zm_sequence.nextval),t.* from SJY_ZNW3GCWBB t
```

### 示例

```
--------------------------------------------------------------------------------------- tb_uc_cfg_algorithm_task
-- Create table
drop table ua_dbg.tb_uc_cfg_algorithm_task;
create table ua_dbg.tb_uc_cfg_algorithm_task
(
  algorithm_task_id number not null,
  algorithm_task_name VARCHAR2(64) not null,
  classify       char(2) default '1' not null,
  ds_id number not null,
  sub_service_id  number not null,
  
  status            char(1) default '0' not null,
  indb_staff        varchar2(32),
  indb_time         date not null,
  modify_staff      varchar2(32),
  modify_time       date,
  remark            varchar2(2000)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table ua_dbg.tb_uc_cfg_algorithm_task
  add constraint pk_tb_uc_cfg_algorithm_task primary key (algorithm_task_id);
alter table ua_dbg.tb_uc_cfg_algorithm_task
  add constraint fk_cfg_algorithml_task_sub_svc foreign key (sub_service_id)
  references ua_dbg.tb_ua_cfg_sub_service_type (sub_service_id) on delete cascade
  deferrable;
```





