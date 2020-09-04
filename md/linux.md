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

# 网络

## 基本命令

```
开机启动： chkconfig NetworkManager off|on
开机启动： chkconfig network on|off
网络管理服务： service NetworkManager restart|stop|start
网络服务： service network restart|stop|start|status|reload
```

```
ifconfig
ip
netstat
hostname
ping
traceroute
iproute
```

### ifconfig

```
up（开启）和down（关闭）某个网络接口（网卡）
	示例：	ifconfig eth0 down|up
ifdown （网卡名）
	示例： ifdown eth0
ifup （网卡名）
	示例： ifup eth0
设置网络接口（网卡），例如我们将eth0的IP设置成192.168.1.11，子网衍码设置成255.255.255.0如下：
	示例：	ifconfig eth0 inet 192.168.1.11 netmask 255.255.255.0
	
注意ifdown命令不能再xshell终端中单独用，不然会中断你的连接，如果是跑着业务的服务器就只能让人到机房去启动网卡了。
```

### ip

```
ip命令常用参数
	Ip  [选项]  操作对象{link|addr|route...}
    # ip link show                           # 显示网络接口信息
    # ip link set eth0 upi                   # 开启网卡
    # ip link set eth0 down                  # 关闭网卡
    # ip link set eth0 promisc on            # 开启网卡的混合模式
    # ip link set eth0 promisc offi          # 关闭网卡的混个模式
    # ip link set eth0 txqueuelen 1200       # 设置网卡队列长度
    # ip link set eth0 mtu 1400              # 设置网卡最大传输单元
    # ip addr show                           # 显示网卡IP信息
    # ip addr add 192.168.0.1/24 dev eth0    # 设置eth0网卡IP地址192.168.0.1
    # ip addr del 192.168.0.1/24 dev eth0    # 删除eth0网卡IP地址

    # ip route list                                            # 查看路由信息
    # ip route add 192.168.4.0/24  via  192.168.0.254 dev eth0 # 设置192.168.4.0网段的网关为192.168.0.254,数据走eth0接口
    # ip route add default via  192.168.0.254  dev eth0        # 设置默认网关为192.168.0.254
    # ip route del 192.168.4.0/24                              # 删除192.168.4.0网段的网关
    # ip route del default                                     # 删除默认路由
```



## 基本设置

```
1．网络的基本设置
    我们在设置网络环境的时候，提前要弄清楚以下的相关信息。
    IP IP地址                                                                   
    Netmak 子网掩码
    Gateway 默认网关
    HostName 主机名称
    DomainName 域名
    DNS DNS的IP
2．网络设置文件
    （1）文件 /etc/sysconfig/network
        这个/etc/sysconfig/network文件是定义hostname和是否利用网络的不接触网络设备的对系统全体定义的文件。
        设定形式：设定值=值
        /etc/sysconfig/network的设定项目如下：
        NETWORKING 是否利用网络                                     
        GATEWAY 默认网关
        IPGATEWAYDEV 默认网关的接口名
        HOSTNAME 主机名
        DOMAIN 域名
    （2）文件 /etc/sysconfig/network-scripts/ifcfg-eth0
        /etc/sysconfig/network-scripts在这个目录下面，存放的是网络接口（网卡）的制御脚本文件（控制文件），ifcfg-eth0是默认的第一个网络接口，
        如果机器中有多个网络接口，那么名字就将依此类推ifcfg-eth1,ifcfg-eth2,ifcfg-eth3......（这里面的文件是相当重要的，涉及到网络能否正常工作）
        设定形式：设定值=值
        设定项目项目如下：
        DEVICE 接口名（设备,网卡）
        BOOTPROTO IP的配置方法（static:固定IP， dhcpHCP， none:手动）       
        HWADDR MAC地址
        ONBOOT 系统启动的时候网络接口是否有效（yes/no）
        TYPE 网络类型（通常是Ethemet）
        NETMASK 网络掩码
        IPADDR IP地址
        IPV6INIT IPV6是否有效（yes/no）
        GATEWAY 默认网关IP地址
    （3）文件 /etc/resolv.conf
        这个文件是用来配置主机将用的DNS服务器信息。在这个文件中如果不设置DNS服务器的IP地址，那么在通信的时候，
        将无法指定像 [url=http://www.centospub.comwww.centospub.com[/url[/url]]这样的域名。
        （DNS是Domain Name System的简称，中文名称域名解析服务器，主要是IP和域名转换功能）/etc/resolv.conf的设定项目：
        domain ←定义本地域名
        search ←定义域名和搜索列表
        nameserver←定义被参照的DNS服务器的IP地址（最多可指定3个）
        一般来说最重要的是第三个nameserver项目，没有这项定义，用域名将无法访问网站，并且yum等服务将无法利用
        示例：
            nameserver 202.96.128.86
            nameserver 8.8.8.8
            nameserver 8.8.4.4
    （4）文件 /etc/hosts
        /etc/hosts这个文件是记载LAN内接续的各主机的对应[HostName和IP]用的。在LAN内，我们各个主机间访问通信的时候，用的是内网的IP地址进行访问
        （例：192.168.1.22，192.168.1.23），从而确立连接进行通信。除了通过访问IP来确立通信访问之外，我们还可以通过HostName进行访问，
        我们在安装机器的时候都会给机器起一个名字，这个名字就是这台机器的HostName，通过上图可以看到，HostA的 hostname是centos1，HostB的
        hostname是centos2那我们怎么能不但通过IP确立连接，通过这个IP对应的 HostName进行连接访问呢？解决的办法就是这个/etc/hosts这个文件，
        通过把LAN内的各主机的IP地址和HostName的一一对应写入这个文件的时候，就可以解决问题。
        示例： 
            127.0.0.1		localhost.localdomain localhost
            ::1		localhost6.localdomain6 localhost6
            172.16.6.35     oracle
```



## IPv4

```
Internet上的每台主机(Host)都有一个唯一的IP地址。IP协议就是使用这个地址在主机之间传递信息，这是Internet 能够运行的基础。IP地址的长度为32位(共有2^32个IP地址)，分为4段，每段8位，用十进制数字表示，每段数字范围为0～255，段与段之间用句点隔开。例如159.226.1.1。
IP地址 =  网络标识号码 + 主机标识号码。
因此IP地址可分两部分组成，一部分为网络地址，另一部分为主机地址。
IP地址分为A、B、C、D、E 5类，它们适用的类型分别为：大型网络；中型网络；小型网络；多目地址；备用。常用的是B和C两类。

特殊的网址
1.  “lll0”开始的地址都叫多点广播地址。因此，任何第一个字节大于223小于240的IP地址(范围224.0.0.1-239.255.255.254)是多点广播地址；
2.  每一个字节都为0的地址（“0.0.0.0”）对应于当前主机；
3.  IP地址中的每一个字节都为1的IP地址（“255．255．255．255”）是当前子网的广播地址；
4.  IP地址中凡是以“llll0”开头的E类IP地址都保留用于将来和实验使用。
5.  IP地址中不能以十进制“127”作为开头，该类地址中数字127．0．0．1到127．255．255．255用于回路测试。
     如：127.0.0.1可以代表本机IP地址，用“http://127.0.0.1”就可以测试本机中配置的Web服务器。
6.  网络ID的第一个6位组也不能全置为“0”，全“0”表示本地网络。
```

```
公有地址
公有地址（Public address）由Inter NIC（Internet Network Information Center因特网信息中心）负责。
这些IP地址分配给注册并向Inter NIC提出申请的组织机构。通过它直接访问因特网。
私有地址
私有地址（Private address）属于非注册地址，专门为组织机构内部使用。
以下列出留用的内部私有地址
A类 10.0.0.0--10.255.255.255
B类 172.16.0.0--172.31.255.255
C类 192.168.0.0--192.168.255.255

局域网中的IP
在一个局域网中，有两个IP地址比较特殊，一个是网络号，一个是广播地址。
网络号是用于三层寻址的地址，它代表了整个网络本身；另一个是广播地址，它代表了网络全部的主机。
网络号是网段中的第一个地址，广播地址是网段中的最后一个地址，这两个地址是不能配置在计算机主机上的。
例如在192.168.0.0，255.255.255.0这样的网段中，网络号是192.168.0.0，广播地址是192.168.0.255。因此，在一个局域网中，能配置在计算机中的地址比网段内的地址要少两个（网络号、广播地址），这些地址称之为主机地址。在上面的例子中，主机地址就只有192.168.0.1至192.168.0.254可以配置在计算机上了。
```

```
Netmask

用来指明一个IP地址的哪些位标识的是主机所在的子网以及哪些位标识的是主机的位掩码。子网掩码不能单独存在，它必须结合IP地址一起使用。子网掩码只有一个作用，就是将某个IP地址划分成网络地址和主机地址两部分。

子网掩码的设定必须遵循一定的规则。
与二进制IP地址相同，子网掩码由1和0组成，且1和0分别连续。
子网掩码的长度也是32位，左边是网络位，用二进制数字“1”表示，1的数目等于网络位的长度；右边是主机位，用二进制数字“0”表示，0的数目等于主机位的长度。
这样做的目的是为了让掩码与ip地址做AND运算时用0遮住原主机数，而不改变原网络段数字，而且很容易通过0的位数确定子网的主机数（2的主机位数次方-2，因为主机号全为1时表示该网络广播地址，全为0时表示该网络的网络号，这是两个特殊地址）。
只有通过子网掩码，才能表明一台主机所在的子网与其他子网的关系，使网络正常工作。

对于A类地址来说，默认的子网掩码是255.0.0.0；
对于B类地址来说默认的子网掩码是255. 255.0.0；
对于C类地址来说默认的子网掩码是255.255.255.0。
利用子网掩码可以把大的网络划分成子网即VLSM（可变长子网掩码），也可以把小的网络归并成大的网络即超网。
```

```
Gateway

网关（Gateway）就是一个网络连接到另一个网络的“关口”。
一个用于 TCP/IP 协议的配置项，是一个可直接到达的 IP路由器的 IP 地址。

赋予路由器IP地址的名称,与本地网络连接的机器必须把向外的流量传递到此地址中以超出本地网络,从而使那个地址成为本地子网以外的IP地址的"网关".
也就是最近常用的网关,当主机路由表目或网络输入不存在于本地主机的路由表时数据包发送到那里.

配置默认网关可以在 IP 路由表中创建一个默认路径。 一台主机可以有多个网关。
默认网关的意思是一台主机如果找不到可用的网关，就把数据包发给默认指定的网关，由这个网关来处理数据包。
现在主机使用的网关，一般指的是默认网关。
 一台电脑的默认网关是不可以随随便便指定的，必须正确地指定，否则一台电脑就会将数据包发给不是网关的电脑，从而无法与其他网络的电脑通信。
默认网关的设定有手动设置和自动设置两种方式。

那么网关到底是什么呢？网关实质上是一个网络通向其他网络的IP地址。比如有网络A和网络B，网络A的IP地址范围为“192.168.1.1~192. 168.1.254”，子网掩码为255.255.255.0；网络B的IP地址范围为“192.168.2.1~192.168.2.254”，子网掩码为255.255.255.0。在没有路由器的情况下，两个网络之间是不能进行TCP/IP通信的，即使是两个网络连接在同一台交换机（或集线器）上，TCP/IP协议也会根据子网掩码（255.255.255.0）判定两个网络中的主机处在不同的网络里。而要实现这两个网络之间的通信，则必须通过网关。如果网络A中的主机发现数据包的目的主机不在本地网络中，就把数据包转发给它自己的网关，再由网关转发给网络B的网关，网络B的网关再转发给网络B的某个主机（如附图所示）。网络B向网络A转发数据包的过程也是如此。所以说，只有设置好网关的IP地址，TCP/IP协议才能实现不同网络之间的相互通信。那么这个IP地址是哪台机器的IP地址呢？网关的IP地址是具有路由功能的设备的IP地址，具有路由功能的设备有路由器、启用了路由协议的服务器（实质上相当于一台路由器）、代理服务器（也相当于一台路由器）。
```

## Telnet

```
telnet ip port
```



## IPv6

## **防火墙**

### *iptables*

```
iptables通过控制端口来控制服务，而firewalld则是通过控制协议来控制端口
```

```
# 查看状态
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
/etc/sysconfig/iptables 保存规则的文件；
/etc/sysconfig/iptables-config 向iptables脚本提供配置文件的文件；
```
### *firewall*

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

## ping

### 只能单向ping通的原因

```
1.主机A的防火墙没有关闭，解决方法：执行service iptables stop
2.主机A上有两张或以上的网卡跟主机B在同一网段内，当从这台主机Ping其他的机器时，会存在这样的问题：
（1）主机不知道将数据包发到哪个网络接口，因为有两个网络接口都连接在同一网段；
（2）主机不知道用哪个地址作为数据包的源地址。因此，从这台主机去Ping其他机器，IP层协议会无法处理，超时后，Ping
就会给出一个“超时无应答”的错误信息提示。
```

```
基本的排错步骤（从上往下）
    ping 127.0.0.1 ping的通说明tcp协议栈没有问题
    ping 主机地址 ping的通说明网卡没有问题
    ping 路由器默认网关 ping的通说明包可以到达路由器
    ping DNS服务器地址
```

## ARP

```
arp -a是   显示查看高速缓bai存中的所有项目。arp -d是   人工删du除一zhi个静态项目。

ARP缓存是个用来储存IP地址dao和MAC地址的缓冲区，其本质就是一个IP地址-->MAC地址的对应表，表中每一个条目分别记录了网络上其他主机的IP地址和对应的MAC地址。每一个以太网或令牌环网络适配器都有自己单独的表。

当地址解析协议被询问一个已知IP地址节点的MAC地址时，先在ARP缓存中查看，若存在，就直接返回与之对应的MAC地址，若不存在，才发送ARP请求向局域网查询。

ARP（地址解析协议）地址解析协议，即ARP（Address Resolution Protocol），是根据IP地址获取物理地址的一个TCP/IP协议。

主机发送信息时将包含目标IP地址的ARP请求广播到网络上的所有主机，并接收返回消息，以此确定目标的物理地址；收到返回消息后将该IP地址和物理地址存入本机ARP缓存中并保留一定时间，下次请求时直接查询ARP缓存以节约资源。

地址解析协议是建立在网络中各个主机互相信任的基础上的，网络上的主机可以自主发送ARP应答消息，其他主机收到应答报文时不会检测该报文的真实性就会将其记入本机ARP缓存；

由此攻击者就可以向某一主机发送伪ARP应答报文，使其发送的信息无法到达预期的主机或到达错误的主机，这就构成了一个ARP欺骗。

ARP命令可用于查询本机ARP缓存中IP地址和MAC地址的对应关系、添加或删除静态对应关系等。相关协议有RARP、代理ARP。NDP用于在IPv6中代替地址解析协议。
```

## DNS

```
本地域名解析配置文件： /etc/hosts 
	vim /etc/hosts
配置网卡设备文件添加DNS域名解析服务器地址
    DNS1=114.114.114.114   # 是国内移动、电信和联通通用的DNS
    DNS2=8.8.8.8      # GOOGLE公司提供的DNS,适合国外以及访问国外网站的用户使用
```



# 网卡

## 配置

```
安装ifconfig
	yum install net-tools
	
查看网卡：ifconfig -a

网卡配置文件
	cd /etc/sysconfig/network-scripts/
	vim /etc/sysconfig/network-scripts/网卡
        TYPE=Ethernet    # 网卡类型：为以太网
        PROXY_METHOD=none    # 代理方式：关闭状态
        BROWSER_ONLY=no      # 只是浏览器：否
        BOOTPROTO=dhcp  #设置网卡获得ip地址的方式，可能的选项为static(静态)，dhcp(dhcp协议)或bootp(bootp协议).
        DEFROUTE=yes        # 默认路由：是, 不明白的可以百度关键词 `默认路由`
        IPV4_FAILURE_FATAL=no     # 是不开启IPV4致命错误检测：否
        IPV6INIT=yes         # IPV6是否自动初始化: 是[不会有任何影响, 现在还没用到IPV6]
        IPV6_AUTOCONF=yes    # IPV6是否自动配置：是[不会有任何影响, 现在还没用到IPV6]
        IPV6_DEFROUTE=yes     # IPV6是否可以为默认路由：是[不会有任何影响, 现在还没用到IPV6]
        IPV6_FAILURE_FATAL=no     # 是不开启IPV6致命错误检测：否
        IPV6_ADDR_GEN_MODE=stable-privacy   # IPV6地址生成模型：stable-privacy [这只一种生成IPV6的策略]
        NAME=ens34     # 网卡物理设备名称  
        UUID=8c75c2ba-d363-46d7-9a17-6719934267b7   # 通用唯一识别码，没事不要动它，否则你会后悔的。。
        DEVICE=ens34   # 网卡设备名称, 必须和 `NAME` 值一样
        ONBOOT=no #系统启动时是否设置此网络接口，设置为yes时，系统启动时激活此设备 
        IPADDR=192.168.103.203   #网卡对应的ip地址
        PREFIX=24             # 子网 24就是255.255.255.0
        GATEWAY=192.168.103.1    #网关  
        DNS1=114.114.114.114        # dns
        HWADDR=78:2B:CB:57:28:E5  # mac地址
	示例： vim /etc/sysconfig/network-scripts/ifcfg-eno16777736		
        TYPE="Ethernet"
        BOOTPROTO=none
        DEFROUTE="yes"
        IPV4_FAILURE_FATAL=yes
        IPV6INIT="yes"
        IPV6_AUTOCONF="yes"
        IPV6_DEFROUTE="yes"
        IPV6_FAILURE_FATAL="no"
        NAME="eno16777736"
        UUID="c2569163-eb13-414e-8440-5f947c7917d1"
        ONBOOT="yes"
        HWADDR=00:0C:29:5D:56:36
        IPADDR=172.16.6.35
        PREFIX=24
        GATEWAY=172.16.6.1
        DNS1=202.96.128.86
        IPV6_PEERDNS=yes
        IPV6_PEERROUTES=yes
```



## 虚拟机中三种连接模式

```
1.Bridge模式（桥接模式）
    这种模式是在新建虚拟机的时候默认选择的，是将虚拟主机的虚拟网卡桥接到一个Host主机的物理网卡上面，实际上是将Host主机的物理网卡设置为混杂模式，从而达到侦听多个IP的能力。在这种模式下，虚拟主机的虚拟网卡直接与Host主机的物理网卡所在的网络相连，可以理解为虚拟机和Host主机处于对等的地位，在网络关系上是平等的，没有谁主谁次、谁前谁后之分。

2.NAT模式
    这种模式下Host主机的“网络连接”中会出现了一个虚拟的网卡VMnet8（默认情况下）。如果你做过2000/2003的NAT服务器的实验就会理解：Host主机上的VMnet8虚拟网卡就相当于连接到内网的网卡，Host主机上的物理网卡就相当于连接到外网的网卡，而虚拟机本身则相当于运行在内网上的计算机，虚拟机内的虚拟网卡则独立于Virtual Ethernet Switch（VMnet8）。在这种方式下，VMware自带的DHCP服务会默认地加载到Virtual Ethernet Switch（VMnet8）上，这样虚拟机就可以使用DHCP服务。

3.Host-Only模式
   这种模式是一种封闭的方式，适合在一个独立的环境中进行各种网络实验。这种方式下Host主机的“网络连接”中出现了一个虚拟的网卡VMnet1（默认情况下）。和NAT唯一的不同的是：此种方式下，没有地址转换服务。因此这种情况下，虚拟机只能访问到主机，这也是Host-Only的名字的意义。
```



# **ssh**

```
ssh -p port user@host
```



## 免密登录

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
#  **mysql**

## 启动

```

```



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
