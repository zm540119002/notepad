# 错误及解决：

## ora-01502

```
参考：	https://www.cnblogs.com/lijiaman/p/9277149.html
```

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
SQL> startup
SQL> shutdown
```

