# **常用**

```
chkconfig --list       			# 列出所有系统服务
chkconfig --list | grep on    	# 列出所有启动的系统服务
rpm -qal  | grep httpd        	# 查看apache安装的软件包
ps -ef|grep http				# 查看进程
whereis oracle					# 查看文件安装路径
which oracle					# 查询运行文件所在路径
netstat -an | grep LISTEN 		# 查看监听端口
cat /etc/services 				# 查看所有服务默认的端口列表信息
```

# **iptables&firewall**

## *iptables*

```
# 查看防火墙状态
	service iptables status  
# 停止防火墙
	service iptables stop  
# 启动防火墙
	service iptables start  
# 重启防火墙
	service iptables restart  
# 永久关闭防火墙
	chkconfig iptables off  
# 永久关闭后重启
	chkconfig iptables on　　
```

```
编辑配置文件：
	vim /etc/sysconfig/iptables
在文件中间添加iptables规则：
	-A INPUT -p tcp -m state --state NEW -m tcp --dport 27017 -j ACCEPT
重启防火墙：
	service iptables restart
关闭iptables规则：
	iptables -F && iptables -t nat -F
```
## *firewall*

```
1、查看firewall服务状态

systemctl status firewalld

出现Active: active (running)切高亮显示则表示是启动状态。

出现 Active: inactive (dead)灰色表示停止，看单词也行。
2、查看firewall的状态

firewall-cmd --state
3、开启、重启、关闭、firewalld.service服务

# 开启
service firewalld start
# 重启
service firewalld restart
# 关闭
service firewalld stop
4、查看防火墙规则

firewall-cmd --list-all
5、查询、开放、关闭端口

# 查询端口是否开放
firewall-cmd --query-port=8080/tcp
# 开放80端口
firewall-cmd --permanent --add-port=80/tcp
# 移除端口
firewall-cmd --permanent --remove-port=8080/tcp
#重启防火墙(修改配置后要重启防火墙)
firewall-cmd --reload

# 参数解释
1、firwall-cmd：是Linux提供的操作firewall的一个工具；
2、--permanent：表示设置为持久；
3、--add-port：标识添加的端口；
```



# **ssh 免密登录**

```
1、登录A机器 
2、ssh-keygen -t [rsa|dsa]，将会（在当前用户目录下）生成公钥文件（id_rsa.pub）和私钥文件 （id_rsa）
3、将 .pub 文件复制到B机器的 .ssh 目录， 并 ssh-copy-id -i ~/.ssh/id_rsa.pub  git@meishangyun.com （如果服务器git用户主目录下没有.ssh/authorized_keys 文件的话手动建立）
4、大功告成，从A机器登录B机器的目标账户，不再需要密码了；
如果希望ssh公钥生效需满足至少下面两个条件：
1) .ssh目录的权限必须是700
2) .ssh/authorized_keys文件权限必须是600
示例：
方法一：
root 登陆到172.16.6.35
cd ~/.ssh
touch authorized_keys
chmod 600 authorized_keys
vim authorized_keys
添加其他机器~/.ssh下的id_rsa.pub的内容
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfn+AXJHXAv7y3VFOpfGCWX2Wlst5MJRq9eQ8bfuHiy8dBM38i3p3GW7T68VDMMVpWVv8gvJKMdcnYGMAgDbHPPUNGwjQgM1VadbqO69EX+j92uNm5IQitupzG+XiXFRLTNMpAGbdA5zt8eMj/XT8xXa3J+7Gnw85zltbextDl6ji0gljJSuJ3qz/AKNKomjXHA1cDsJSypz1a0b+fJP5V/xr5wd1DQTzJcVRV3SwdP43kEscht/2Hpb3ZrpSycih1Idx4OzNsN6HEaGJx0kGO3/OwkcRFIJugvdWAUdv00mpKymwtuiuQWG2c0UAPy3jddpla8MKJ6XTHXJtRXzxZ lqh@huitone.com
方法二：
ssh-copy-id -i ~/.ssh/id_rsa.pub root@172.16.6.35
```
# 文件操作

## **mkdir**

```
1、当存在文件下仅存在单一目录时：  
	mkdir -p /wendang/a/b

2、当存在一个目录下有多个目录时：
 	mkdir -p /wendang/{a,b,c}/d

#此时会在a,b,c这三个文件下分别创建d文件
```
##  **tar**

```
压缩：	tar -czvf FileName.tar.gz DirName
解压：	tar -xzvf FileName.tar.gz -C /usr/local #-C 选项的作用是：指定需要解压到的目录。
示例： 
```
####  ****

```

```
####  ****

```

```
####  ****

```

```
####  ****

```

```
####  ****

```

```
####  ****

```

```
