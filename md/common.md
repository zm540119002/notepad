# **常用**

```
公司邮箱网址：
	http://mail.huitone.com/webmail7.5/webmail.php?r=site/index/domain/huitone.com
    登录账户：	zm@huitone.com
    登录密码：	HTGX100
    
公司官方网站
    前台：	http://www.huitone.com/
    后台:  http://www.faisco.cn/ 
    账号: iw13833136 
    员工号: xc 
    密码: ZGRiNDE0ZWYxODk5MTlk

    (2)域名:http://domain.cnolnic.com
    账号: huitone.com 
    密码: OTEzZjgzNTBjMWFiNGQ0
    
oa系统：
	账号：	手机号码
	密码： 12345678
	手机App：下载搜索 E-Mobile7 安装
	地址：
        外网：http://oa.huitone.com:8999
        内网：http://172.16.7.120:2019/
```



## 172.16.7.74

```
---------------------------------------------------------------apache
vim /usr/local/apache2/conf/httpd.conf
vim /usr/local/apache2/conf/extra/httpd-vhosts.conf
/usr/local/apache2/bin/apachectl start
---------------------------------------------------------------php
vim /usr/local/php/lib/php.ini
extension_dir = "/usr/local/php/include/php/ext"
cd /usr/local/php/include/php/ext
---------------------------------------------------------------
```

## 172.16.8.3  

```
username:	root
password:	123456
```

## 172.16.8.231

```
username:	root
password:	 Huitone369!@#
```

## 124.71.112.70

```
username:	root
password:	Huitone!2214
------------------------------apache2.4
vim /usr/local/apache2/conf/httpd.conf
vim /usr/local/apache2/conf/extra/httpd-vhosts.conf
/usr/local/apache2/bin/apachectl stop
------------------------------达梦
systemctl start DmServiceDMSERVER
------------------------------php
------------------------------php.ini
extension_dir=/data/dmdbms/drivers/php_pdo
extension=libphp72ts_dm.so
extension_dir=/data/dmdbms/drivers/php_pdo
extension=php72ts_pdo_dm.so
------------------------------
php增加DM、PDO_DM 扩展方法：
1.服务器装一套达梦客户端：dmdbms .
2.php.ini 文件增加扩展项：
extension_dir=/data/dmdbms/drivers/php_pdo
extension=libphp72ts_dm.so
extension_dir=/data/dmdbms/drivers/php_pdo
extension=php72ts_pdo_dm.so
3.环境变量增加指向达梦的bin目录，并重载环境变量。
export LD_LIBRARY_PATH=/data/dmdbms/bin
4.重启apache 即可完成DM，PDO_DM的加载项安装。
```

# 记录

## 词辉

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

## 流程配置

### 问题

```
1，数据同步新增字段
```

### 可优化

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

