# **常用**

```
广州汇通国信科技有限公司OA系统正式上线，网址是公司内网
http://157.122.61.228:2019/login/Login.jsp?logintype=1
账户名为大家各自的手机号，密码是：	HTGX100。
同时下载手机app端进行考勤签到，OA手机端服务器为157.122.61.228:89。

公司邮箱网址：
	http://mail.huitone.com/webmail7.5/webmail.php?r=site/index/domain/huitone.com
    登录账户：	zm@huitone.com
    登录密码：	HTGX100
    
公司官方网站
    前台：	http://www.huitone.com/
    后台:  	http://www.faisco.cn/ 
    账号: iw13833136 
    员工号: xc 
    密码: ZGRiNDE0ZWYxODk5MTlk

    (2)域名:http://domain.cnolnic.com
    账号: huitone.com 
    密码: OTEzZjgzNTBjMWFiNGQ0
    
oa系统：
	http://oa.huitone.com:2019/login/Login.jsp?logintype=1
	账号：	手机号码
	密码： 20210421

```



# **服务器**

## 172.16.6.35

```
---------------------------------------------------------------
username:	root
password:	huitone2215#
---------------------------------------------------------------mysql
su - mysql
启动守护进程：
/bin/sh /home/mysql/bin/mysqld_safe --datadir=/home/mysql/data/mysql --pid-file=/home/mysql/data/mysql/mysqldb.pid
启动mysql服务：
sh /home/mysql/support-files/mysql.server start
---------------------------------------------------------------redis
cd /usr/local/redis-2.8.17/src
./redis-server ../redis.conf
/usr/local/redis-2.8.17/src/redis-server /usr/local/redis-2.8.17/redis.conf
---------------------------------------------------------------postgresql
su - postgresql
/usr/local/postgresql-10.1/bin/pg_ctl -D /usr/local/postgresql-10.1/data -l /usr/local/postgresql-10.1/log/pgsql.log start 
---------------------------------------------------------------java
vim /usr/local/sbin/restart-java.sh
重启防火墙之后要检查9001端口有没有放开
---------------------------------------------------------------
---------------------------------------------------------------可能问题java
```
## 172.16.6.44

```
username:	root
password:	huitone2214
username:	oracle
password:	huitone2214
---------------------------------------------------------------apache
vim /usr/local/apache/conf/httpd.conf
LoadModule php5_module        modules/libphp5.so
vim /usr/local/apache/conf/httpd.conf
vim /usr/local/apache/conf/extra/httpd-vhosts.conf
web根目录：	/usr/local/apache/htdocs
/usr/local/apache2/logs
http://172.16.6.44/inc_chk/login.php
apache 启动：	/usr/local/apache/bin/apachectl restart
---------------------------------------------------------------php
vim /usr/local/php/etc/php.ini
log_errors=On
error_log=/usr/local/php/php_error.log
/usr/local/php/bin/php -m 
/usr/local/php/bin/phpize
php已安装扩展：
cd /usr/local/php/lib/php/extensions/no-debug-non-zts-20060613
---------------------------------------------------------------
```

## 172.16.6.45

```
username:	root
password:	huitone2214
```



## 172.16.7.54

```
---------------------------------------------------------------gitlab
http://172.16.7.54:9090
登陆账号密码： 
    root/huitone2214
    git/huitone2214
    htgx@huitone.com/12345678
参考：
	https://www.jianshu.com/p/80d9a656d6c6?utm_campaign=maleskine&utm_content=note&utm_medium=
	seo_notes&utm_source=recommendation
---------------------------------------------------------------
```

## 172.16.7.55

```
username:	root
password:	htgx@test&
username:	dev
password:	abc123!
---------------------------------------------------------------oracle
ua_dbg/ua_dbgrica
ltdba/ltdbarica
---------------------------------------------------------------mysql
数据库用户：			 dev
数据库用户密码：		abc123!
su - mysql
sh /home/mysql/support-files/mysql.server start
---------------------------------------------------------------
```

## 172.16.7.56

```
username:	root
password:	huitone2214$
---------------------------------------------------------------apache
vim /etc/apache2.4/httpd.conf
vim /etc/apache2.4/extra/httpd-vhosts.conf
vim /etc/apache2.4/extra/httpd-ssl.conf
/usr/local/apache2.4/bin/apachectl start
tail -f /usr/local/apache2.4/logs/access_log
tail -f /usr/local/apache2.4/logs/error_log
注意防火墙问题！！
---------------------------------------------------------------php-7.2.26
扩展库路径：	cd /usr/local/php7/lib/php/extensions/no-debug-zts-20170718
配置文件：	vim /usr/local/php7/etc/php.ini
scp -r root@139.159.218.155:/app/dmdbms/drivers/oci/libdmoci.so oci8.so
scp -r root@172.16.7.55:/home/oracle/dmdbms/drivers/oci/libdmoci.so oci8.so

解压：tar zxvf libdmoci.so.tar.gz
压缩：tar zcvf libdmoci.so.tar.gz libdmoci.so

解包：tar xvf libdmoci.so.tar
打包：tar cvf libdmoci.so.tar libdmoci.so
（注：tar是打包，不是压缩！）
---------------------------------------------------------------php-7.2.31
cd /usr/local/lib/php/extensions/no-debug-non-zts-20170718/
```

## 172.16.7.57

```
username:	root
password:	huitone2215!
username:	dev
password:	huitonedev
username:	oracle
password:	huitone2214
--------------------------------------------------------------nginx
安装目录：	cd /usr/local/nginx/
web目录：	 cd /www/wwwroot/front/
配置文件：	vim /usr/local/nginx/conf/nginx.conf
启动：		 /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
停止：
	ps -ef|grep nginx
	从容停止： kill -QUIT 2072
	快速停止： kill -TERM 2132 | kill -INT 2132
	强制停止： pkill -9 nginx
--------------------------------------------------------------redis
#启动
	/usr/local/redis/bin/redis-server /usr/local/redis/bin/redis.conf
	sudo /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
--------------------------------------------------------------mongoDB
#启动
	/usr/local/mongodb/bin/mongod --config /usr/local/mongodb/bin/mongodb.conf
#关闭
	/usr/local/mongodb/bin/mongod --config /usr/local/mongodb/bin/mongodb.conf --shutdown
--------------------------------------------------------------java
57用dev用户启动java程序：	
	su - dev
	
vim /home/dev/sbin/restart-govern.sh

ps -ef|grep data_govern|grep java | awk '{print "kill " $2}'|sh
sleep 10
ps -ef|grep data_govern|grep java | awk '{print "kill " $2}'|sh

# 所有服务启动脚本 
nohup java  -jar  /www/data_govern/jars/databank-eurekaserver.jar >> /www/data_govern/logs/eurekaserver.log 2>&1 &
sleep 10
# xxl-job
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48888,server=y,suspend=n -Dspring.profiles.active=dev -jar /www/data_govern/jars/xxl-job-admin-2.2.1-SNAPSHOT.jar   >>  /www/data_govern/logs/xxl-job-admin-2.2.1-SNAPSHOT.log 2>&1 &
sleep 10
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48001,server=y,suspend=n  -Dspring.profiles.active=dev   -jar /www/data_govern/jars/baop-dbserver-1.0.0-SNAPSHOT.jar >> /www/data_govern/logs/baop-dbserver-1.0.0-SNAPSHOT.log 2>&1 &
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48762,server=y,suspend=n  -Dspring.profiles.active=dev   -jar /www/data_govern/jars/baop-authapi-1.0.0-SNAPSHOT.jar >> /www/data_govern/logs/baop-authapi-1.0.0-SNAPSHOT.log 2>&1 &
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=49001,server=y,suspend=n  -Dspring.profiles.active=dev  -jar  /www/data_govern/jars/baop-gateway-1.0.1-SNAPSHOT.jar >> /www/data_govern/logs/baop-gateway-1.0.1-SNAPSHOT.log 2>&1 &
sleep 10
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48089,server=y,suspend=n   -Dspring.profiles.active=dev  -jar   /www/data_govern/jars/data-govern-0.0.1-SNAPSHOT.jar  >>  /www/data_govern/logs/data-govern-0.0.1-SNAPSHOT.log 2>&1 &
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48889,server=y,suspend=n   -Dspring.profiles.active=dev  -jar   /www/data_govern/jars/convert-0.0.1-SNAPSHOT.jar  >>  /www/data_govern/logs/convert-0.0.1-SNAPSHOT.log 2>&1 &
 nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48891,server=y,suspend=n -Dspring.profiles.active=dev -jar /www/data_govern/jars/data-clean-0.0.1-SNAPSHOT.jar  >>  /www/data_govern/logs/data-clean-0.0.1-SNAPSHOT.log 2>&1 &
sleep 10
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48890,server=y,suspend=n  -Dspring.profiles.active=dev   -jar /www/data_govern/jars/task-sched-0.0.1-SNAPSHOT.jar  >>  /www/data_govern/logs/task-sched-0.0.1-SNAPSHOT.log 2>&1 &
sleep 5
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48099,server=y,suspend=n  -Dspring.profiles.active=dev   -jar /www/data_govern/jars/data-report-0.0.1-SNAPSHOT.jar  >>  /www/data_govern/logs/data-report-0.0.1-SNAPSHOT.log 2>&1 &
sleep 15
ps -ef|grep data_govern|grep java
ps -ef|grep data_govern|grep java|wc -l
--------------------------------------------------------------启动单个服务
cd /usr/local/web/data-govern/
git pull 
mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true 
runjar.sh

cat /home/dev/sbin/runjar.sh
#! /bin/sh

# 询问用户需要启动哪个
v_jar_list="databank-eurekaserver.jar
xxl-job-admin-2.2.1-SNAPSHOT.jar
baop-dbserver-1.0.0-SNAPSHOT.jar
baop-authapi-1.0.0-SNAPSHOT.jar
baop-gateway-1.0.1-SNAPSHOT.jar
data-govern-0.0.1-SNAPSHOT.jar
convert-0.0.1-SNAPSHOT.jar
data-clean-0.0.1-SNAPSHOT.jar
task-sched-0.0.1-SNAPSHOT.jar
data-report-0.0.1-SNAPSHOT.jar"


echo "------------目前系统支持的jar包有-----------"
cat <<< "${v_jar_list}"
echo "-----------------------"

echo "请输入启动哪个jar包名（从上面复制粘贴）:"

read v_jar
v_file=$(find /usr/local/web/data-govern/ -name ${v_jar})

if [ "${v_file}" == "" ]
then
    echo "查找不到jar包"
    exit 1
fi

# v_file是文件全路径 v_file_name是文件名
v_file_name=$(echo ${v_file} | awk -F / '{print $NF}')

# 如果文件更新则需要复制一份
if [  ${v_file} -nt  /www/data_govern/jars/${v_file_name}  ]
 then
    # \cp避免alias干扰  -p代表保持时间一致
    \cp -p ${v_file} /www/data_govern/jars/
fi

# 如果进程在 则一直循环杀进程
while [ "$(ps -ef|grep ${v_file_name}|grep -v grep)"  != "" ] 
do
    echo "to kill proc $(ps -ef|grep ${v_file_name}|grep -v grep)"
    ps -ef|grep ${v_file_name}|grep -v grep | awk '{print "kill "$2}'|sh
    sleep 2
done

# 获取启动命令并执行
v_cmd=$(grep  ${v_file_name} ${HOME}/sbin/restart-govern.sh)
echo ${v_cmd} | sh

sleep 2
ps -ef|grep ${v_file}|grep -v grep

--------------------------------------------------------------
```

## 172.16.7.58

```
username:	root
password:	huitone2214@
username:	oracle
password:	huitone2214
---------------------------------------------------------------mysql
service mysqld start
注意ONLY_FULL_GROUP_BY问题

jdbc-url: jdbc:mysql://172.16.7.58:3306/api_platform?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
username: root
password: Huitone2214!
---------------------------------------------------------------
```

## 172.16.7.60 

```
username:	root
password:	huitone2214
```

## 172.16.7.71

```
---------------------------------------------------------------
username:	root
password:	htgx@123456%
---------------------------------------------------------------nginx
vi /usr/local/nginx/conf/nginx_2c.conf
ps -ef|grep nginx
启动： /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx_2c.conf
重启： /usr/local/nginx/sbin/nginx -s reload
停止： /usr/local/nginx/sbin/nginx -s stop 
---------------------------------------------------------------postgresql
vim /usr/local/pgsql/data/postgresql.conf
    shared_buffers = 128MB | 4GB
    max_wal_size = 1GB | 8GB
    work_mem = 4MB | 256MB
    maintenance_work_mem = 64MB | 2GB
    autovacuum_work_mem = -1 | 2GB
    effective_cache_size = 4GB
    
vim /usr/local/pgsql/data/pg_hba.conf
启动：
	su - postgresql
	/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/log/pgsql.log start | stop | status
登陆：
	psql -h 127.0.0.1 -p 5432 -U postgre -d dev
密码：	
	huitone2214
---------------------------------------------------------------
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



