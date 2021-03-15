

```
chkconfig --list       			# 列出所有系统服务
chkconfig --list | grep on    	# 列出所有启动的系统服务
rpm -qal  | grep httpd        	# 查看apache安装的软件包
ps -ef|grep http				# 查看进程
whereis oracle					# 查看文件安装路径
which oracle					# 查询运行文件所在路径
netstat -an | grep LISTEN 		# 查看监听端口
cat /etc/services 				# 查看所有服务默认的端口列表信息
vmstat 10
top
free -m
```

```
yum list all|grep nginx
yum list all mysql*

只显示已安装的包。
	命令：yum list installed
只显示没有安装，但可安装的包。
	命令：yum list available
查看所有可更新的包。
	命令：yum list updates
显示不属于任何仓库的，额外的包。
	命令：yum list extras
显示被废弃的包
	命令：yum list obsoletes
新添加进yum仓库的包
	命令：yum list recent
```



# 网络

## **概念解析**

### 配置文件

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



### 虚拟机中三种连接模式

```
1.Bridge模式（桥接模式）
    这种模式是在新建虚拟机的时候默认选择的，是将虚拟主机的虚拟网卡桥接到一个Host主机的物理网卡上面，实际上是将Host主机的物理网卡设置为混杂模式，从而达到侦听多个IP的能力。在这种模式下，虚拟主机的虚拟网卡直接与Host主机的物理网卡所在的网络相连，可以理解为虚拟机和Host主机处于对等的地位，在网络关系上是平等的，没有谁主谁次、谁前谁后之分。

2.NAT模式
    这种模式下Host主机的“网络连接”中会出现了一个虚拟的网卡VMnet8（默认情况下）。如果你做过2000/2003的NAT服务器的实验就会理解：Host主机上的VMnet8虚拟网卡就相当于连接到内网的网卡，Host主机上的物理网卡就相当于连接到外网的网卡，而虚拟机本身则相当于运行在内网上的计算机，虚拟机内的虚拟网卡则独立于Virtual Ethernet Switch（VMnet8）。在这种方式下，VMware自带的DHCP服务会默认地加载到Virtual Ethernet Switch（VMnet8）上，这样虚拟机就可以使用DHCP服务。

3.Host-Only模式
   这种模式是一种封闭的方式，适合在一个独立的环境中进行各种网络实验。这种方式下Host主机的“网络连接”中出现了一个虚拟的网卡VMnet1（默认情况下）。和NAT唯一的不同的是：此种方式下，没有地址转换服务。因此这种情况下，虚拟机只能访问到主机，这也是Host-Only的名字的意义。
```

### IPv4

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

### Netmask

```
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

### Gateway

```
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

### ARP

```
arp -a是   显示查看高速缓存中的所有项目。arp -d是   人工删du除一zhi个静态项目。

ARP缓存是个用来储存IP地址和MAC地址的缓冲区，其本质就是一个IP地址-->MAC地址的对应表，表中每一个条目分别记录了网络上其他主机的IP地址和对应的MAC地址。每一个以太网或令牌环网络适配器都有自己单独的表。

当地址解析协议被询问一个已知IP地址节点的MAC地址时，先在ARP缓存中查看，若存在，就直接返回与之对应的MAC地址，若不存在，才发送ARP请求向局域网查询。

ARP（地址解析协议）地址解析协议，即ARP（Address Resolution Protocol），是根据IP地址获取物理地址的一个TCP/IP协议。

主机发送信息时将包含目标IP地址的ARP请求广播到网络上的所有主机，并接收返回消息，以此确定目标的物理地址；收到返回消息后将该IP地址和物理地址存入本机ARP缓存中并保留一定时间，下次请求时直接查询ARP缓存以节约资源。

地址解析协议是建立在网络中各个主机互相信任的基础上的，网络上的主机可以自主发送ARP应答消息，其他主机收到应答报文时不会检测该报文的真实性就会将其记入本机ARP缓存；

由此攻击者就可以向某一主机发送伪ARP应答报文，使其发送的信息无法到达预期的主机或到达错误的主机，这就构成了一个ARP欺骗。

ARP命令可用于查询本机ARP缓存中IP地址和MAC地址的对应关系、添加或删除静态对应关系等。相关协议有RARP、代理ARP。NDP用于在IPv6中代替地址解析协议。
```

### DNS

```
系统会首先自动从Hosts文件中寻找对应的IP地址：
	vim /etc/hosts
	10.10.10.10 www.a.com
域名如果在hosts中找不到对应的IP，会访问此文件寻找域名解析服务器。
	vim /etc/resolv.conf
	nameserver x.x.x.x  #该选项用来制定DNS服务器的，可以配置多个nameserver指定多个DNS。
配置网卡设备文件添加DNS域名解析服务器地址
    nameserver=114.114.114.114   # 是国内移动、电信和联通通用的DNS
    nameserver=8.8.8.8      # GOOGLE公司提供的DNS,适合国外以及访问国外网站的用户使用
```

### DNS反向解析

```

```



## 常用命令

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

## 常见问题

### 只能单向ping通的原因

```
1.主机A的防火墙没有关闭，解决方法：执行service iptables stop
2.主机A上有两张或以上的网卡跟主机B在同一网段内，当从这台主机Ping其他的机器时，会存在这样的问题：
	（1）主机不知道将数据包发到哪个网络接口，因为有两个网络接口都连接在同一网段；
    （2）主机不知道用哪个地址作为数据包的源地址。因此，从这台主机去Ping其他机器，IP层协议会无法处理，超时后，Ping就会给出一个“超时无应答”的错误信息提示。
```

```
基本的排错步骤（从上往下）
    ping 127.0.0.1 ping的通说明tcp协议栈没有问题
    ping 主机地址 ping的通说明网卡没有问题
    ping 路由器默认网关 ping的通说明包可以到达路由器
    ping DNS服务器地址
```



## 网卡

### 配置

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

# 常用命令

```
netstat -anp|grep LIS
ls -lrt /proc/14720
ps -ef|grep 14720
```

## 查看Linux系统

```
cat /proc/version
uname -a
uname -r
lsb_release -a（适用于所有的Linux发行版本），有些系统中默认并没有安装lsb_release，需要进行安装，以CentOS为例：
    首先查找lsb_release安装包：	yum provides lsb_release
    安装：	yum install -y redhat-lsb-core
    
CentOS版本信息：
	cat /proc/version
	uname -a
	cat /etc/issue
	cat /etc/redhat-release
	cat  /etc/*release*

查看系统是64位还是32位:
	getconf LONG_BIT
查看cpu相关信息，包括型号、主频、内核信息等
	cat /proc/cpuinfo
查看端口：
	netstat -anp | grep portno
	示例：
	查看监听端口：	netstat -anp | grep LISTEN
	查看php-fpm是否启动了：	netstat -nlp|grep php-fpm
查看用户：		cat /etc/passwd
查看用户组：  	cat /etc/group
查看用户所属组：groups user1
查看服务：
	chkconfig --list       			# 列出所有系统服务
	chkconfig --list | grep on    	# 列出所有启动的系统服务
查看运行用户信息：
	ps -ef|grep http
查看进程号：	pgrep php-fpm
追踪进程号：	strace -f -e connect  -p 你的进程编号
```

## service、systemctl 和 chkconfig

```
1.service命令其实是去/etc/init.d目录下，去执行相关程序
	# 启动、停止、重启服务等
		service redis start|stop|restart|reload(重新加载配置文件,不终止服务)|status
	# 直接启动redis脚本
		/etc/init.d/redis start
	# 开机自启动
		update-rc.d redis defaults

systemd是Linux系统最新的初始化系统(init),作用是提高系统的启动速度，尽可能启动较少的进程，尽可能更多进程并发启动。
systemd对应的进程管理命令是systemctl
2. systemctl命令兼容了service，即systemctl也会去/etc/init.d目录下，查看，执行相关程序
	# 启动、停止、重启服务等
		systemctl start|stop|restart|reload(重新加载配置文件,不终止服务)|status redis
	# 开机自启动 
		systemctl enable|disable redis
	# 检查某个单元是否启动
		systemctl is-enabled httpd.service 
	# 查询服务是否激活，和配置是否开机启动
		systemctl is-active httpd
	
区别：
	systemctl命令：是一个systemd工具，主要负责控制systemd系统和服务管理器。
    service命令：可以启动、停止、重新启动和关闭系统服务，还可以显示所有系统服务的当前状态。
    chkconfig命令：是管理系统服务(service)的命令行工具。所谓系统服务(service)，就是随系统启动而启动，随系统关闭而关闭的程序。
    systemctl命令是系统服务管理器指令，它实际上将 service 和 chkconfig 这两个命令组合到一起。

    systemctl是RHEL 7 的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。可以使用它永久性或只在当前会话中启用/禁用服务。

    所以systemctl命令是service命令和chkconfig命令的集合和代替。
```

## cpu

```
/*CPU
查看CPU型号*/
	cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

/*查看物理CPU个数*/
	cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l  

/*查看逻辑CPU个数*/
	cat /proc/cpuinfo | grep "processor" | wc -l  

/*查看CPU内核数*/
	cat /proc/cpuinfo | grep "cpu cores" | uniq  

/*查看单个物理CPU封装的逻辑CPU数量*/
	cat /proc/cpuinfo | grep "siblings" | uniq  

/*计算是否开启超线程
##逻辑CPU > 物理CPU x CPU核数 #开启超线程
##逻辑CPU = 物理CPU x CPU核数 #没有开启超线程或不支持超线程*/

/*查看是否超线程,如果cpu cores数量和siblings数量一致，则没有启用超线程，否则超线程被启用。*/
	cat /proc/cpuinfo | grep -e "cpu cores"  -e "siblings" | sort | uniq


/*查看进程相关信息占用的内存情况，(进程号可以通过ps查看)如下所示：*/
    pmap -d 14596
    ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' 
    ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | grep postgres |  sort -nrk5
/*其中rsz为实际内存，上例实现按内存排序，由大到小*/

/*查看IO情况*/
	iostat -x 1 10
/*
如果 iostat 没有，要 yum install sysstat安装这个包，第一眼看下图红色圈圈的那个如果%util接近100%,表明I/O请求太多,I/O系统已经满负荷，磁盘可能存在瓶颈,一般%util大于70%,I/O压力就比较大，读取速度有较多的wait，然后再看其他的参数，
内容解释:
rrqm/s:每秒进行merge的读操作数目。即delta(rmerge)/s 
wrqm/s:每秒进行merge的写操作数目。即delta(wmerge)/s 
r/s:每秒完成的读I/O设备次数。即delta(rio)/s 
w/s:每秒完成的写I/0设备次数。即delta(wio)/s 
rsec/s:每秒读扇区数。即delta(rsect)/s 
wsec/s:每秒写扇区数。即delta(wsect)/s 
rKB/s:每秒读K字节数。是rsec/s的一半，因为每扇区大小为512字节 

wKB/s:每秒写K字节数。是wsec/s的一半 
avgrq-sz:平均每次设备I/O操作的数据大小(扇区)。即delta(rsect+wsect)/delta(rio+wio) 
avgqu-sz:平均I/O队列长度。即delta(aveq)/s/1000(因为aveq的单位为毫秒) 
await:平均每次设备I/O操作的等待时间(毫秒)。即delta(ruse+wuse)/delta(rio+wio) 
svctm:平均每次设备I/O操作的服务时间(毫秒)。即delta(use)/delta(rio+wio) 
%util:一秒中有百分之多少的时间用于I/O操作,或者说一秒中有多少时间I/O队列是非空的

*/
/*找到对应进程*/
ll /proc/进程号/exe
```



## 进程

```
查看内存占用前五的进程：   ps auxw | head -1;ps auxw|sort -rn -k4|head -5
查看CPU占用前三的进程：	 ps auxw | head -1;ps auxw|sort -rn -k3|head -3
```

## 内存

```
free -m
echo 3 > /proc/sys/vm/drop_caches 

TOP
/*命令经常用来监控linux的系统状况，比如cpu、内存的使用等。*/
/*查看某个用户内存使用情况,如:postgres*/
	top -u postgres
/*
内容解释：

　　PID：进程的ID
　　USER：进程所有者
　　PR：进程的优先级别，越小越优先被执行
　　NInice：值
　　VIRT：进程占用的虚拟内存
　　RES：进程占用的物理内存
　　SHR：进程使用的共享内存
　　S：进程的状态。S表示休眠，R表示正在运行，Z表示僵死状态，N表示该进程优先值为负数
　　%CPU：进程占用CPU的使用率
　　%MEM：进程使用的物理内存和总内存的百分比
　　TIME+：该进程启动后占用的总的CPU时间，即占用CPU使用时间的累加值。
　　COMMAND：进程启动命令名称

常用的命令：

　　P：按%CPU使用率排行
　　T：按MITE+排行
　　M：按%MEM排行
```

## 环境变量

```
-------------------------------------
1、查看某一个环境变量（PATH）
     echo $PATH
	 env|grep PATH
2、查看所有的环境变量
    env
-------------------------------------
1、当前shell有效，临时设置
	# PATH=$PATH:/usr/local/php7/bin
	使用这种方法,只对当前会话有效，也就是说每当登出或注销系统以后，PATH设置就会失效。
2、所有用户有效
	# vim /etc/profile
	export PATH="$PATH:/usr/local/php7/bin"
	使环境变量生效：
	# source /etc/profile
	注：＝ 等号两边不能有任何空格。这种方法最好，除非手动强制修改PATH的值,否则将不会被改变。
3、当前用户有效
	# vim ~/.bash_profile
	export PATH="$PATH:/usr/local/php7/bin"
	使环境变量生效：
	# source ~/.bash_profile
-------------------------------------
 ~/.bashrc			当前用户有效
/etc/bashrc			所有用户有效
/etc/environment	所有用户有效
-------------------------------------LD_LIBRARY_PATH
env|grep LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/dm7client/bin/:/usr/local/dm7client/drivers/odbc/
-------------------------------------PATH

LANG是针对Linux系统的语言、地区、字符集的设置,对linux下的应用程序有效，如date；NLS_LANG是针对Oracle语言、地区、字符集的设置，对oracle中的工具有效
```

## 磁盘

```
1、查看未挂载磁盘命令：
	fdisk -l |grep '/dev'
2、查看磁盘挂载情况：
	df -h
3、挂载命令：
	mount /dev/sdb1 /home   #将磁盘sdb1挂载到/home文件夹上
4、卸载命令：
	umount /dev/sdb1    #卸载磁盘sdb1

/*看硬盘占用率*/
df -h
df -hl 查看磁盘剩余空间
du -sh [目录名] 返回该目录的大小
du -sm [文件夹] 返回该文件夹总M数
du -h [目录名] 查看指定文件夹下的所有文件大小（包含子文件夹）
查看硬盘的分区 #sudo fdisk -l
查看IDE硬盘信息 #sudo hdparm -i /dev/hda
查看STAT硬盘信息 #sudo hdparm -I /dev/sda 或 #sudo apt-get install blktool #sudo blktool /dev/sda id
查看硬盘剩余空间 #df -h #df -H
查看目录占用空间 #du -hs 目录名
优盘没法卸载 #sync fuser -km /media/usbdisk

du -sh *
du -sh /var/* | sort -nr
du -sm *|grep -n


简介
lsblk可以看成是“List block device”的缩写，即列为出所有存储设备。

```

## date

```
date : 查看当前日期
date -R ： 查看当前时区

查看硬件时间（BIOS的）：
    hwclock [-rw]
    -r:查看现有BIOS时间，默认为－r参数
    -w:将现在的linux系统时间写入BIOS中
    注：当我们进行完 Linux 时间的校时后，还需要以 hwclock -w 来更新 BIOS 的时间，因为每次开机的时候，系统会重新由 BIOS 将时间读出来，所以BIOS 才是重要的时间依据。

修改Linux系统当前时间。

1.不修改年的情况：
命令： date 月日时分.秒    --注意每个单位都是两位数，例如 date 05241636.00

2.修改年月日：
命令： date -s "年/月/日"  或  date -s "年-月-日"   --例如 date -s "2018-05-24"

3.修改时分秒：
命令： date -s  时:分:秒   --例如： date -s "16:36:00"

4.修改全部：
命令： date -s "年-月-日 时:分:秒"    --例如：date -s "2020-12-10 14:57:00"

修改之后如果不能正常生效的话就在修改完时间之后再输入：clock -w  就把当前时间修改到系统配置当中，不会再跳回之间的时间了。

同步网络时间
yum install -y ntpdate
ntpdate -u 210.72.145.44 #210.72.145.44：中国国家授时中心的官方服务器。
ntpdate -u ntp.api.bz
```

## **I/O重定向**

```
标准输入 (stdin): 代码为0，使用<或<<
标准输出 (stdout): 代码为1，使用>或>>
标准错误输出(stderr): 代码为2，使用2>或2>>
0,1,2对应的物理设备一般是 ： 键盘、显示器、显示器

>: 覆盖输出 
>>：追加输出

# set -C  禁止对已经存在文件使用覆盖重定向；强制覆盖输出，则使用 >|
# set +C  关闭上述功能

2>: 重定向错误输出
2>>: 追加方式

将正确的与错误的分别存入不同的文件中
# ls / /varr > /tmp/var3.out 2> /tmp/err.out
# ls /varr > /tmp/var4.out 2> /tmp/var4.out
        
/dev/null垃圾桶黑洞装置
&>: 重定向标准输出或错误输出至同一个文件(或者2>&1)

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：
$ command > file 2>&1
或者
$ command >> file 2>&1
```

## 端口

```
1.查找被占用的端口
    netstat -tln  
    netstat -tln | grep 9090
    netstat -tln 查看端口使用情况，而netstat -tln | grep 8083 则是只查看端口8083的使用情况
2.查看端口属于哪个程序？端口被哪个进程占用
	lsof -i :9090 
3.杀掉占用端口的进程
	kill -9 进程id 
	kill -9 $(lsof -i:9090 -t)

netstat查看端口占用情况
	netstat -anp | grep 9090
```



## **管道**

```
管道是将前一个命令的输出作为后一个命令的输入
```

## ulimit

```
ulimit -n
ulimit -a
注意：
    root用户没有限制
    当前会话只能降
```

## lsof

```
查看当前系统打开的文件数量: 
	lsof | wc -l  
	lsof -n|grep dev|wc
	
查看当前进程的打开文件数量：
	lsof -p pid | wc -l      （lsof -p 1234 | wc -l  ）

查看当前进程的最大可以打开的文件数：
	cat /proc/PID/limits 
    (如果通过ulimit -n 设置或者修改/etc/security/limits.conf，看看进程是否生效)  

查看系统总限制打开文件的最大数量：
	cat /proc/sys/fs/file-max

lsof只能以root权限执行。
在终端下输入lsof即可显示系统打开的文件,因为 lsof 需要访问核心内存和各种文件,所以必须以 root 用户的身份运行它才能够充分地发挥其功能。
```



# 常用工具

## **ssh**

```
ssh -p port user@host
sevice ssh start|stop|restart|status

ssh -V
openssl version

安装SSH：yum install ssh
启动SSH： service sshd start
设置开机运行： chkconfig sshd on

SSH 服务配置文件位置
/etc/ssh/sshd_config
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
## ftp & sftp

```
1、检查是否安装 了vsftpd，如果未安装 则安装vsftpd。
    1）查看系统中是否安装了vsftpd： rpm -qa | grep vsftpd
    2）如果没有安装 vsftpd，则安装 ：yum -y install vsftpd

2、创建ftp用户，比如ftp_test。命令：useradd -s /sbin/nologin -d /home/ftp_test ftp_test
注意：
    1）目录尽量不要选择根目录下，这里是/home/ftp_test，并且ftp_test这个目录不要手动创建，否则权限会有问题，执行命令的时候会自动创建
    2）注意目录的权限，如果有需要，应该设置相应的权限
    
3、为ftp_test用户创建密码。命令：passwd ftp_test
	设置密码为：test1234

4、编辑vsftpd配置文件，命令:vim /etc/vsftpd/vsftpd.conf
	找到anonymous_enable这个配置项，默认是YES，修改成NO，表示不允许匿名用户登录。

5、启动vsftp服务，命令：systemctl start vsftpd.service

6、查看ftp服务的状态，命令：systemctl status vsftpd.service

7、用ftp客户端进行连接访问。

service vsftpd start | stop
```

```
启动ftp服务：
	yum install vsftpd 
	在/etc/rc.d/init.d/目录下：命令 service vsftp start
启动ssh服务，sftp服务
	在/etc/init.d/目录下： 命令 /etc/init.d/sshd start 注意这里需要在绝对路径下执行sshd start
```

```
在其他服务器上验证sftp 用户名@ip地址
示例：在172.16.7.57上
    sftp root@172.16.6.35
    密码： oracle
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
## du

```
du : 显示每个文件和目录的磁盘使用空间~~~文件的大小。
示例：	du -sh 路径

命令参数：
    -a   #显示目录中文件的大小  单位 KB 。
    -b  #显示目录中文件的大小，以字节byte为单位。
    -c  #显示目录中文件的大小，同时也显示总和；单位KB。
    -k 、 -m  、#显示目录中文件的大小，-k 单位KB，-m 单位MB.
    -s  #仅显示目录的总值，单位KB。
    -h  #以K  M  G为单位显示，提高可读性~~~（最常用的一个~也可能只用这一个就满足需求了）
    -x  #以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过。 
    -L   #显示选项中所指定符号链接的源文件大小。   
    -S   #显示个别目录的大小时，并不含其子目录的大小。 
    -X   #在<文件>指定目录或文件。   
    --exclude=<目录或文件>    #略过指定的目录或文件。    
    -D   #显示指定符号链接的源文件大小。   
    -H或--si                 #与-h参数相同，但是K，M，G是以1000为换算单位。   
    -l   #重复计算硬件链接的文件。
```



##  **tar**

```
压缩：	tar -czvf FileName.tar.gz DirName
解压：	tar -xzvf FileName.tar.gz -C /usr/local #-C 选项的作用是：指定需要解压到的目录。
示例： 
```
## find

```
find / -name '*.logout*' 2>/dev/null
find . -type f -name *.svn*    | xargs rm -f
find . -name \*52\* 
```

## cp

```
cp -r svg/* /usr/local/apache2/htdocs/inc_chk/new_index/svg/
```

## scp

```
scp -r git@120.79.201.125:/home/www/web/thinkphp5.1/msy/public/uploads/weiya_project .
scp /usr/local/dm7client/drivers/php_pdo/*52* root@172.16.6.44:/usr/local/php2/lib/php/extensions/no-debug-non-zts-20060613
scp /usr/local/php/include/php/ext/pdo_oci.so root@172.16.6.44:/usr/local/php2/lib/php/extensions/no-debug-non-zts-20060613
scp test.php root@172.16.6.44:/usr/local/apache2/htdocs/test.php
scp -r root@172.16.6.44:/usr/local/apache/htdocs/inc_chk/new_index/svg .
scp -r root@172.16.7.71:/usr/local/nginx/conf/nginx_2c.conf .
scp -r root@172.16.6.45:/usr/local/nginx/conf/nginx_2c.conf .
scp -r root@172.16.7.57:/root/sbin/INS_convert.sh .
scp -r root@172.16.7.56:/usr/local/apache2.4/htdocs/inc_chk/new_index/svg/* .
```

## 清空文件内容

```
1. 清空或者让一个文件成为空白的最简单方式，是像下面那样，通过 shell 重定向 null （不存在的事物）到该文件：
	# > test.log
2. 使用 : 符号，它是 shell 的一个内置命令，等同于 true 命令，它可被用来作为一个 no-op（即不进行任何操作）。
另一种清空文件的方法是将 : 或者 true 内置命令的输出重定向到文件中，具体如下：
	# : > test.log
	# true > test.log
3.使用 cat/cp/dd 实用工具及 /dev/null 设备来清空文件
	# cat /dev/null  test.log
	# cp /dev/null test.log
	# dd if=/dev/null of=test.log （ if 代表输入文件，of 代表输出文件）
4. 使用 echo 命令清空文件
	# echo "" >test.log
	# echo > test.log
	注意：你应该记住空字符串并不等同于 null 。字符串表明它是一个具体的事物，只不过它的内容可能是空的，但 null 则意味着某个事物并不存在。
	基于这个原因，当你将 echo命令 的输出作为输入重定向到文件后，使用cat命令来查看该文件的内容时，你将看到一个空白行（即一个空字符串）。
    要将 null 做为输出输入到文件中，你应该使用 -n 选项，这个选项将告诉 echo 不再像上面的那个命令那样输出结尾的那个新行。
    # echo -n "" > test.log
5. 使用 truncate 命令来清空文件内容，truncate 可被用来将一个文件缩小或者扩展到某个给定的大小。
你可以利用它和 -s 参数来特别指定文件的大小。要清空文件的内容，则在下面的命令中将文件的大小设定为 0:
	# truncate -s 0 test.log
```

