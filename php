=======================================================变量
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
=======================================================
Note: 处理 register_globals 
如果已经弃用的 register_globals 指令被设置为 on 那么局部变量也将在脚本的全局作用域中可用。例如， $_POST['foo']   也将以 $foo  的形式存在。 
php.ini
register_globals = On
=======================================================拒绝访问目录
apache:
找到配置文件，把#Options Indexes FollowSymLinks 注释掉，设置为：Options FollowSymLinks
header("Content-type: text/html; charset=utf-8");
header("Content-type: text/html; charset=gb2312");
//跨域
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: token,Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: POST,GET');
=======================================================php开启调试模式
如果服务器关闭了php服务的错误提示，而又需要对某个php文件进行调试，可以在文件中加入如下代码：
ini_set('display_errors', true);
error_reporting(E_ALL);
=======================================================
不论在什么平台、用什么web server，只要是用cgi/fastcgi方式运行PHP，都用非线性安全。

这意味着nginx必然配合非线程安全的PHP，IIS则要用线性安全的PHP。Apache有两种运行模式：如果用fastcgi模式，则配合非线性安全PHP，
如果用LoadModule模式，则要用线性安全PHP。后者应该是大多数Apache使用者的选择。
=======================================================
$_SERVER['REQUEST_METHOD']
$_SERVER['REMOTE_ADDR']
=======================================================
查看php-fpm的master进程号 ：
ps aux|grep php-fpm
netstat -tnl | grep 9000
kill -9 pid
=======================================================
//php-fpm配置文件
vim /usr/local/php/etc/php-fpm.conf
pid = /usr/local/php/var/run/php-fpm.pid
=======================================================
//php-fpm开机启动配置文件
vim /usr/lib/systemd/system/php-fpm.service
=======================================================
[Unit]
Description=The PHP FastCGI Process Manager
After=network.target

[Service]
Type=simple
PIDFile=/usr/local/php/var/run/php-fpm.pid 
ExecStart=/usr/local/php/sbin/php-fpm --nodaemonize
--fpm-config=/usr/local/php/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -SIGINT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
=======================================================
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
=======================================================
下面以代码说明PHP中去除字符串中换行的三种常用的方法

复制代码
// 1)使用转义字符函数
<?php
$str = str_replace(array("/r/n", "/r", "/n"), '', $str);
?>
// 2)使用正则表达式替换
<?php
$str = preg_replace('//s*/', '', $str);
?>
// 3)使用PHP系统常量【推荐】
$str = str_replace(PHP_EOL, '', $str);
?>
复制代码
=======================================================
// 二进制转十进制
$_POST['belong_to'] = bindec(strrev(implode(input('post.belong_to/a'))));
// 十进制转二进制
$goodsInfo['belong_to'] = strrev(decbin($goodsInfo['belong_to']));
=======================================================
vue-resource发送了一个post请求，在后台$_POST都获取不到数据
研究完参数 发现参数是通过payload json方式传递的,  这种方式是没有办法从$_POST中获取的,
只有x-www-form-data multipart/form-data 这两种形式的payload才会填充$_POST, 而application/json则填充 php://input
$request_body = file_get_contents('php://input');
$data = json_decode($request_body, true);
=======================================================
function iconvKey($arr){
    $res = array();
    foreach ($arr as $value){
        $temp = array();
        foreach ($value as $k=>$v){
            $k = iconv("GBK","UTF-8",$k);
            $temp[$k] = $v;
        }
        $res[] = $temp;
    }
    return $res;
}
=======================================================
// 说明：获取完整URL
function curPageURL() {
	$pageURL = 'http';
	if ($_SERVER["HTTPS"] == "on"){
		$pageURL .= "s";
	}
	$pageURL .= "://";
	if ($_SERVER["SERVER_PORT"] != "80") {
		$pageURL .= $_SERVER["SERVER_NAME"] . ":" . $_SERVER["SERVER_PORT"] . $_SERVER["REQUEST_URI"];
	}
	else{
		$pageURL .= $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"];
	}
	return $pageURL;
}
==========================================================================================================================================5.2.17
	https://www.cnblogs.com/ahwu/p/4873654.html
	wget http://museum.php.net/php5/php-5.2.17.tar.gz
	tar zxf php-5.2.17.tar.gz
./configure \
  --prefix=/usr/share/php52 \
  --datadir=/usr/share/php52 \
  --mandir=/usr/share/man \
  --bindir=/usr/bin/php52 \
  --with-libdir=lib64 \
  --includedir=/usr/include \
  --sysconfdir=/etc/php52/apache2 \
  --with-config-file-path=/etc/php52/cli \
  --with-config-file-scan-dir=/etc/php52/conf.d \
  --localstatedir=/var \
  --disable-debug \
  --with-regex=php \
  --disable-rpath \
  --disable-static \
  --disable-posix \
  --with-pic \
  --with-layout=GNU \
  --with-pear=/usr/share/php \
  --enable-calendar \
  --enable-sysvsem \
  --enable-sysvshm \
  --enable-sysvmsg \
  --enable-bcmath \
  --with-bz2 \
  --enable-ctype \
  --with-db4 \
  --without-gdbm \
  --with-iconv \
  --enable-exif \
  --enable-ftp \
  --enable-cli \
  --with-gettext \
  --enable-mbstring \
  --with-pcre-regex=/usr \
  --enable-shmop \
  --enable-sockets \
  --enable-wddx \
  --with-libxml-dir=/usr \
  --with-zlib \
  --with-kerberos=/usr \
  --with-openssl=/usr \
  --enable-soap \
  --enable-zip \
  --with-mhash \
  --with-exec-dir=/usr/lib/php5/libexec \
  --without-mm \
  --with-curl=shared,/usr \
  --with-zlib-dir=/usr \
  --with-gd=shared,/usr \
  --enable-gd-native-ttf \
  --with-gmp=shared,/usr \
  --with-jpeg-dir=shared,/usr \
  --with-xpm-dir=shared,/usr/X11R6 \
  --with-png-dir=shared,/usr \
  --with-freetype-dir=shared,/usr \
  --with-ttf=shared,/usr \
  --with-t1lib=shared,/usr \
  --with-ldap=shared,/usr \
  --with-mysql=shared,/usr \
  --with-mysqli=shared,/usr/bin/mysql_config \
  --with-pgsql=shared,/usr \
  --with-pspell=shared,/usr \
  --with-unixODBC=shared,/usr \
  --with-xsl=shared,/usr \
  --with-snmp=shared,/usr \
  --with-sqlite=shared,/usr \
  --with-tidy=shared,/usr \
  --with-xmlrpc=shared \
  --enable-pdo=shared \
  --without-pdo-dblib \
  --with-pdo-mysql=shared,/usr \
  --with-pdo-pgsql=shared,/usr \
  --with-pdo-odbc=shared,unixODBC,/usr \
  --with-pdo-dblib=shared,/usr \
  --enable-force-cgi-redirect  --enable-fastcgi \
  --with-libdir=/lib/x86_64-linux-gnu \
  --with-pdo-sqlite=shared \
  --with-sqlite=shared \
  --enable-ipv6 \
  --with-mcrypt \
  --with-imap-ssl
==========================================================================================================================================php7
 yum install -y gcc gcc-c++  make zlib zlib-devel pcre pcre-devel  libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers -y
 
 ./configure --prefix=/usr/local/php \
 --with-config-file-path=/usr/local/php \
 --with-apxs2=/usr/local/apache2/bin/apxs \
 --enable-mbstring \
 --with-openssl \
 --enable-ftp \
 --with-gd \
 --with-jpeg-dir=/usr \
 --with-png-dir=/usr \
 --with-mysql=mysqlnd \
 --with-mysqli=mysqlnd \
 --with-pdo-mysql=mysqlnd \
 --with-pear \
 --enable-sockets \
 --with-freetype-dir=/usr\
 --with-libxml-dir=/usr \
 --with-xmlrpc \
 --enable-zip \
 --enable-fpm \
 --enable-xml \
 --with-zlib \
 --with-iconv \
 --enable-soap \
 --enable-pcntl \
 --enable-cli \
 --with-curl
==========================================================================================================================================
	wget http://hk1.php.net/get/php-7.2.3.tar.gz/from/this/mirror
	tar -zxvf mirror
cd php-7.1.31
./configure 
--prefix=/usr/local/php 
--with-config-file-path=/usr/local/php/etc
--enable-mbstring 
--enable-ftp 
--with-gd 
--with-jpeg-dir=/usr 
--with-png-dir=/usr 
--with-mysql=mysqlnd 
--with-mysqli=mysqlnd 
--with-pdo-mysql=mysqlnd 
--without-pear 
--disable-phar 
--enable-sockets 
--with-freetype-dir=/usr 
--with-zlib 
--with-libxml-dir=/usr 
--with-xmlrpc 
--enable-zip 
--enable-fpm 
--enable-xml 
--with-iconv 
--enable-soap 
--enable-pcntl 
--enable-cli 
--with-curl

==========================================================================================================================================pdo_oci扩展
./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-oci=instantclient,/root/instantclient_18_3,11.2.0
==========================================================================================================================================oci8
./configure --with-php-config=/usr/local/php/bin/php-config --with-oci8=shared,instantclient,/root/instantclient_18_3
==========================================================================================================================================