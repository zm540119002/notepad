# **常用**

## 公司邮箱网址

http://mail.huitone.com/webmail7.5/webmail.php?r=site/index/domain/huitone.com

```
登录账户：	zm@huitone.com
登录密码：	appleId密码
```

## 公司官方网站

前台：	http://www.huitone.com/
后台:  http://www.faisco.cn/ 

```
账号: iw13833136 
员工号: xc 
密码: ZGRiNDE0ZWYxODk5MTlk
   
http://domain.cnolnic.com
账号: huitone.com 
密码: OTEzZjgzNTBjMWFiNGQ0
```

## oa系统

http://oa.huitone.com:2019/wui/index.html

```
账号：	手机号码
	密码： 12345678
	手机App：下载搜索 E-Mobile7 安装
	地址：
        外网：http://oa.huitone.com:8999
        内网：http://172.16.7.120:2019/
```

# 词辉

```
1 易用性稳定性及数据权限优化，补充设计文档，对不合理代码重构，补全之前跳过的功能细节（入参校验，数据源表引用登记，数据源标变更处理）
2 补全etl功能，包括报表，工单，稽核规则（数据波动率 平衡性统计及告警 数据及时性），数据清洗，数据打标，电网特殊数据采集，质量报告
3 增加数据分析功能（例如异常数据发现可以做图表展示（饼图 拆线图 旋转透视图 箱线图） 最大值 最小值 中值 平均值等，数据差异对比）
4 支持多种本地数据库，优先考虑支持大数据组件（计划还是使用sql操作）。
考虑支持跨数据库操作（使用pg的dblink或者外部表如oracle_fdw,mysql_fdw,file_fdw）
5 数据输出（提供清洗或者打标的数据给其他系统）
6 增加实时数据采集，微批处理
7 运维优化（一键部署 一键启停 健康检查 绿灯测试 链路跟踪 报错日志优化）

其他通用变量：
	PROC_DATE：处理日期，指稽核点任务日期，不一定是实际执行的日期，比如11-2日重跑11-1日的稽核点，那么PROC_DATE为11-1日，而实际执行日期为11-2日。
	DATA_DATE：数据周期
	SCHED_ID：任务调度ID，对应TB_UC_TASK_SCHED.SCHED_ID
	SUB_SVC_RUN_ID：稽核点运行记录ID，对应TB_UA_SUB_SVC_RUN_LOG.SUB_SVC_RUN_ID
	DATA_BATCH_ID：数据批次ID，用于产生新数据时，标记本次产生的数据，目前等于SCHED_ID
	UC_DS_ID：产生结果数据源是，结果数据源的DS_ID


把系统从root用户迁移到dev的经验

1）修改/etc/security/limits.d/90-nproc.conf,将npoc设置最大。修改后，内容如下：
    cat /etc/security/limits.d/90-nproc.conf
    *          soft    nproc     65535
    root       soft    nproc     unlimited

2）修改/etc/security/limits.conf，增加nofile。修改方法如下：
    # echo "* - nofile 65535" >> /etc/security/limits.conf
    # echo "* - nproc 65535" >> /etc/security/limits.conf

3）将以下代码目录属主赋值给dev
    maven目录
    jdk目录
    jar部署的目录
    日志目录
    git代码目录
    
4）把root下面两个文件（目录）复制过来
    .bash_profile
    ~/sbin
    
selec case when (b. check_id  is null) then 1 else 0 end  
from a left join (select id, 1  as check_id from b) b on (a.id = b.id)

专题数据配置-增加系统记录

修改bug流程：

1 复现bug
2 在master修改并测试，确定bug修复
3 把代码提交到0.81分支
4 使用0.81版本程序测试，确定bug在0.81版本也修复了

分析了一下压测日志，主要有三类问题。
1 流程图保存接口报错。 查原因，发现是因为压测时跳过获取流程图这步操作，导致后面保存流程图时出现异常。（原因是获取流程图时会增加一条记录，后面保存时需要用到。后续可以考虑优化，保存流程图时，发现缺少这条记录自动补上。）
2 压测传参有问题，有一些需要填数字的地方填了类似"${变量名}"的东西。跟观生讨论了一下，初步认为是由于某些接口异常返回，导致压测脚本变量取值出现问题。
3 数据库偶尔出现死锁。查询死锁的记录，发现主要是关于tb_uc_task_depend的delete语句。 这个表没索引，网上说mysql删除没索引表的记录时容易出现死锁。我现在加上索引，后续再观察。
 

另外，偶尔会出现服务在压测过程中假死的情况。初步怀疑是gc造成的，现在设置虚拟机输出gc日志，等假死情况复现时再观察gc日志分析。


# -L localport:remotehost:remotehostport sshserver
# -N 不打开远程shell，处于等待状态（不加-N则直接登录进去） -g 启用网关功能
# 在172.16.7.71上执行，将9527的请求转发到172.16.7.56的80端口
ssh -L 9527:172.16.7.56:80 -Ng 172.16.7.71
```

# 流程配置

```

```

## 问题

```
1，数据同步新增字段
```

## 可优化

```
1、插入数据节点
	添加字段后字段表达式应该自动匹配
```

# 概念

## 数据中台

https://www.zhihu.com/question/330356466/answer/965877274

```
数据中台是指通过数据技术，对海量数据进行采集、计算、存储、加工，同时统一标准和口径。
前台是快速转动的小齿轮,后台是转动较慢的大齿轮,而中台正是连接两个齿轮的中间那枚变速齿轮,匹配前后台的速率,提高效率.
```

## 分布式

```
系统中的多个模块在不同服务器上部署，即可称为分布式系统，如Tomcat和数据库分别部署在不同的服务器上，或两个相同功能的Tomcat分别部署在不同服务器上
```

## 高可用

```
系统中部分节点失效时，其他节点能够接替它继续提供服务，则可认为系统具有高可用性
```

## 集群

```
一个特定领域的软件部署在多台服务器上并作为一个整体提供一类服务，这个整体称为集群。如Zookeeper中的Master和Slave分别部署在多台服务器上，共同组成一个整体提供集中配置服务。

在常见的集群中，客户端往往能够连接任意一个节点获得服务，并且当集群中一个节点掉线时，其他节点往往能够自动的接替它继续提供服务，这时候说明集群具有高可用性
```

## 负载均衡

```
请求发送到系统时，通过某些方式把请求均匀分发到多个节点上，使系统中每个节点能够均匀的处理请求负载，则可认为系统是负载均衡的
```

## 正向代理和反向代理

```
系统内部要访问外部网络时，统一通过一个代理服务器把请求转发出去，在外部网络看来就是代理服务器发起的访问，此时代理服务器实现的是正向代理；
当外部请求进入系统时，代理服务器把该请求转发到系统中的某台服务器上，对外部请求来说，与之交互的只有代理服务器，此时代理服务器实现的是反向代理。

简单来说：
    正向代理是代理服务器代替系统内部来访问外部网络的过程。
	反向代理是外部请求访问系统时通过代理服务器转发到内部服务器的过程。
```

## 同步与异步

```
同步和异步 [1]  关注的是消息通信机制 (synchronous communication/ asynchronous communication)。
所谓同步，就是在发出一个调用时，在没有得到结果之前，该调用就不返回。但是一旦调用返回，就得到返回值了。
换句话说，就是由调用者主动等待这个调用的结果。
而异步则是相反，调用在发出之后，这个调用就直接返回了，所以没有返回结果。换句话说，当一个异步过程调用发出后，调用者不会立刻得到结果。而是在调用发出后，被调用者通过状态、通知来通知调用者，或通过回调函数处理这个调用。
```

## 阻塞与非阻塞

```
阻塞和非阻塞 [2]  关注的是程序在等待调用结果（消息，返回值）时的状态.
阻塞调用是指调用结果返回之前，当前线程会被挂起。调用线程只有在得到结果之后才会返回。
非阻塞调用指在不能立刻得到结果之前，该调用不会阻塞当前线程。
```

## 结合两概念分析

```
在进程通信 [3]  层面， 阻塞/非阻塞， 同步/异步基本是同义词， 但是需要注意区分讨论的对象是发送方还是接收方。
发送方阻塞/非阻塞（同步/异步）和接收方的阻塞/非阻塞（同步/异步） 是互不影响的。
在 IO 系统调用层面（ IO system call ）层面， 非阻塞 IO 系统调用 和 异步 IO 系统调用存在着一定的差别， 它们都不会阻塞进程， 但是返回结果的方式和内容有所差别， 但是都属于非阻塞系统调用（ non-blocing system call ）
非阻塞系统调用（non-blocking I/O system call 与 asynchronous I/O system call） 的存在可以用来实现线程级别的 I/O 并发， 与通过多进程实现的 I/O 并发相比可以减少内存消耗以及进程切换的开销。
```

# 数据治理-新系统

```

```

## 迁移

```

```

### mysql

```
select version()

#1、去掉 ONLY_FULL_GROUP_BY
SELECT @@GLOBAL.sql_mode;
set @@GLOBAL.sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'

SET GLOBAL log_bin_trust_function_creators = 1;

CREATE DEFINER=`dev`@`%` FUNCTION `getChildrenMenu`(menuid VARCHAR(128)) RETURNS varchar(4000) CHARSET utf8
BEGIN
    DECLARE oTemp VARCHAR(4000);
    DECLARE oTempChild VARCHAR(4000);

    SET oTemp = '';
    SET oTempChild = CAST(menuid AS CHAR);

    WHILE oTempChild IS NOT NULL
    DO
    SET oTemp = CONCAT(oTemp,',',oTempChild);
    SELECT GROUP_CONCAT(menu_id) INTO oTempChild FROM t_sys_menu
    WHERE FIND_IN_SET(parent_id,oTempChild) > 0;
    END WHILE;
    RETURN oTemp;
END

CREATE DEFINER=`dev`@`%` FUNCTION `getChildrenOrg`(orgid VARCHAR(4000)) RETURNS varchar(4000) CHARSET utf8
BEGIN
    DECLARE oTemp VARCHAR(4000);
    DECLARE oTempChild VARCHAR(4000);

    SET oTemp = '';
    SET oTempChild = CAST(orgid AS CHAR);

    WHILE oTempChild IS NOT NULL
    DO
    SET oTemp = CONCAT(oTemp,',',oTempChild);
    SELECT GROUP_CONCAT(organizational_code) INTO oTempChild FROM t_sys_organizational_structure_config 
    WHERE FIND_IN_SET(parent_code,oTempChild) > 0;
    END WHILE;
    RETURN oTemp;
END

#2、隔离级别
    select @@transaction_isolation;
    select @@global.transaction_isolation;
    set session transaction isolation level read committed;
    set global transaction isolation level read committed;

#3、需要copy表数据的表：
    select * from convert.tb_ua_cfg_var #内置变量
    select * from convert.tb_uc_cfg_data_class #归属业务域
    select * from convert.tb_uc_cfg_data_cust_class #一级分类
    select * from convert.tb_uc_cfg_data_cust_class2 #二级分类
    select * from convert.tc_gvn_system #系统名称
    select * from convert.tb_ua_sys_data_define #字段类型
    select * from convert.tb_uc_cfg_data_domain
    select * from convert.tb_uc_cfg_source_system #
    select * from convert.tb_ua_cfg_meta_rule #清洗元规则
    
    #tb_ua_sys_code两个库都有，记录一样的
    select * from convert.tb_ua_sys_code #系统内置规则编码
    select * from dev.tb_ua_sys_code #系统内置规则编码
    
    select * from dev.tc_gvn_db_clct_re_algorithm #字段转换方法
```

### java

#### [xxl-job, admin JobLosedMonitorHelper] ERROR

```
[xxl-job, admin JobLosedMonitorHelper] ERROR [com.zaxxer.hikari.pool.HikariPool:574] - throwPoolInitializationException() - HikariCP - Exception during pool initialization.
com.mysql.cj.jdbc.exceptions.CommunicationsException: Communications link failure

解决办法在警告中已经说明：
    1.在数据库连接的url中添加useSSL=false;
    2.url中添加useSSL=true，并且提供服务器的验证证书。
```

# 数据治理-旧系统

```

```

