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
```



# **服务器**

## 172.16.6.35

```
username:	root
password:	oracle
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
password:	huitone2214
---------------------------------------------------------------oracle
ua_dbg/ua_dbgrica
ltdba/ltdbarica
---------------------------------------------------------------mysql
/home/mysql/bin/mysqld --basedir=/home/mysql --datadir=/home/mysql/data/mysql --plugin-dir=/home/mysql/lib/plugin --log-error=/home/mysql/data/mysql/error.log --open-files-limit=65535 --pid-file=/home/mysql/data/mysql/mysqldb.pid --socket=/tmp/mysql.sock --port=3306

/bin/sh /home/mysql/bin/mysqld_safe --datadir=/home/mysql/data/mysql --pid-file=/home/mysql/data/mysql/mysqldb.pid

/home/mysql/bin/mysqld stop
/home/mysql/bin/mysqld start
```

## 172.16.7.56

```
username:	root
password:	huitone2214
---------------------------------------------------------------apache
vim /etc/apache2.4/httpd.conf
vim /etc/apache2.4/extra/httpd-vhosts.conf
vim /etc/apache2.4/extra/httpd-ssl.conf
/usr/local/apache2.4/bin/apachectl restart
tail -f /usr/local/apache2.4/logs/access_log
tail -f /usr/local/apache2.4/logs/error_log
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
password:	huitone2214
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
	/usr/local/redis/bin/redis-server redis.conf
--------------------------------------------------------------mongoDB
#启动
	/usr/local/mongodb/bin/mongod --config /usr/local/mongodb/bin/mongodb.conf
#关闭
	/usr/local/mongodb/bin/mongod --config /usr/local/mongodb/bin/mongodb.conf --shutdown
```

## 172.16.7.58

```
username:	root
password:	huitone2214
username:	oracle
password:	huitone2214
```

## 172.16.7.60 

```
username:	root
password:	huitone2214
```

## 172.16.7.71

```
username:	root
password:	htgx@123456
---------------------------------------------------------------nginx
vi /usr/local/nginx/conf/nginx_2c.conf
ps -ef|grep nginx
启动： /usr/local/nginx/sbin]$ /usr/local/nginx/sbin/nginx -c conf/nginx_2c.conf
重启： /usr/local/nginx/sbin/nginx -s reload  
停止： /usr/local/nginx/sbin/nginx -s stop 
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
```

## 172.16.8.3  

```
username:	root
password:	123456
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
```