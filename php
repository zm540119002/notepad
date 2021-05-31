
=======================================================单例模式
PHP单例模式的缺点
 众所周知，PHP语言是一种解释型的脚本语言，这种运行机制使得每个PHP页面被解释执行后，所有的相关资源都会被回收。也就是说，PHP在语言级别上没有办法让某个对象常驻内存，这和asp.net、Java等编译型是不同的，比如在Java中单例会一直存在于整个应用程序的生命周期里，变量是跨页面级

的，真正可以做到这个实例在应用程序生命周期中的唯一性。然而在PHP中，所有的变量无论是全局变量还是类的静态成员，都是页面级的，每次页面被执行时，都会重新建立新的对象，都会在页面执行完毕后被清空，这样似乎PHP单例模式就没有什么意义了，所以PHP单例模式我觉得只是针对单次页面

级请求时出现多个应用场景并需要共享同一对象资源时是非常有意义的。

=======================================================
不论在什么平台、用什么web server，只要是用cgi/fastcgi方式运行PHP，都用非线性安全。

这意味着nginx必然配合非线程安全的PHP，IIS则要用线性安全的PHP。Apache有两种运行模式：如果用fastcgi模式，则配合非线性安全PHP，
如果用LoadModule模式，则要用线性安全PHP。后者应该是大多数Apache使用者的选择。
=======================================================
$_SERVER['REQUEST_METHOD']
$_SERVER['REMOTE_ADDR']

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

=======================================================php7.2.31
	wget https://www.php.net/distributions/php-7.2.31.tar.gz
	tar -zvxf php-7.2.31.tar.gz
	cd /usr/local/src/php-7.2.31
--------------------------先装依赖以及扩展库：
yum install gcc gcc-c++ libxml2 libxml2-devel autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel
--------------------------libiconv
cd /usr/local/src
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar -zxvf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/libiconv
make && make install
---------------------------柏维
./configure  --prefix=/usr/local/php7.2.31 \
--exec-prefix=/usr/local/php7.2.31 \
--with-config-file-path=/usr/local/php7.2.31/etc \
--with-apxs2=/usr/local/apache2.4/bin/apxs \
--enable-bcmath \
--enable-mbstring \
--with-gettext \
--enable-fpm \
--enable-shmop \
--enable-soap \
--enable-opcache \
--with-curl \
--disable-debug \
--disable-rpath \
--enable-inline-optimization \
--with-bz2 \
--with-zlib \
--enable-sockets \
--enable-sysvsem \
--enable-sysvshm \
--enable-pcntl \
--enable-mbregex \
--with-mhash \
--with-pcre-regex \
--with-gd \
--with-jpeg-dir \
--with-freetype-dir \
--with-iconv=/usr/local/libiconv \
--enable-calendar  \
--without-pear \
--disable-phar 
--------------------------Please reinstall the libzip distribution:
yum install -y cmake 
wget https://libzip.org/download/libzip-1.5.2.tar.gz
tar -zxf libzip-1.5.2.tar.gz
cd libzip-1.5.2
mkdir build
cd build 
cmake ..
make -j4
make install

提示CMake版本低，需要更高版本。
解决方法：
（1）移除旧版本：
　　yum remove cmake
（2）下载新版本
　　1、下载：curl -O https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.tar.gz
　　2、解压：tar -zxvf cmake-3.6.0-Linux-x86_64.tar.gz
　　　　注意：这个压缩包不是源码包，解压后直接用。
　　3、增加环境变量，使其成为全局变量：
　　　　vim /etc/profile
　　　　在文件末尾处增加以下代码
　　　　export PATH=$PATH:/usr/local/src/cmake-3.6.0-Linux-x86_64/bin
　　　　注意：写自己刚安装cmake的bin的路径
　　　　使修改的文件生效
　　　　source /etc/profile
　　4、查看环境变量：
　　　　echo $PATH
　　5、检查cmake版本：
　　　　cmake --version
装不了，装个低版本的： wget https://nih.at/libzip/libzip-1.2.0.tar.gz
	tar -zxvf libzip-1.2.0.tar.gz
　　cd libzip-1.2.0
　　./configure  --prefix=/usr/local/libzip-1.2.0/
　　make && make install
--------------------------
cd /usr/local/src
wget  http://pear.php.net/go-pear.phar 
/usr/local/bin/php go-pear.phar
--------------------------
./configure --prefix=/usr/local/php-7.2.31/ \
--with-config-file-path=/usr/local/php-7.2.31/etc/ \
--with-apxs2=/usr/local/apache2/bin/apxs/ \
--enable-mbstring \
--without-pear \
--disable-phar \
--------------------------gd库
cd /usr/local/src/php-7.2.31/ext/gd
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config  --with-jpeg-dir=/usr/lib64  --with-png-dir=/usr/lib64   --with-freetype-dir=/usr/lib64
=======================================================php7.4.6
参考：	https://www.ziruchu.com/art/61
cd /usr/local/src
	wget https://cn2.php.net/get/php-7.4.6.tar.bz2/from/this/mirror
1、首先安装依赖
	yum -y install libxml2 libxml2-devel openssl openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel libzip-devel pcre-devel
2、解压
	tar -zxvf php-7.4.6.tar.gz
3、./configure配置参数 （参考： https://www.cnblogs.com/HKUI/p/5137115.html ）
	./configure --prefix=/usr/local/php-7.4.6 \
	--with-config-file-path=/usr/local/php-7.4.6 \
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
------------------------------Requested 'sqlite3 > 3.7.4' but version of SQLite is 3.6.20
sqlite3 --version	查看版本为3.6.30，需升级
wget https://www.sqlite.org/2019/sqlite-autoconf-3270200.tar.gz
tar -zxvf sqlite-autoconf-3270200.tar.gz
cd sqlite-autoconf-3270200
./configure --prefix=/usr/local
make && make install

＃检查版本
## 最新安装的sqlite3版本
[root@localhost /]## /usr/local/bin/sqlite3 --version
3.27.2 2019-02-25 16:06:06 bd49a8271d650fa89e446b42e513b595a717b9212c91dd384aab871fc1d0f6d7
 
## Centos7自带的sqlite3版本
[root@localhost /]# /usr/bin/sqlite3 --version
3.7.17 2013-05-20 00:56:22 118a3b35693b134d56ebd780123b7fd6f1497668
 
## 可以看到sqlite3的版本还是旧版本，那么需要更新一下。
[root@localhost /]# sqlite3 --version
3.7.17 2013-05-20 00:56:22 118a3b35693b134d56ebd780123b7fd6f1497668
 
## 更改旧的sqlite3
[root@localhost /]# mv /usr/bin/sqlite3  /usr/bin/sqlite3_old
 
## 软链接将新的sqlite3设置到/usr/bin目录下
[root@localhost /]# ln -s /usr/local/bin/sqlite3   /usr/bin/sqlite3
 
## 查看当前全局sqlite3的版本
[root@localhost /]# sqlite3 --version
3.27.2 2019-02-25 16:06:06 bd49a8271d650fa89e446b42e513b595a717b9212c91dd384aab871fc1d0f6d7
 
＃将路径传递给共享库
# 设置开机自启动执行，可以将下面的export语句写入 ~/.bashrc 文件中，如果如果你想立即生效，可以执行source ~/.bashrc 将在每次启动终端时执行
[root@localhost /]# export LD_LIBRARY_PATH="/usr/local/lib"
查看：	echo $PKG_CONFIG_PATH 为空
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
若不为空：
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH
------------------------------configure: error: Package requirements (oniguruma) were not met:No package 'oniguruma' found
1、
yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/o/oniguruma-5.9.5-3.el7.x86_64.rpm
yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/o/oniguruma-devel-5.9.5-3.el7.x86_64.rpm
2、使用源代码安装。
git clone https://github.com/kkos/oniguruma
./configure --prefix=/usr/local --libdir=/lib64
make && make install
简单说明：需要有“--libdir=/lib64”参数。如果不使用这个参数，编译PHP仍将报错，编辑ldconfig配置无法解决问题。目前还不清楚问题的缘由。
------------------------------Requires: libc.so.6(GLIBC_2.14)(64bit)
strings /lib64/libc.so.6 | grep GLIBC
wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
tar xf glibc-2.14.tar.gz
cd glibc-2.14
mkdir build
cd build
../configure --prefix=/usr/local/glibc-2.14 --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make && make install

报错：	
	/usr/local/src/glibc-2.14/build/elf/ldconfig: Can't open configuration file /usr/local/glibc-2.14/etc/ld.so.conf: No such file or directory
	make[1]: Leaving directory `/usr/local/src/glibc-2.14'
解决：	将/etc/ld.so.conf文件复制到/usr/local/glibc-2.14/etc/下
	cp /etc/ld.so.conf /usr/local/glibc-2.14/etc/
	cp /etc/ld.so.c* /usr/local/glibc-2.14/etc/
再执行：	make install

安装完成后, 建立软链指向glibc-2.14, 执行如下命令:
rm -rf /lib64/libc.so.6 			// 先删除先前的libc.so.6软链
$ ln -s /usr/local/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6
注意：删除libc.so.6之后可能导致系统命令不可用的情况, 可使用如下方法解决:
LD_PRELOAD=/usr/local/glibc-2.14/lib/libc-2.14.so  ln -s /usr/local/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6
LD_PRELOAD=/lib64/libc-2.12.so ln -s /lib64/libc-2.12.so /lib64/libc.so.6    // libc-2.12.so 此项是系统升级前的版本
------------------------------
下载glibc编译安装，升级
wget http://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz
wget http://ftp.gnu.org/gnu/glibc/glibc-ports-2.14.tar.gz
tar -xvf glibc-2.14.tar.gz
tar -xvf glibc-ports-2.14.tar.gz
mv glibc-ports-2.14 glibc-2.14/ports
cd glibc-2.14
mkdir build
cd build
../configure --prefix=/usr/local/glibc-2.14
make -j4
make install
问题："/root/glibc-2.14/build/elf/ldconfig: Can't open configuration file /usr/local/glibc-2.14/etc/ld.so.conf: No such file or directory"
解决：cp /etc/ld.so.c* /usr/local/glibc-2.14/etc/
rm -rf /lib64/libc.so.6
操作删除软链接后系统无法操作任何命令，我们需要复制下面的命令执行后才可以
LD_PRELOAD=/usr/local/glibc-2.14/lib/libc-2.14.so ln -s /usr/local/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6
ln -s /usr/local/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6
重新检查版本，验证已升级
=======================================================oci8
./configure --with-php-config=/usr/local/php/bin/php-config --with-oci8=shared,instantclient,/root/instantclient_18_3
=======================================================

=======================================================

=======================================================