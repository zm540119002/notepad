# **常用**

## 开启调试模式

```
如果服务器关闭了php服务的错误提示，而又需要对某个php文件进行调试，可以在文件中加入如下代码：
ini_set('display_errors', true);
error_reporting(E_ALL);
```

## header头

```
###内容类型###
header('Content-Type: text/html; charset=utf-8'); //网页编码
header('Content-Type: text/plain'); //纯文本格式
header('Content-Type: image/jpeg'); //JPG、JPEG
header('Content-Type: application/zip'); // ZIP文件
header('Content-Type: application/pdf'); // PDF文件
header('Content-Type: audio/mpeg'); // 音频文件
header('Content-type: text/css'); //css文件
header('Content-type: text/javascript'); //js文件
header('Content-type: application/json'); //json
header('Content-type: application/pdf'); //pdf
header('Content-type: text/xml'); //xml
header('Content-Type: application/x-shockw**e-flash'); //Flash动画

######

###声明一个下载的文件###
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="ITblog.zip"');
header('Content-Transfer-Encoding: binary');
readfile('test.zip');
######

###对当前文档禁用缓存###
header('Cache-Control: no-cache, no-store, max-age=0, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
######

###显示一个需要验证的登陆对话框###
header('HTTP/1.1 401 Unauthorized');
header('WWW-Authenticate: Basic realm="Top Secret"');
######


###声明一个需要下载的xls文件###
header('Content-Disposition: attachment; filename=ithhc.xlsx');
header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
header('Content-Length: '.filesize('./test.xls'));
header('Content-Transfer-Encoding: binary');
header('Cache-Control: must-revalidate');
header('Pragma: public');
readfile('./test.xls');
######
?>
```

### apache配置方式

```

```



# 常见问题

## **连不上数据库常见原因**

### ip限制

### ip冲突

```
今天运维同事说重启程序后数据库连接不上，让我帮忙看看。

其它机器连接数据库是正常的，应该是网络出现问题。

我上去后先试一下在应用服务器ping数据库服务器，发现可以正常ping通。

再用telnet试一下应用服务器连接数据库服务器端口是否通，发现telnet提示No route to host

本来以为是路由设置问题，但发现两台机是在同一个局域网内，路由配置正常。

再检查了一下数据库服务器的防火墙和iptables，发现配置也没问题，即使把防火墙关了也没用。

能想到的网络问题都排除了，网上也查不到有用的资料，只能暂时放弃。

为了解决问题，我想出了一个临时解决方法：

从数据库服务器上连接回应用服务器，做一个ssh转发，把应用服务器本地的1521端口转到远程的1521端口

这样应用程序就不需要连接数据库服务器的端口，只要连接本地端口就行。

但实际操作时发现一个问题：从数据库服务器ssh连接应用服务器时，提示密码错误。

但使用SecureCRT直接连接应用服务器时，使用相同密码却能正常登录。

当时我心里突然灵光一闪：**“难道连接的不是同一台机？”**

于是用ifconfig 检查一下两台服务器的ip设置，发现一个问题：

**数据库服务器有多个网卡，其中有一个网卡配置的ip地址与应用服务器的一样！**

咨询了一下运费同事，这个配置有问题的网卡并没有用。

于是让他把这个网卡ip改了，然后再试了一下，发现这次应用服务器可以正常使用telnet连接数据库服务器的端口了。

（中间有一个插曲，我使用ip down停了有问题的网卡后，发现连接还是有问题。看到网上说需要把网络全停了，修改配置再启动才有效。于是我就照着操作执行“ service network stop”时，突然发现有问题:SecureCRT所有窗口都断开了。这时我才想起来，我现在是通过远程连接操作服务器的，把网络关了我啥都干不了-_-!。后来只能让现场的运维同事帮忙到机房连接机器重新开启网络服务才行。**远程操作服务器时应该禁止执行关闭机器或者关闭网络的命令，我安全操作意识还是太低了。**）

感概：要是有网络问题检查清单就好了，不用每次靠灵感去查问题。
```
## ERR_CONNECTION_TIMED_OUT

```
关闭防火墙： 
	service iptables stop 
启动oracle： 
    su - oracle
    sqlplus /nolog
    conn /as sysdba
    startup | shutdown
启动oracle监听：
    su - oracle
    lsnrctl status
    lsnrctl start|stop
vim /etc/hosts
```

## 访问慢

```
数据库(oracle)所在服务器
    vim /etc/resolv.conf
    注释掉dns配置
    原因：oracle安全机制，需要用计算机名去访问数据库，会根据ip去所配dns服务器解析
```

## 乱码问题

```
1、添加环境变量：
	vim ~/.bash_profile
	export NLS_LANG='SIMPLIFIED CHINESE_CHINA.ZHS16GBK'
	source ~/.bash_profile
	然后重启apache：
	/usr/local/apache2.4/bin/apachectl stop
	/usr/local/apache2.4/bin/apachectl start
	加了环境变量后最好检查一下有没有生效：
	ps -ef|grep httpd
	strings /proc/apache进程id/environ | grep NLS_LANG
	例如：	strings /proc/1940/environ | grep NLS_LANG
2、php.ini文件禁用putenv函数
	vim /usr/local/php7/etc/php.ini
SIMPLIFIED CHINESE_CHINA.ZHS16GBK与AMERICAN_AMERICA.ZHS16GBK区别：
```

## session不断变化

```
现象：
	https换成http后sessionid不断变化
原因：
    session.cookie_secure = true
    如果开启则表明你的cookie只有通过HTTPS协议传输时才起作用，用http协议是不发送的。
解决：
	vim /usr/local/php7/etc/php.ini
	session.cookie_secure = false
```

## Allowed memory size of 134217728 bytes exhausted (tried to allocate 2611816 bytes)

```
一个php脚本一次请求的内存空间就要超过128M，那不管你以后将memory_limit设置成多大，以后肯定有出问题的时候。

究其原因，是我在在编码时，仅仅对变量赋值，却从来没有 unset ($var) 过。导致了内存占用越来越多，所以以后一个变量不再使用之后，一定要记得unset掉它。

memory_limit的内存分配，标配是128M。一旦独立的线程超过了128M，那PHP会报错： Fatal error: Allowed memory size of 33554432 bytes对于8G内存的服务器，如果同时并发的响应达到50,每个都是128M的峰值，那估计也是服务器会卡死的时候。 

这里有三种解决方案 ：
1、修改php.ini （改配置）
    memory_limit = 128
    这种方法需要重启服务器，很显然，此方法对虚拟机有限制。
    
2、通过ini_set函数修改配置选项值 （改代码）
	ini_set (‘memory_limit’, ‘128M’) ;

3、直接取消PHP的内存限制（改代码）
	ini_set ("memory_limit","-1");

值得注意的是：如果通过上面的方式修改后还会报这个错误，那你要检查一下你写的代码是否存在效率问题。（举例：从数据库查询到的数据加载到内存里面，然后php 进行数据处理，如果代码写的不是很严谨存在效率问题，特别是数据量非常大的时候也会导致内存耗尽）

本人遇到这个问题就是因为最开始做公司后台管理系统某个统计功能的时候代码写的不是很严谨，导致后来数据量达到一定量后，出现了内存耗尽。当然咯，自己留的坑最后还得自己填上。本人最终通过重构之前的代码，优化了代码执行效率，解决了内存耗尽问题。
```

## phpExcel导出大量数据出现内存溢出错误的解决方法

```

```



# php-fpm

```
查看php-fpm的master进程号 ：
ps aux|grep php-fpm
netstat -tnl | grep 9000
kill -9 pid

//php-fpm开机启动配置文件
vim /usr/lib/systemd/system/php-fpm.service

#chmod 754 /usr/lib/systemd/system/php-fpm.service
systemctl daemon-reload
systemctl start php-fpm.service
systemctl stop php-fpm.service
systemctl reload php-fpm.service
systemctl enable php-fpm.service
systemctl disable php-fpm.service
systemctl status php-fpm.service -l
//启动php-fpm
/usr/local/php/sbin/php-fpm
```

## php-fpm.conf

```
vim /usr/local/php/etc/php-fpm.conf
pid = /usr/local/php/var/run/php-fpm.pid
```

# 安装

## php7.2.31

```

```
## 扩展安装

```
一些扩展装好后，还会依赖其他扩展，需要配置linux环境变量LD_LIBRARY_PATH(动态库的查找路径)，示例：
LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64::/usr/lib/oracle/11.2/client64/lib:/usr/local/dm7client/bin/:/usr/local/dm7client/drivers/odbc/

vim /usr/local/unixODBC-2.3.1/etc/odbc.ini
[dm]
Description = dm7_dsn
Driver = DM7
SERVER = 172.16.7.55
UID = sysdba
PWD = huitone2214
TCP_PORT = 5236

cat odbcinst.ini
[DM7]
Description = dm_odbc
Driver = /usr/local/dm7client/drivers/odbc/libdodbc.so

```

### PDO_ODBC

```

yum -y install unixODBC-*
-------------------------------第一种：源码安装
wget http://pecl.php.net/get/PDO_ODBC-1.0.1.tgz
tar -zxvf PDO_ODBC-1.0.1.tgz
cd PDO_ODBC-1.0.1
/usr/local/php7.2.31/bin/phpize
./configure --prefix=/usr/local/PDO_ODBC-1.0.1 --with-php-config=/usr/local/php7.2.31/bin/php-config --with-pdo-odbc=unixODBC,/usr
make && make install
-------------------------------第二种：扩展安装
1. 进到扩展目录：
	cd /usr/local/src/php-7.2.31/ext/pdo_odbc
2. 调用phpize程序生成编译配置文件
	/usr/local/php7.2.31/bin/phpize
3. 调用configure生成Makefile文件，然后调用make编译，make install安装
	./configure -with-php-config=/usr/local/php7.2.31/bin/php-config --with-pdo-odbc=unixODBC,/usr
4.编译安装
	make && make install
	ll /usr/local/php7.2.31/lib/php/extensions/no-debug-zts-20170718/
5. 修改php配置文件
	vim /usr/local/php7.2.31/etc/php.ini
	extension=pdo_odbc.so
6.重启apache
	/usr/local/apache2/bin/apachectl stop
	/usr/local/apache2/bin/apachectl start
```

### curl

```
yum install curl curl-devel
1. 进到扩展目录：
	cd /usr/local/src/php-7.2.26/ext/curl
2. 调用phpize程序生成编译配置文件
	/usr/local/php7/bin/phpize
3. 调用configure生成Makefile文件，然后调用make编译，make install安装
	./configure -with-php-config=/usr/local/php7/bin/php-config
4.编译安装
	make && make install
	成功：/usr/local/php7/lib/php/extensions/no-debug-zts-20170718/
5. 修改php配置文件
	vim /usr/local/php7/etc/php.ini
	extension=curl.so
6.重启apache
	/usr/local/apache2/bin/apachectl stop
	/usr/local/apache2/bin/apachectl start
```

### gd库

```
cd /usr/local/src/php-7.2.31/ext/gd
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config  --with-jpeg-dir=/usr/lib64  --with-png-dir=/usr/lib64   --with-freetype-dir=/usr/lib64
```

# 注意事项

## 处理 register_globals 

```
如果已经弃用的 register_globals 指令被设置为 on 那么局部变量也将在脚本的全局作用域中可用。例如， $_POST['foo']   也将以 $foo  的形式存在。 
php.ini
register_globals = On
```

# 语法

```

```

## 变量

```
全局变量和静态变量：
● 全局变量本身就是静态存储方式,所有的全局变量都是静态变量（注：只有局部变量才有静态和自动之分）
	静态变量和自动变量的区别是存储时期的区别：
	1、静态变量的存储时期是内存空间在程序运行期间都存在，程序退出才被释放
	2、自动变量内存空间在作用域内才存在，退出作用域后就被释放
	
一、静态局部变量
1.不会随着函数的调用和退出而发生变化，不过，尽管该变量还继续存在，但不能使用它。倘若再次调用定义它的函数时，它又可继续使用，而且保存了前次被调用后留下的值

2.静态局部变量只会初始化一次

3.静态属性只能被初始化为一个字符值或一个常量，不能使用表达式。即使局部静态变量定义时没有赋初值，系统会自动赋初值0（对数值型变量）或空字符（对字符变量）；静态变量的初始值为0。

4.当多次调用一个函数且要求在调用之间保留某些变量的值时，可考虑采用静态局部变量。虽然用全局变量也可以达到上述目的，但全局变量有时会造成意外的副作用，因此仍以采用局部静态变量为宜。
示例：
function test(){
	static $var = 5;  //static $var = 1+1;就会报错
	$var++;  echo $var . ' ';
}

二、静态全局变量
示例：
//全局变量本身就是静态存储方式,所有的全局变量都是静态变量
function static_global(){
    global $glo;    
    $glo++;    
    echo $glo.'<br>';
}
---------------------------------------差别
global和$GLOBALS除了写法不一样以为,其他都一样,可是在实际应用中发现,2者的区别还是很大的
function test1() { 
    global $v1, $v2; 
    $v2 =& $v1; 
} 
function test2() { 
    $GLOBALS['v3'] =& $GLOBALS['v1']; 
} 
$v1 = 1; 
$v2 = $v3 = 0; 
test1(); 
echo $v2 ."\n"; 
test2(); 
echo $v3 ."\n";

function test() { 
    global $a; 
    unset($a); 
} 
$a = 1; 
test(); 
echo $a;
```

## 取整

```
1.直接取整，舍弃小数，保留整数：intval()；
2.四舍五入取整：round()；
3.向上取整，有小数就加1：ceil()；
4.向下取整：floor()。

一、intval—对变数转成整数型态
    intval如果是字符型的会自动转换为0。
    intval(3.14159);  // 3
    intval(3.64159);  // 3
    intval('ruesin'); //0

二、四舍五入：round()
    根据参数2指定精度将参数1进行四舍五入。参数2可以是负数或零（默认值）。
    round(3.14159);      // 3
    round(3.64159);      // 4
    round(3.64159, 0);   // 4
    round(3.64159, 2);   // 3.64
    round(5.64159, 3);   // 3.642
    round(364159, -2);   // 364200

三、向上取整，有小数就加1：ceil()
    返回不小于 value 的下一个整数，value 如果有小数部分则进一位。
    这个方法，在我们写分页类计算页数时经常会用到。
    ceil(3.14159);  // 4
    ceil(3.64159);  // 4

四、向下取整：floor()
    返回不大于 value 的下一个整数，将 value 的小数部分舍去取整。
    floor(3.14159);    // 3
    floor(3.64159);    // 3
```

## 上传相关参数

```
php.ini 配置对php上传文件大小的影响参数有： 
配置项 可能值 功能描述 
file_uploads ON 确定服务器上的PHP脚本是否可以接受HTTP文件上传 
memory_limit 8M 设置脚本可以分配的最大内存量，防止失控的脚本独占服务器内存 
upload_max_filesize 改为8M 限制PHP处理上传文件的最大值，此值必须小于post_max_size值 

post_max_size 改为16M 限制通过POST方法可以接受的信息最大量

php.ini配置信息可以在前台输入<?php echo phpinfo();?>进行查看php.ini目录信息。

但如果要上传>8M的大体积文件，只设置上述四项还一定能行的通。进一步配置以下的参数 

max_execution_time = 600 ;每个PHP页面运行的最大时间值(秒)，默认30秒 
max_input_time = 600 ;每个PHP页面接收数据所需的最大时间，默认60秒 
memory_limit = 8m ;每个PHP页面所吃掉的最大内存，默认8M 

max_execution_time = 18000
max_input_time = 18000
memory_limit = 2048m
upload_max_filesize = 2000m
post_max_size = 80m

max_file_uploads = 800
```

# session

```
会话过期设置php.ini：
    session.cookie_lifetime = 30 //设为0时永不过期
    session.gc_maxlifetime = 30
    
session 回收机制：
    PHP采用Garbage Collection process对过期session进行回收，然而并不是每次session建立时，都能够唤起 'garbage collection' process ，gc是按照一定概率启动的。这主要是出于对服务器性能方面的考虑，每个session都触发gc，浏览量大的话，服务器吃不消，然而按照一定概率开启gc，当流览量大的时候，session过期机制能够正常运行，而且服务器效率得到节省。细节应该都是多年的经验积累得出的。

三个与PHP session过期相关的参数(php.ini中)：
    session.gc_probability = 1
    session.gc_divisor = 1000
    session.gc_maxlifetime = 1440

gc启动概率 = gc_probability / gc_divisor = 0.1%

session过期时间 gc_maxlifetime 单位：秒



当web服务正式提供时，session过期概率就需要根据web服务的浏览量和服务器的性能来综合考虑session过期概率。为每个session都开启gc，显然是不明智的，感觉有点“碰运气”的感觉，要是访问量小命中几率就小。我在本机测试过程中，几乎都没有被命中过，sessionid几天都不变，哪怕机器重启。测试过程中，这个过期概率值要设置大一点命中几率才高点。

```

# 治理系统

## 添加治理域

```

1、参数配置-公共参数页面新增治理域，从表tb_ua_cfg_biz_domain找到biz_domain_id
2、找到inc_chk\audit_config\adt_role_func.php文件，搜索function getHasSingleCfgByRole关键字，
	修改：select * from tb_ua_cfg_biz_domain a where a.biz_domain_id  in ('1698600','1698601','1700708','1700709','1740679') 
3、治理开发平台-我的治理服务：上线
4、参数配置-权限管理-角色管理：赋权

--  '1698600','1698601','1700708','1700709','1744944'

select distinct C.SERVICE_ID, C.SERVICE_NAME, C.BIZ_DOMAIN, C.SEQU
  from TB_UC_CFG_REPORT           A,
       tb_ua_cfg_sub_service_type B,
       tb_ua_cfg_service_type     C
 where 1 = 1
   and a.sub_service_id = b.sub_service_id
   and a.service_id = c.service_id
   and b.status = 'O'
   and b.ONLINE_STATUS = 'ONLINE'
   and C.BIZ_DOMAIN = 1744944
   
   --select * from TB_UC_CFG_REPORT
   
   select * from tb_ua_cfg_biz_domain where name_cn like ( '主网系统')
   select * from tb_ua_cfg_service_type where biz_domain = (select biz_domain_id from tb_ua_cfg_biz_domain where name_cn like ( '主网系统'))
   select * from tb_ua_cfg_sub_service_type where service_id in (select service_id from tb_ua_cfg_service_type where biz_domain = 1744944)
 
   select * from TB_UC_ROLE_RIGHT where role_id='1000' and uc_rsc_type='SUB_SERVICE' 
   delete TB_UC_ROLE_RIGHT where role_id='1000' and uc_rsc_type='SUB_SERVICE' 
   insert into TB_UC_ROLE_RIGHT(ROLE_RIGHT_ID,ROLE_ID,UC_RSC_TYPE,UC_RSC_ID,RIGHT) 		values(SEQ_UA_TO_CFG.nextval,'1000','SUB_SERVICE',1723201,'EDIT') 
```
## 问题记录

### 生成动态类错误

```
/usr/local/apache2.4/htdocs/inc_chk/RptCustom/tmp 目录权限
```



## 现场部署

```
全局替换：
    172.16.7.55 -> 替换为现场数据库ip
    172.16.7.71 -> 替换为现场清洗接口ip
惠州要求不要公司logo：
    inc_chk/new_index/index.php文件：
        注释：<img src="images/logo.png" />
    inc_chk/login_html.php文件：
        注释：<img src="./app/images/ht-logo.png" class="ht-logo" alt="汇通国信" />
```

