

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



# ***<u>网络</u>***

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

```
默认：
    ubuntu ： ufw 
    centos ： iptables
    redhat :  firewall
```

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
	
/etc/init.d/iptables stop
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

### linux文件最大连接数问题

```
描述：
	-bash: ulimit: open files: cannot modify limit: 不允许的操作
原因： 
	linux对用户有默认的ulimit限制，/etc/sysconfig/limits.conf 文件可以配置用户的硬配置和软配置，硬配置是个上限。
	当超出上限的修改就会出“不允许的操作”这样的错误。
解决：
	root账号:	vim /etc/security/limits.conf
	添加：
	* - nofile 65535
	* - nproc 65535
示例：
	oracle              soft    nproc   2047
    oracle              hard    nproc   16384
    oracle              soft    nofile  1024
    oracle              hard    nofile  65536
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

# *<u>**系统**</u>*

```
一般来说，linux系统采用 A.B.C.D 的版本号管理方式，A表示主版本号，B表示次版本号，C表示修订版本，D表示更新版本号。
其中次版本号为偶数是稳定版本，为奇数表示有一些新的东西加入，是个不一定很稳定的测试版本，但是2.6版本以后，不再使用奇偶来来作为稳定和不稳定版本的判别。

适合所有 Linux 系统：
    
    cat /etc/issue

只适合查看 Redhat 系的 Linux，如：CentOS：
	cat /etc/redhat-release

适用于所有的 Linux 发行版：
	cat /proc/version
    uname -a
    uname -r
	cat /etc/issue
	cat /etc/*release*
    lsb_release -a 有些系统中默认并没有安装lsb_release，需要进行安装，以CentOS为例：
        首先查找lsb_release安装包：	yum provides lsb_release
        安装：	yum install -y redhat-lsb-core
    
查看系统是64位还是32位:
	getconf LONG_BIT	      
```

## 包管理&安装

```
源码安装的流程一般是三部曲：
    ./configure
    make
    make install  
    
./configure是为了检测目标安装平台的特征，并且检查依赖的软件包是否可用或者是否缺少依赖软件包，configure事实上是个脚本，最终的目的是生成Makefile。

如果第一条指令没有报错，会生成一个Makefile，make指令就是编译这个源码包

正常编译完之后如果没有报错，就生成了可执行文件，make install指令就是将可执行文件放到指定目录并配置环境变量，允许我们在任何目录下使用这个软件。
```

### yum与apt-get

```
linux系统基本上分两大类： 
    1.RedHat系列：Redhat、Centos、Fedora等 
    2.Debian系列：Debian、Ubuntu等 

    RedHat 系列 
        1 常见的安装包格式 rpm包,安装rpm包的命令是“rpm -参数” 
        2 包管理工具 yum 
        3 支持tar包 

    Debian系列 
        1 常见的安装包格式 deb包,安装deb包的命令是“
        dpkg-参数” 
        2 包管理工具 apt-get 
        3 支持tar包

yum是RedHat系列的高级软件包管理工具
    主要功能是更方便的添加/删除/更新RPM包。
    它能自动解决包的依赖性问题。
    它能便于管理大量系统的更新问题。
yum的特点
    可以同时配置多个资源库(Repository)
    简洁的配置文件(/etc/yum.conf)
    自动解决增加或删除rpm包时遇到的倚赖性问题
    保持与RPM数据库的一致性
    
apt-get是Debian系列的高级软件包管理工具
    配置文件/etc/apt/sources.list
    sudo apt-get install xxx
    apt-get可以用于运作deb包，例如在Ubuntu上对某个软件的管理：

    安装：apt-get install <package_name>
    卸载：apt-get remove <package_name> 
    更新：apt-get update <package_name>

tar 只是一种压缩文件格式，所以，它只是把文件压缩打包而已。
rpm 相当于windows中的安装文件，它会自动处理软件包之间的依赖关系。
 
优缺点来说，rpm一般都是预先编译好的文件，它可能已经绑定到某种CPU或者发行版上面了。
tar一般包括编译脚本，你可以在你的环境下编译，所以具有通用性。
 
如果你的包不想开放源代码，你可以制作成rpm，如果开源，用tar更方便了。
 
tar一般都是 源码打包的软件，需要自己解包，然后进行安装三部曲，./configure, make, make install.　来安装软件。
rpm是redhat公司的一种软件包管理机制，直接通过rpm命令进行安装删除等操作，最大的优点是自己内部自动处理了各种软件包可能的依赖关系。
```

### yum&rpm

```
安装：rpm -ivh *.rpm
卸载：rpm -e packgename 
升级：rpm -Uvh xxx
查询所有安装的包： rpm -qa
查询某个包：rpm -qa | grep nginx
查询软件的安装路径：rpm -ql nginx
查询某个文件是那个rpm包产生：rpm -qf /etc/yum.conf
    
1）.用YUM安装删除软件
装了系统添加删除软件是常事，yum同样可以胜任这一任务，只要软件是rpm安装的。
安装的命令是yum install xxx，yum会查询数据库，有无这一软件包，如果有，则检查其依赖冲突关系，如果没有依赖冲突，那么最好，下载安装;如果有，则会给出提示，询问是否要同时安装依赖，或删除冲突的包，你可以自己作出判断。
删除的命令是，yum remove xxx，同安装一样，yum也会查询数据库，给出解决依赖关系的提示。
 
2）.用YUM安装软件包
命令：yum install 
 
3）.用YUM删除软件包
命令：yum remove 
用YUM查询软件信息，我们常会碰到这样的情况，想要安装一个软件，只知道它和某方面有关，但又不能确切知道它的名字。这时yum的查询功能就起作用了。你可以用 yum search keyword这样的命令来进行搜索，比如我们要则安装一个Instant Messenger，但又不知到底有哪些，这时不妨用 yum search messenger这样的指令进行搜索，yum会搜索所有可用rpm的描述，列出所有描述中和messeger有关的rpm包，于是我们可能得到 gaim，kopete等等，并从中选择。有时我们还会碰到安装了一个包，但又不知道其用途，我们可以用yum info packagename这个指令来获取信息。
 
4）.使用YUM查找软件包
命令：yum search 
 
5）.列出所有可安装的软件包
命令：yum list 
 
6）.列出所有可更新的软件包
命令：yum list updates 
 
7）.列出所有已安装的软件包
命令：yum list installed 
 
8）.列出所有已安装但不在 Yum Repository 內的软件包
命令：yum list extras 
 
9）.列出所指定的软件包
命令：yum list 

```

### apt-get&dpkg

```
apt-get:
配置文件：cat /etc/apt/sources.list 

（1）普通安装：apt-get install softname1 softname2 …;
（2）修复安装：apt-get -f install softname1 softname2… ;(-f Atemp to correct broken dependencies)
（3）重新安装：apt-get –reinstall install softname1 softname2…;

要最新版本的话，不妨先apt-get update 来更新一下软件的仓库,然后再 apt-get install.
 
常用的APT命令参数：
    apt-cache search package 搜索包
    apt-cache show package 获取包的相关信息，如说明、大小、版本等
    apt-cache depends package 了解使用依赖
    apt-cache rdepends package 是查看该包被哪些包依赖
    sudo apt-get install package 安装包
    sudo apt-get install package - - reinstall 重新安装包
    sudo apt-get -f install 修复安装"-f = ——fix-missing"
    sudo apt-get remove package 删除包
    sudo apt-get remove package - - purge 删除包，包括删除配置文件等
    sudo apt-get update 更新源
    sudo apt-get upgrade 更新已安装的包
    sudo apt-get dist-upgrade 升级系统
    sudo apt-get dselect-upgrade 使用 dselect 升级
    sudo apt-get build-dep package 安装相关的编译环境
    sudo apt-get source package 下载该包的源代码
    sudo apt-get clean && sudo apt-get autoclean 清理无用的包
    sudo apt-get check 检查是否有损坏的依赖

sudo apt-get install -y
这里主要将的就是-y选项，添加这个选项就相当于不需要重复地确认安装

sudo apt-get install -q
即-quiet，静默安装，当然也不是完全静默，会将低等级的log信息屏蔽。

sudo apt-get remove
既然有安装就会有卸载，remove指令就是卸载，值得注意的是，remove仅仅卸载软件，但是并不卸载配置文件

sudo apt-get purge
卸载指令，同时卸载相应的配置文件

dpkg：
查看已经安装了的软件：dpkg -l | grep 'php' 

1、dpkg -i < package.deb >
	安装一个 Debian 软件包，如你手动下载的文件。

2、dpkg -c < package.deb >
	列出 < package.deb > 的内容。

3、dpkg -I(大写i) < package.deb >
	从 < package.deb > 中提取包裹信息。

4、dpkg -r < package >
	移除一个已安装的包裹。

5、dpkg -P < package >
	完全清除一个已安装的包裹。和 remove 不同的是，remove 只是删掉数据和可执行文件，purge 另外还删除所有的配制文件。

6、dpkg -L < package >
	列出 < package > 安装的所有文件清单。同时请看 dpkg -c 来检查一个 .deb 文件的内容。

7、dpkg -s < package >
	显示已安装包裹的信息。同时请看 apt-cache 显示 Debian 存档中的包裹信息，以及 dpkg -I 来显示从一个 .deb 文件中提取的包裹信息。

8、dpkg-reconfigure < package >
	重新配制一个已经安装的包裹，如果它使用的是 debconf (debconf 为包裹安装提供了一个统一的配制界面)。
```

## 内核

```
五大基本功能：
    进程管理
    内存管理
    文件系统
    网络协议
    设备管理
```
## 进程管理

```

```



## shell

```
常见shell类型：
1. Bourne shell (sh)
UNIX 最初使用，且在每种 UNIX 上都可以使用。在 shell 编程方面相当优秀，但在处理与用户的交互方面做得不如其他几种shell。

2. C shell (csh)
csh, the C shell, is a command interpreter with a syntax similar to the C programming language.一个语法上接近于C语言的shell。

3. Korn shell (ksh)
完全向上兼容 Bourne shell 并包含了 C shell 的很多特性。

4. Bourne Again shell (bash)
因为Linux 操作系统缺省的 shell。即 bash 是 Bourne shell 的扩展，与 Bourne shell 完全向后兼容。在 Bourne shell 的基础上增加、增强了很多特性。可以提供如命令补全、命令编辑和命令历史表等功能。包含了很多 C shell 和 Korn shell 中的优点，有灵活和强大的编程接口，同时又有很友好的用户界面。

5. Debian Almquist Shell(dash)
原来bash是GNU/Linux 操作系统中的 /bin/sh 的符号连接，但由于bash过于复杂，有人把 bash 从 NetBSD 移植到 Linux 并更名为 dash，且/bin/sh符号连接到dash。Dash Shell 比 Bash Shell 小的多（ubuntu16.04上，bash大概1M，dash只有150K），符合POSIX标准。Ubuntu 6.10开始默认是Dash。

```

### 语法

```
关于变量
    变量赋值使用 = 等号,左右不能留有空格
    使用变量的值用$取值符号
例：  
    SHMID=`ipcs -m | awk '$4==707 {print $2}' ` 
    =号两边不能有空格
```

### 规范

```
关于首行
	使用#!/usr/bin/env bash，当然也有 #!/bin/sh、#!/usr/bin/bash,这几种写法也都算是正确
	
关于注释
    除脚本首行外,所有以 # 开头的语句都将成为注释。
    函数必须有注释标识该函数的用途、入参变量、函数的返回值类型,且必须简单在一行内写完。
    函数的注释 # 顶格写, 井号后面紧跟一个空格 ,对于该格式的要求是为了最后生成函数的帮助文档是用的(markdown语法),然后是注释的内容,注释尽量简短且在一行,最后跟的是函数的类型。
    函数内注释 # 与缩进格式对整齐
    变量的注释紧跟在变量的后面
    
关于缩进
    使用两个空格进行缩进,不适用tab缩进
    不在一行的时候使用 \ 进行换行,使用 \ 换行的原则是整齐美观
    
关于变量
    使用变量的时候,变量名一定要用{}包裹
    使用变量的时候一定要用 双引号 "${}"包裹
    
注意: 单引号和双引号的区别
    单引号里的任何字符都会原样输出,单引号字符串中的变量是无效的,单引号字串中不能出现单引号（对单引号使用转义符后也不行）。
    双引号中的普通字符都会原样输出,单引号中的使用$取值的变量会替换成响应变量的真实值得,然后在进行输出,双引号中可以出现单引号

    常量一定要定义成readonly,这种变量不能使用source跨shell使用
    比如一个a.sh 中定义了一个全局的变量 readonly TURE=0,b.sh 中在一开始使用 source a.sh 引入的a.sh 的内容,则在 b.sh 中无需重复定义 readonly local TRUE=0,否则会报错

    函数中的变量要用local修饰,定义成局部变量,这样在外部遇到重名的变量也不会影响
    
    web="www.chen-shang.github.io"
    function main(){
      local name="chenshang" #这里使用local定义一个局部变量
      local web="${web}"     #这里${}内的web是全局变量,之后在函数中在使用web变量都是使用的局部变量
      local web2="${web}"    #对于全局变量,虽然在使用的时候直接使用即可,但还是推荐使用一个局部变量进行接收，然后使用局部变量，以防止在多线程操作的时候出现异常（相当于java中的静态变量在多线程中的时候需要注意线程安全一样，但常量除外）
    }
    
    变量一经定义,不允许删除(也就是禁用unset命令,因为到目前我还没遇到过什么情况必须unset的)
```



### 环境变量

```
-------------------------------------
1、查看某一个环境变量（PATH）
     echo $PATH
	 env|grep PATH
2、查看所有的环境变量
    env
	sudo env
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
-------------------------------------LANG
是针对Linux系统的语言、地区、字符集的设置,对linux下的应用程序有效，如date；NLS_LANG是针对Oracle语言、地区、字符集的设置，对oracle中的工具有效
```

#### LD_LIBRARY_PATH

https://blog.csdn.net/native_lee/article/details/105380259

```
非默认动态库的查找路径
    echo $LD_LIBRARY_PATH
    env|grep LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/dm7client/bin/:/usr/local/dm7client/drivers/odbc/
```

##### sudo保持前用用户的env环境变量

https://www.modb.pro/db/26671

```
通过sudo -l来查看sudo的限制
选项Defaults env_reset表示默认会将环境变量重置，这样你定义的变量在sudo环境就会失效，获取不到

sudo命令会重置环境变量,查看文件
sudo vim /etc/sudoers,可以看到这样的配置，由于此文件是只读文件，保存退出时先 w! ,再 q， 或者 sudo visudu
Defaults      env_reset

解决方法:(实际验证无效)
	第一种,也是最简单的，使用sudo -E来代替sudo即可保留当前用户的环境变量，但缺点也很明显，每次都要加

	第二种方式：修改/etc/sudoers文件，将Defaults env_reset改为 Defaults !env_reset，这样以后使用sudo就再也不会重置环境变量了

    需要注意的是`/etc/sudoers`是只读文件,vim不能更改,要使用`visudo`命令(不用加文件名)来更改内容
    另外有的发行版还有一个Defaults env_keep=""的选项，用于保留部分环境变量不被重置，需要保留的变量就写入双引号中。

不行的话在用户的主目录里的.bashrc中添加:
	alias sudo='sudo env PATH=$PATH'
```

#### export

```
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/dmdbms/bin"
```



### 配置文件

```
profile系列 和 rc系列 & 交互式的登陆 和 非交互式登陆
profile：
	交互式：
		登陆过程：
            1. 读取并执行/etc/profile文件；
            2. 读取并执行~/.bash_profile文件；
            - 若文件不存在，则读取并执行~/.bash_login文件；
            - 若文件不存在，则读取并执行~/.profile文件；
        登出过程：
            1. 读取并执行~/.bash_logout文件；
            2. 读取并执行/etc/bash.bash_logout文件；
            
 	非交互式：
        登陆过程：
            1. 读取并执行/etc/profile文件；
            2. 读取并执行~/.bash_profile文件；
            - 若文件不存在，则读取并执行~/.bash_login文件；
            - 若文件不存在，则读取并执行~/.profile文件；
        与“交互式登陆shell”相比，“非交互式登陆shell”并没有登出的过程
        
rc:
	交互式：
		1. 读取并执行~/.bashrc或–rcfile选项指定的文件
		这里需要说明，其实“rc”系列startup文件还包括/etc/bashrc。但是系统并不直接调用这个文件，而是通过~/.bashrc文件显式地调用它。
	非交互式：

总结：
	~/.bash_profile会显式调用~/.bashrc文件，而~/.bashrc又会显式调用/etc/bashrc文件，这是为了让所有交互式界面看起来一样。无论你是从远程登录（登陆shell），还是从图形界面打开终端（非登陆shell），你都拥有相同的提示符，因为环境变量PS1在/etc/bashrc文件中被统一设置过。
	
下面我来对startup文件进行一个完整的总结，如下图：
```

![img](https://img-blog.csdn.net/20180328164239209?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2R1emlsb25nbG92ZQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



## 时区

```
cat /etc/sysconfig/clock
```

## alias

```
alias ls='ls -lrt --color=auto'
alias ll='ls -a'
alias rm='rm -i'
```

## sudo

```
su root | 或者找一个有sudo权限的账户：
vim /etc/sudoers //打开sudo的配置文件	
    root    ALL=(ALL)  ALL                 # 系统默认
    user1   ALL=(ALL)  ALL                 # user1 可以使用最高权限 需要输入用户密码
    user2   ALL=(ALL)  NOPASSWD:ALL        # user2 可以使用最高权限 不需要输入用户密码

    # 如果设置用户组前面加 %
    %group1  ALL=(ALL)  ALL                # 用户组group1下所有用户可以使用最高权限

chmod u+w /etc/sudoers
chmod u-w /etc/sudoers

su和sudo的区别
    共同点：都是root用户权限；
    不同点：su只获得root权限，工作环境不变，还是在切换之前用户的工作环境；sudo是完全获得root的权限和root的工作环境。(此处实际验证不对)
    sudo:表示获取临时的root权限执行命令。
    sudo执行命令的流程:
        1、当前用户切换到root（或其他指定切换到的用户），
        2、以root（或其他指定的切换到的用户）身份执行命令，
        3、执行完成后，直接退回到当前用户，而这些的前提是要通过sudo的配置文件/etc/sudoers来进行授权。
        
su - root和su root区别
	su - root：以root身份登录，then the shell is login shell, .bash_profile and .bashrc will be sourced.
	su root/其他命令：与root建立一个连接，通过root执行命令。then only .bashrc will be sourced.
	最直接的区别是su目录还是原先用户目录，su - root后目录就变为root用户的主目录。
	
sudo su 运行sudo命令给su命令提权，运行su命令。要求执行该命令的用户必须在sudoers中才可以。
示例：	sudo su - root | sudo su -

执行sudo su -成root的用户，和root用户的区别：
    普通用户使用sudo 来执行只有root才能执行权限的命令，跟用root用户执行是不一样的，因为这时候他用的还是普通用户的环境变量。
    用su -成root的用户还是有些环境变量是和root登陆是不一样的。另外，它们的uid也是不一样，只有euid是相同的。
```

## PS1

```
PS1='[\u@\h \W]\$ '
vim .bashrc
	PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[36;40m\]\w\[\e[0m\]]\\$ " 
source .bashrc | . .bashrc

参考：
	https://www.cnblogs.com/Q--T/p/5394993.html
```

## stty

```
stty
相关命令：暂无相关命令
用法：stty [-F 设备 | --file=设备] [设置]...
　或：stty [-F 设备 | --file=设备] [-a|--all]
　或：stty [-F 设备 | --file=设备] [-g|--save]
输出或修改终端参数。

  -a, --all             以可读性较好的方式输出全部当前设置
  -g, --save            以stty 可读取的格式输出当前全部设置
  -F, --file=设备       打开并使用指定设备代替标准输入
      --help            显示此帮助信息并退出
      --version         显示版本信息并退出

可选- 在设置前的指示中，* 标记出了非POSIX 标准的设置。以下系
统定义象征了哪些设置是有效的。

特殊字符：
 * dsusp 字符   每当输入刷新时会发送一个用于终端阻塞信号的字符
   eof  字符    表示文件末尾而发送的字符(用于终止输入)
   eol  字符    为表示行尾而发送的字符
 * eol2 字符    为表示行尾而发送的另一个可选字符
   erase 字符   擦除前一个输入文字的字符
   intr 字符    用于发送中断信号的字符
   kill 字符    用于擦除当前终端行的字符
 * lnext 字符   用于输入下一个引用文字的字符
   quit 字符    用于发送退出信号的字符
 * rprnt 字符   用于重绘当前行的字符
   start 字符   在停止后重新开启输出的字符
   stop 字符    停止输出的字符
   susp 字符    发送终端阻断信号的字符
 * swtch 字符   在不同的shell 层次间切换的字符
 * werase 字符  擦除前一个输入的单词的字符

特殊设置：
   N            设置输入输出速度为N 波特
 * cols N       统治内核终端上有N 栏
 * columns N    等于cols N
   ispeed N     设置输入速度为N 波特
 * line N       设置行约束规则为N
   min N        和 -icanon 配合使用，设置每次一完整读入的最小字符数为<N>
   ospeed N     设置输出速度为N 波特
 * rows N       向内核通告此终端有N 行
 * size 根据内核信息输出当前终端的行数和列数
   speed        输出终端速度(单位为波特)
   time N       和-icanon 配合使用，设置读取超时为N 个十分之一秒

控制设置：
   [-]clocal    禁用调制解调器控制信号
   [-]cread     允许接收输入
 * [-]crtscts   启用RTS/CTS 握手
   csN          设置字符大小为N 位，N 的范围为5 到8
   [-]cstopb    每个字符使用2 位停止位 (要恢复成1 位配合"-"即可)
   [-]hup       当最后一个进程关闭标准终端后发送挂起信号
   [-]hupcl     等于[-]hup
   [-]parenb    对输出生成奇偶校验位并等待输入的奇偶校验位
   [-]parodd    设置校验位为奇数 (配合"-"则为偶数)

输入设置：
   [-]brkint    任务中断会触发中断信号
   [-]icrnl     将回车转换为换行符
   [-]ignbrk    忽略中断字符
   [-]igncr     忽略回车
   [-]ignpar    忽略含有奇偶不对称错误的字符
 * [-]imaxbel   发出终端响铃但不刷新字符的完整输入缓冲
   [-]inlcr     将换行符转换为回车
   [-]inpck     启用输入奇偶性校验
   [-]istrip    剥除输入字符的高8 位比特
 * [-]iutf8     假定输入字符都是UTF-8 编码
 * [-]iuclc     将大写字母转换为小写
 * [-]ixany     使得任何字符都会重启输出，不仅仅是起始字符
   [-]ixoff     启用开始/停止字符传送
   [-]ixon      启用XON/XOFF 流控制
   [-]parmrk    标记奇偶校验错误 (结合255-0 字符序列)
   [-]tandem    等于[-]ixoff

输出设置：
 * bsN          退格延迟的风格，N 的值为0 至1
 * crN          回车延迟的风格，N 的值为0 至3
 * ffN          换页延迟的风格，N 的值为0 至1
 * nlN          换行延迟的风格，N 的值为0 至1
 * [-]ocrnl     将回车转换为换行符
 * [-]ofdel     使用删除字符代替空字符作填充
 * [-]ofill     延迟时使用字符填充代替定时器同步
 * [-]olcuc     转换小写字母为大写
 * [-]onlcr     将换行符转换为回车
 * [-]onlret    使得换行符的行为表现和回车相同
 * [-]onocr     不在第一列输出回车
   [-]opost     后续进程输出
 * tabN 水平制表符延迟的风格，N 的值为0 至3
 * tabs 等于tab0
 * -tabs        等于tab3
 * vtN          垂直制表符延迟的风格，N 的值为0 至1

本地设置：
   [-]crterase  擦除字符回显为退格符
 * crtkill      依照echoprt 和echoe 的设置清除所有行
 * -crtkill     依照echoctl 和echol 的设置清除所有行
 * [-]ctlecho   在头字符中输出控制符号("^c")
   [-]echo      回显输入字符
 * [-]echoctl   等于[-]ctlecho
   [-]echoe    等于[-]crterase
   [-]echok     在每清除一个字符后输出一次换行
 * [-]echoke    等于[-]crtkill 意义相同
   [-]echonl    即使没有回显任何其它字符也输出换行
 * [-]echoprt   在"\"和"/"之间向后显示擦除的字符
   [-]icanon    启用erase、kill、werase 和rprnt 等特殊字符
   [-]iexten    允许POSIX 标准以外的特殊字符
   [-]isig      启用interrupt、quit和suspend 等特殊字符
   [-]noflsh    在interrupt 和 quit 特殊字符后禁止刷新
 * [-]prterase  等于[-]echoprt
 * [-]tostop    中止尝试向终端写入数据的后台任务
 * [-]xcase     和icanon 配合使用，用转义符"\"退出大写状态

综合设置：
 * [-]LCASE     等于[-]lcase
   cbreak       等于-icanon
   -cbreak      等于icanon
   cooked       等于brkint ignpar istrip icrnl ixon opost isig icanon eof                   eol 等的默认值
   -cooked      等于-raw
   crt          等于echoe echoctl echoke
   dec          等于echoe echoctl echoke -ixany intr ^c erase 0177 kill ^u
 * [-]decctlq   等于[-]ixany
   ek           清除所有字符，将它们回溯为默认值
   evenp        等于parenb -parodd cs7
   -evenp       等于-parenb cs8
 * [-]lcase     等于xcase iuclc olcuc
   litout       等于-parenb -istrip -opost cs8
   -litout      等于parenb istrip opost cs7
   nl           等于-icrnl -onlcr
   -nl          等于icrnl -inlcr -igncr onlcr -ocrnl -onlret
   oddp 等于parenb parodd cs7
   -oddp        等于-parenb cs8
   [-]parity    等于[-]evenp
   pass8        等于-parenb -istrip cs8
   -pass8       等于parenb istrip cs7
   raw          等于-ignbrk -brkint -ignpar -parmrk -inpck -istrip
                 -inlcr -igncr -icrnl -ixon -ixoff -iuclc -ixany
                 -imaxbel -opost -isig -icanon -xcase min 1 time 0
   -raw 等于cooked
   sane 等于cread -ignbrk brkint -inlcr -igncr icrnl -iutf8
                -ixoff -iuclc -ixany imaxbel opost -olcuc -ocrnl onlcr
                -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
                isig icanon iexten echo echoe echok -echonl -noflsh
                -xcase -tostop -echoprt echoctl echoke，所有特殊字符均
                使用默认值
                
$ stty eof c
    其中c可以是你喜欢的其它特殊控制字符。
    可以直接输入控制字符，在其前面冠以反斜线和脱字符（ ^）。命令
$ stty eof ^c
	将CTRL-C设置为文件结束符。这种语法形式还可以用于修改删除符（通常为退格键BackSpace）和中断符（通常为DEL键）。若希望将删除符改为BACKSPACE，可以使用下列命令：
$ stty erase ^h
	可以设置一个会话期，使得当自己键入一个退格键时，系统用退格、删除和退格序列响应。此时可以看到用退格键覆盖的字符从显示中消失了，这样更符合计算机的惯例。使用命令
```

## cpu

```
查看cpu相关信息，包括型号、主频、内核信息等
	cat /proc/cpuinfo

/*CPU查看CPU型号*/
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

## 服务

### chkconfig

https://linux.cn/article-1847-1.html

```
chkconfig 命令用来设定和查询不同运行级上的系统服务  注：谨记chkconfig不是立即自动禁止或激活一个服务，它只是简单的改变了符号连接。
查看服务：
	chkconfig --list       			# 列出所有系统服务
	chkconfig --list | grep on    	# 列出所有启动的系统服务
```

### service、systemctl 和 chkconfig

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

### 开机自启动

```
一、修改开机启动文件：/etc/rc.local（或者/etc/rc.d/rc.local）
	vim /etc/rc.local
		/usr/local/pgsql/start.sh
	chmod +x /etc/rc.local
	chmod 755 /etc/rc.local
	
二、自己写一个shell脚本
	将写好的脚本（.sh文件）放到目录 /etc/profile.d/ 下，系统启动后就会自动执行该目录下的所有shell脚本。
	
三、通过chkconfig命令设置
	# 1.将(脚本)启动文件移动到 /etc/init.d/或者/etc/rc.d/init.d/目录下。（前者是后者的软连接）
    	mv /www/wwwroot/test.sh /etc/rc.d/init.d

    # 2.启动文件前面务必添加如下三行代码，否侧会提示chkconfig不支持。
        #!/bin/sh             告诉系统使用的shell,所以的shell脚本都是这样
        #chkconfig: 35 20 80        分别代表运行级别，启动优先权，关闭优先权，此行代码必须
        #description: http server     自己随便发挥！！！，此行代码必须
        /bin/echo $(/bin/date +%F_%T) >> /tmp/test.log

    # 3.增加脚本的可执行权限
    	chmod +x /etc/rc.d/init.d/test.sh

    # 4.添加脚本到开机自动启动项目中。添加到chkconfig，开机自启动。
        [root@localhost ~]# cd /etc/rc.d/init.d
        [root@localhost ~]# chkconfig --add test.sh
        [root@localhost ~]# chkconfig test.sh on

    # 5.关闭开机启动 
    	[root@localhost ~]# chkconfig test.sh off

    # 6.从chkconfig管理中删除test.sh
    	[root@localhost ~]# chkconfig --del test.sh

    # 7.查看chkconfig管理
    	[root@localhost ~]# chkconfig --list test.sh
    	
四、自定义服务文件，添加到系统服务，通过Systemctl管理
    1.写服务文件：如nginx.service、redis.service、supervisord.service
        [Unit]:服务的说明
        Description:描述服务
        After:描述服务类别

        [Service]服务运行参数的设置
        Type=forking      是后台运行的形式
        ExecStart        为服务的具体运行命令
        ExecReload       为服务的重启命令
        ExecStop        为服务的停止命令
        PrivateTmp=True     表示给服务分配独立的临时空间
        注意：启动、重启、停止命令全部要求使用绝对路径

        [Install]        服务安装的相关设置，可设置为多用户
        WantedBy=multi-user.target 
    2.文件保存在目录下：以754的权限。目录路径：/usr/lib/systemd/system。如上面的supervisord.service文件放在这个目录下面。
        [root@localhost ~]# cat /usr/lib/systemd/system/nginx.service
        [root@localhost ~]# cat /usr/lib/systemd/system/supervisord.service
    3.设置开机自启动(任意目录下执行)。如果执行启动命令报错，则执行：systemctl daemon-reload
        设置开机自启动
        [root@localhost ~]# systemctl enable nginx.service    
        [root@localhost ~]# systemctl enable supervisord

        停止开机自启动
        [root@localhost ~]# systemctl disable nginx.service
        [root@localhost ~]# systemctl disable supervisord

        验证一下是否为开机启动
        [root@localhost ~]# systemctl is-enabled nginx
        [root@localhost ~]# systemctl is-enabled supervisord
```



## 进程

```

```

### ps

```
ps -ef|grep详解
ps命令将某个进程显示出来
grep命令是查找
中间的|是管道命令 是指ps命令与grep同时执行

字段含义如下：
    UID       PID       PPID      C     STIME    TTY       TIME         CMD
    zzw      14124   13991      0     00:38      pts/0      00:00:00    grep --color=auto dae

    UID      ：程序被该 UID 所拥有
    PID      ：就是这个程序的 ID 
    PPID    ：则是其上级父程序的ID
    C          ：CPU使用的资源百分比
    STIME ：系统启动时间
    TTY     ：登入者的终端机位置
    TIME   ：使用掉的CPU时间。
    CMD   ：所下达的是什么指令
    
查看内存占用前五的进程：   ps auxw | head -1;ps auxw|sort -rn -k4|head -5
查看CPU占用前三的进程：	 ps auxw | head -1;ps auxw|sort -rn -k3|head -3
查看进程号：	pgrep php-fpm
追踪进程号：	strace -f -e connect  -p 你的进程编号
```



## 内存

```
1.1 /proc/meminfo
	# 这个文件记录着比较详细的内存配置信息，使用 cat /proc/meminfo 查看。

MemTotal：系统总内存，由于 BIOS、内核等会占用一些内存，所以这里和配置声称的内存会有一些出入，比如我这里配置有 2G，但其实只有 1.95G 可用。
MemFree：系统空闲内存。
MemAvailable：应用程序可用内存。有人会比较奇怪和 MemFree 的区别，可以从两个层面来区分，MemFree 是系统层面的，而 MemAvailable 是应用程序层面的。系统中有些内存虽然被使用了但是有一部分是可以回收的，比如 Buffers、Cached 及 Slab 这些内存，这部分可以回收的内存加上 MemFree 才是 MemAvailable 的内存值，这是内核通过特定算法算出来的，是一个估算值。
Buffers：缓冲区内存
Cached：缓存
```

### free

https://www.cnblogs.com/ultranms/p/9254160.html

```
free 命令显示系统内存的使用情况，包括物理内存、交换内存(swap)和内核缓冲区内存
	$ free
如果加上 -h 选项，输出的结果会友好很多
	$ free -h
有时我们需要持续的观察内存的状况，此时可以使用 -s 选项并指定间隔的秒数：
	$ free -h -s 3
	
下面先解释一下输出的内容：
    Mem 行(第二行)是内存的使用情况。
    Swap 行(第三行)是交换空间的使用情况。
    total 列显示系统总的可用物理内存和交换空间大小。
    used 列显示已经被使用的物理内存和交换空间。
    free 列显示还有多少物理内存和交换空间可用使用。
    shared 列显示被共享使用的物理内存大小。
    buff/cache 列显示被 buffer 和 cache 使用的物理内存大小。
    available 列显示还可以被应用程序使用的物理内存大小。
    
available  = free + buffer + cache 请注意，这只是一个很理想的计算方式，实际中的数据往往有较大的误差。
```

### top

https://www.cnblogs.com/niuben/p/12017242.html

```
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

查看硬盘的分区 #fdisk -l
查看IDE硬盘信息 #hdparm -i /dev/hda
查看STAT硬盘信息 #hdparm -I /dev/sda 或 #sudo apt-get install blktool #sudo blktool /dev/sda id
查看硬盘剩余空间 #df -h #df -H
查看目录占用空间 #du -sh 目录名
优盘没法卸载 #sync fuser -km /media/usbdisk

df -h
du -sh /*
du -sh /usr/local/* | sort -nr

lsblk 可以看成是“List block device”的缩写，即列为出所有存储设备。

参考：
	https://www.linuxprobe.com/linux-lvm.html
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
标准输入 (stdin) : 代码为0，使用<或<<
标准输出 (stdout): 代码为1，使用>或>>
标准错误 (stderr): 代码为2，使用2>或2>>
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
	
查看端口：
	netstat -anp | grep portno
查看监听端口：	netstat -anp | grep LISTEN
查看php-fpm是否启动了：	netstat -nlp|grep php-fpm
```

### 端口映射

```

```



## **管道**

```
管道是将前一个命令的输出作为后一个命令的输入
```

## ulimit

```
ulimit 是一个计算机命令，用于shell启动进程所占用的资源，可用于修改系统资源限制
命令格式：
	ulimit [-SHcdefilmnpqrstuvx] [limit]

参数说明：
    -a 显示当前系统所有的limit资源信息。 
    -H 设置硬资源限制，一旦设置不能增加。
    -S 设置软资源限制，设置后可以增加，但是不能超过硬资源设置。
    -c 最大的core文件的大小，以 blocks 为单位。
    -f 进程可以创建文件的最大值，以blocks 为单位.
    -d 进程最大的数据段的大小，以Kbytes 为单位。
    -m 最大内存大小，以Kbytes为单位。
    -n 查看进程可以打开的最大文件描述符的数量。
    -s 线程栈大小，以Kbytes为单位。
    -p 管道缓冲区的大小，以Kbytes 为单位。
    -u 用户最大可用的进程数。
    -v 进程最大可用的虚拟内存，以Kbytes 为单位。
    -t 最大CPU占用时间，以秒为单位。
    -l 最大可加锁内存大小，以Kbytes 为单位。

查询当前终端的文件句柄数：	ulimit -n
修改当前终端的文件句柄数：	ulimit -n 65535

将ulimit 加入到/etc/profile 文件底部：
    echo ulimit -n 65535 >>/etc/profile
    source /etc/profile    #加载修改后的profile
    
注意：
    root用户没有限制
    当前会话只能降
    
永久配置：
步骤一：
	vim /etc/security/limits.conf
    # 添加如下的行
        * soft noproc 65535
        * hard noproc 65535
        * soft nofile 65535
        * hard nofile 65535
        或者：
        * - noproc 65535
        * - nofile 65535
    以上内容表示，将-u和-n的软限制和硬限制同时修改为65535
    
    说明：* 代表针对所有用户
        noproc 是代表最大进程数
        nofile 是代表最大文件打开数
        
步骤二（次步奏可忽略）：
	vim /etc/pam.d/login
	添加如下内容：
    session required pam_limits.so
    以上内容表示，在登录时使用pam管理limit。

步骤三：
    添加如下内容
    vim ~/.bash_profile # 当前用户有效
    vim /etc/profile # 所有用户有效
    ulimit -u 65535
    ulimit -n 65535
    每次登陆shell后，会初始执行这两条ulimit命令，并使其生效。

生效：
	重新登录或使用source /etc/profile|. /etc/profile立即生效。
	source使当前shell对指定文件内容生效。
	
/etc/security/limits.conf配置详解：  
    domain 是指生效实体
        用户名
        也可以通过@group指定用户组
        使用*表示默认值
    type指限制类型
        soft软限制
        hard硬限制
        item限制资源
    core同ulimit -c
    data同ulimit -d
    fsize同ulimit -f
    memloc同ulimit -l
    nofile同ulimit -n
    stack同ulimit -s
    cpu 同ulimit -t
    nproc同ulimit -u
    maxlogins指定用户可以同时登陆的数量
    maxsyslogins系统可以同时登陆的用户数
    priority用户进程运行的优先级
    locks用户可以锁定的文件最大值
    sigpengding同ulimit -i
    msgqueue同ulimit -q
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

## find & locate

```

```

## vmstat

```
vmstat命令是最常见的Linux/Unix监控工具，可以展现给定时间间隔的服务器的状态值,包括服务器的CPU使用率，内存使用，虚拟内存交换情况,IO读写情况
一般vmstat工具的使用是通过两个数字参数来完成的，第一个参数是采样的时间间隔数，单位是秒，第二个参数是采样的次数，如:
[root@EPG-RH ~]# vmstat 2 1        #2表示每个两秒采集一次服务器状态，1表示只采集一次
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy  id wa
 1  0      0 3498472 315836 3819540  0    0     0     1    2    0  0  0 100  0
----------------
参数解析：
r 表示运行队列(就是说多少个进程真的分配到CPU)，当这个值超过了CPU数目，就会出现CPU瓶颈了。这个也和top的负载有关系，一般负载超过了3就比较高，超过了5就高，超过了10就不正常了，服务器的状态很危险。top的负载类似每秒的运行队列。如果运行队列过大，表示你的CPU很繁忙，一般会造成CPU使用率很高。
b 表示阻塞的进程（进程阻塞）
swpd 虚拟内存已使用的大小，如果大于0，表示你的机器物理内存不足了，如果不是程序内存泄露的原因，那么你该升级内存了或者把耗内存的任务迁移到其他机器
free   空闲的物理内存的大小
buff   Linux/Unix系统是用来存储，目录里面有什么内容，权限等的缓存
cache cache直接用来记忆我们打开的文件,给文件做缓冲这里是Linux/Unix的聪明之处，把空闲的物理内存的一部分拿来做文件和目录的缓存，是为了提高 程序执行的性能，当程序使用内存时，buffer/cached会很快地被使用
si  每秒从磁盘读入虚拟内存的大小，如果这个值大于0，表示物理内存不够用或者内存泄露了，要查找耗内存进程解决掉
so  每秒虚拟内存写入磁盘的大小，如果这个值大于0，同上。
bi  块设备每秒接收的块数量，这里的块设备是指系统上所有的磁盘和其他块设备，默认块大小是1024byte，在处理拷贝大量数据(2-3T)的机器上可以达到140000/s，磁盘写入速度差不多140M每秒
bo 块设备每秒发送的块数量，例如我们读取文件，bo就要大于0。bi和bo一般都要接近0，不然就是IO过于频繁，需要调整。
in 每秒CPU的中断次数，包括时间中断
cs 每秒上下文切换次数，例如我们调用系统函数，就要进行上下文切换，线程的切换，也要进程上下文切换，这个值要越小越好，太大了，要考虑调低线程或者进程的数目,例如在apache和nginx这种web服务器中，我们一般做性能测试时会进行几千并发甚至几万并发的测试，选择web服务器的进程可以由进程或者线程的峰值一直下调，压测，直到cs到一个比较小的值，这个进程和线程数就是比较合适的值了。系统调用也是，每次调用系统函数，我们的代码就会进入内核空间，导致上下文切换，这个是很耗资源，也要尽量避免频繁调用系统函数。上下文切换次数过多表示你的CPU大部分浪费在上下文切换，导致CPU干正经事的时间少了，CPU没有充分利用，是不可取的。
us 用户CPU时间，在一个做加密解密很频繁的服务器上，可以看到us接近100,r运行队列达到80(机器在做压力测试，性能表现不佳)。
sy 系统CPU时间，如果太高，表示系统调用时间长，例如是IO操作频繁。
id  空闲 CPU时间，一般来说，id + us + sy = 100,一般我认为id是空闲CPU使用率，us是用户CPU使用率，sy是系统CPU使用率。
wt 等待IO CPU时间
```

## ls

```
用管道传输输出时，ls行为会有所不同。
‘-1’
‘--format=single-column’
List one file per line. This is the default for ls when standard output is not a terminal. See also the -b and -q options to suppress direct output of newline characters within a file name.


ls  data-govern-doc/md/*.md|cat

既：ls|cat == ls -1
```

## xargs

```

```

## awk

```
语法
awk [选项参数] 'script' var=value file(s)
或
awk [选项参数] -f scriptfile var=value file(s)

选项参数说明：
    -F fs or --field-separator fs
    指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F:。
    -v var=value or --asign var=value
    赋值一个用户定义变量。
    -f scripfile or --file scriptfile
    从脚本文件中读取awk命令。
    -mf nnn and -mr nnn
    对nnn值设置内在限制，-mf选项限制分配给nnn的最大块数目；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。
    -W compact or --compat, -W traditional or --traditional
    在兼容模式下运行awk。所以gawk的行为和标准的awk完全一样，所有的awk扩展都被忽略。
    -W copyleft or --copyleft, -W copyright or --copyright
    打印简短的版权信息。
    -W help or --help, -W usage or --usage
    打印全部awk选项和每个选项的简短说明。
    -W lint or --lint
    打印不能向传统unix平台移植的结构的警告。
    -W lint-old or --lint-old
    打印关于不能向传统unix平台移植的结构的警告。
    -W posix
    打开兼容模式。但有以下限制，不识别：/x、函数关键字、func、换码序列以及当fs是一个空格时，将新行作为一个域分隔符；操作符**和**=不能代替^和^=；fflush无效。
    -W re-interval or --re-inerval
    允许间隔正则表达式的使用，参考(grep中的Posix字符类)，如括号表达式[[:alpha:]]。
    -W source program-text or --source program-text
    使用program-text作为源代码，可与-f命令混用。
    -W version or --version
    打印bug报告信息的版本。

用法一：
	awk '{[pattern] action}' {filenames}   # 行匹配语句 awk '' 只能用单引号
实例：
    # 每行按空格或TAB分割，输出文本中的1、4项
    $ awk '{print $1,$4}' log.txt
    
用法二：
	awk -F  #-F相当于内置变量FS, 指定分割字符
实例：
    # 使用","分割
    $  awk -F, '{print $1,$2}'   log.txt
    
用法三：
	awk -v  # 设置变量
实例：
	$ awk -va=1 '{print $1,$1+a}' log.txt
	
用法四：
	awk -f {awk脚本} {文件名}
实例：
	$ awk -f cal.awk log.txt
	
内建变量：
    变量	描述
    $n	当前记录的第n个字段，字段间由FS分隔
    $0	完整的输入记录
    ARGC	命令行参数的数目
    ARGIND	命令行中当前文件的位置(从0开始算)
    ARGV	包含命令行参数的数组
    CONVFMT	数字转换格式(默认值为%.6g)ENVIRON环境变量关联数组
    ERRNO	最后一个系统错误的描述
    FIELDWIDTHS	字段宽度列表(用空格键分隔)
    FILENAME	当前文件名
    FNR	各文件分别计数的行号
    FS	字段分隔符(默认是任何空格)
    IGNORECASE	如果为真，则进行忽略大小写的匹配
    NF	一条记录的字段的数目
    NR	已经读出的记录数，就是行号，从1开始
    OFMT	数字的输出格式(默认值是%.6g)
    OFS	输出字段分隔符，默认值与输入字段分隔符一致。
    ORS	输出记录分隔符(默认值是一个换行符)
    RLENGTH	由match函数所匹配的字符串的长度
    RS	记录分隔符(默认是一个换行符)
    RSTART	由match函数所匹配的字符串的第一个位置
    SUBSEP	数组下标分隔符(默认值是/034)
    
运算符
    运算符	描述
    = += -= *= /= %= ^= **=	赋值
    ?:	C条件表达式
    ||	逻辑或
    &&	逻辑与
    ~ 和 !~	匹配正则表达式和不匹配正则表达式
    < <= > >= != ==	关系运算符
    空格	连接
    + -	加，减
    * / %	乘，除与求余
    + - !	一元加，减和逻辑非
    ^ ***	求幂
    ++ --	增加或减少，作为前缀或后缀
    $	字段引用
    in	数组成员
```

### 示例

```
#!/bin/bash
NAME="provider-integral"    #想要杀死的进程
PORT="8081"
PROCESS="../jars/provider-integral-0.0.1-SNAPSHOT.jar"
LOGDIR="../log/integral.log"
echo $NAME
ID=`ps -ef | grep "$NAME" | grep -v "grep" | awk '{print $2}'`  #注意此shell脚本的名称，避免自杀
if [ -z "$ID" ];then
    echo "process id is empty, process is not existed..."
    echo "process will start..."
    nohup java -Dserver.port=$PORT -jar $PROCESS  > $LOGDIR 2>&1 &
    echo "process has start..."
else
    echo $ID
	for id in $ID
        do
            kill -9 $id
            echo "killed $id"
        done
    echo "process will restart..."
    nohup java -Dserver.port=$PORT -jar $PROCESS  > $LOGDIR 2>&1 &
    echo "process has restart..."
fi


awk '{if ($1=="POST" && FILENAME!="data-govern-doc/md/接口规范.md") {print $2,"   ", FILENAME}}' data-govern-doc/md/*.md
```

### 采集程序重启

```
172.16.7.71
cd /root/filecollection
vim restart-filecollection.sh

#!/bin/bash
NAME="filecollection_audit_st1"    #想要杀死的进程

echo "先杀进程：" $NAME

ID=`ps -ef | grep -w "$NAME" | grep -v "grep" | awk '{print $2}'`  #注意此shell脚本的名称，避免自杀
for id in $ID
    do
    	kill -9 $id
    	echo "killed $id"
    done
 
SHMID=`ipcs -m | awk '$1=="0x040566ab" {print $2}'` 
echo "然后删共享内存：" $SHMID
ipcrm -m $SHMID

echo "最后修改Task.ini文件："
awk '{ if ($1=="SCHEDULE_MSG_ID" || $1=="SCHEDULE_P_ID") {sub($3,0);print} else print}' ini/Task.ini > ini/Task.ini.bak$$ && mv -f ini/Task.ini.bak$$ ini/Task.ini

echo "重启开始："
./filecollection_audit_st1 start
```

### 批量替换文件夹中所有文件

```
===============================测试-单个文件
vim test1
    1a 9,100.34
    1b 1,999.00
    1c 5,656.55
awk '{sub(/1/,"test")}{print "\n",$1,$2}' test1
awk '{gsub(/1/,"test")}{print "\n",$1,$2}' test1
awk '{gsub(/1/,"test")}{print $0}' test1 > temp && mv -f temp test1
===============================多个文件
vim strReplace.sh

#!/bin/bash 
#功能：利用awk批量读取并处理文件夹中的所有文件，并将处理结果输出到另一个文件夹中。 
#`ls`获取文件中所有文件的文件名 
#for循环读取`ls`中的值并赋值给文件名变量，awk依次利用这写文件名变量对文件进行处理。 
#
cd /home/dev/sbin
for file in *
do
	awk '{gsub(/test/,"home")}{print $0}' $file > temp && mv -f temp $file
done
```

### A , B两个文件比较

```
vim /home/dev/md-url.sh
	awk '{if ($1=="POST" && FILENAME!="data-govern-doc/md/接口规范.md") {print $2}}' data-govern-doc/md/*.md > md-url.txt
sh md-url.sh

vim /home/dev/sh convert-url.sh
	awk '{if($9=="url")print "/api-convert" $11}' convert-url.txt > filter-convert-url.txt
sh convert-url.sh

awk '/api-convert/' md-url.txt > filter-convert-md-url.txt

当需要比较A , B两个文件 , A文件中存在 , 并且把也在B文件中存在的行去除掉 , 可以使用这个awk的用法来
	awk '{if(ARGIND==1) {val[$0]}else{if($0 in val)  delete val[$0]}}END{for(i in val) print i}' A B
    使用awk的同时处理多文件功能,配合数组变量来进行处理
    先扫描文件A,把文件A中的每行作为数组的key放入数组
    再扫描文件B,判断B中的每行是否存在于数组中,如果存在就删除这个数组元素
    最后统一打印数组中的key

同时在file1和file2中的行：
	awk '{if(ARGIND==1) {val[$0]}else{if($0 in val) print $0}}' file1 file2
只在file1中有的行:
	awk '{if(ARGIND==1) {val[$0]}else{if($0 in val) delete val[$0]}}END{for(i in val) print i}' file1 file2
	或者：
	awk 'ARGIND==1{a[$0]}ARGIND>1&&!($0 in a){print $0}' file1 file2
只在file2中有的行:
	awk '{if(ARGIND==1) {val[$0]}else{if($0 in val) delete val[$0]}}END{for(i in val) print i}' file2 file1
```

## diff

```
结果中， 以 < 开头的行属于第一个文件，以 > 开头的行属于第二个文件，字母 a b c 分别表示 附加 删除 修改操作（上述结果中仅有c）。
diff -i filter*
```



## 用户

```
参考：
	https://www.runoob.com/linux/linux-user-manage.html
	
查看用户：		cat /etc/passwd
查看用户组：  	cat /etc/group
查看用户所属组：   groups user1
	
1、添加新的用户账号使用useradd命令，其语法如下：
useradd 选项 用户名
参数说明：
选项:
    -c comment 指定一段注释性描述。
    -d 目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
    -g 用户组 指定用户所属的用户组。
    -G 用户组，用户组 指定用户所属的附加组。
    -s Shell文件 指定用户的登录Shell。
    -u 用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。
用户名:
	指定新账号的登录名。
实例1
# useradd -s /sbin/nologin -d /home/ftp ftp
# useradd -d  /home/sam -m sam
此命令创建了一个用户sam，其中-d和-m选项用来为登录名sam产生一个主目录 /home/sam（/home为默认的用户主目录所在的父目录）。

实例2
# useradd -s /bin/sh -g group –G adm,root gem
此命令新建了一个用户gem，该用户的登录Shell是 /bin/sh，它属于group用户组，同时又属于adm和root用户组，其中group用户组是其主组。

这里可能新建组：#groupadd group及groupadd adm

增加用户账号就是在/etc/passwd文件中为新用户增加一条记录，同时更新其他系统文件如/etc/shadow, /etc/group等。

Linux提供了集成的系统管理工具userconf，它可以用来对用户账号进行统一管理。

2、删除帐号
如果一个用户的账号不再使用，可以从系统中删除。删除用户账号就是要将/etc/passwd等系统文件中的该用户记录删除，必要时还删除用户的主目录。

删除一个已有的用户账号使用userdel命令，其格式如下：

userdel 选项 用户名
常用的选项是 -r，它的作用是把用户的主目录一起删除。

例如：

# userdel -r sam
此命令删除用户sam在系统文件中（主要是/etc/passwd, /etc/shadow, /etc/group等）的记录，同时删除用户的主目录。
```

### 示例

```
sudo useradd -d /home/dev -g root -m dev -s /bin/bash 
sudo passwd dev
```



# ***<u>常用工具</u>***

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
## Jekins SSH Server配置

```
环境：A为jekins所在机器，B为需要发布应用的机器

B机器执行的操作
1、 生成rsa密钥, 会让输入保存位置，这里直接打回车，保存在/root/.ssh目录(-P 后面跟的是私钥密码)
    cd ~
    cd .ssh
    ssh-keygen -t rsa -P '当前用户密码'
    ssh-keygen -t rsa -P 'huitonedev'
    
2、注意下面要做的就是为上面Username处的用户配置公钥，本例中，在机器B上新建一个用户，用户名为 dev . 如果已有用户直接将id_rsa.pub追加到已有用户的authorized_keys文件中即可。
	将公钥导入authorized_keys文件，并修改文件权限：
	cat id_rsa.pub >> /home/dev/.ssh/authorized_keys
	chmod 600 /home/dev/.ssh/authorized_keys

3、配置 SSH Server
    查看刚才生成的密钥：
    cat id_rsa
	填写SSH Server配置界面,Passphrase/Password为刚才生成密钥时的密码：huitonedev，key为上面密钥内容

可能错误：
	ERROR: Exception when publishing, exception message [Exec exit status not zero. Status [1]]
	Build step 'Send files or execute commands over SSH' changed build result to UNSTABLE
原因：
	#jenkins使用非交互式shell，读取不到dev的环境变量，先加载dev的环境变量
处理：
.  /etc/profile
.  ~/.bash_profile

cd  /www/data_govern/jars/temp
mv */*/*.jar */*/*/*.jar  /www/data_govern/jars
true  > ~/env.log
env > ~/env.log
which java >> ~/env.log
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

## vim

```
插入命令
    i 在当前位置生前插入
    I 在当前行首插入
    a 在当前位置后插入
    A 在当前行尾插入
    o 在当前行之后插入一行
    O 在当前行之前插入一行

查找命令
    /text　　查找text，按n健查找下一个，按N健查找前一个。
    ?text　　查找text，反向查找，按n健查找下一个，按N健查找前一个。
    有一些特殊字符在查找时需要转义　　.*[]^%/?~$
    :set ignorecase　　忽略大小写的查找
    :set noignorecase　　不忽略大小写的查找
	查找很长的词，如果一个词很长，键入麻烦，可以将光标移动到该词上，按*或#键即可以该单词进行搜索，相当于/搜索。而#命令相当于?搜索。
    :set hlsearch　　高亮搜索结果，所有结果都高亮显示，而不是只显示一个匹配。
    :set nohlsearch　　关闭高亮搜索显示
    :nohlsearch　　关闭当前的高亮显示，如果再次搜索或者按下n或N键，则会再次高亮。
    :set incsearch　　逐步搜索模式，对当前键入的字符进行搜索而不必等待键入完成。
    :set wrapscan　　重新搜索，在搜索到文件头或尾时，返回继续搜索，默认开启。
    
替换命令
    ra 将当前字符替换为a，当期字符即光标所在字符。
    s/old/new/ 用old替换new，替换当前行的第一个匹配
    s/old/new/g 用old替换new，替换当前行的所有匹配
    %s/old/new/ 用old替换new，替换所有行的第一个匹配
    %s/old/new/g 用old替换new，替换整个文件的所有匹配
    :10,20 s/^/ /g 在第10行知第20行每行前面加四个空格，用于缩进。
    ddp 交换光标所在行和其下紧邻的一行。

移动命令
    h 左移一个字符
    l 右移一个字符，这个命令很少用，一般用w代替。
    k 上移一个字符
    j 下移一个字符
    以上四个命令可以配合数字使用，比如20j就是向下移动20行，5h就是向左移动5个字符，在Vim中，很多命令都可以配合数字使用，比如删除10个字符10x，在当前位置后插入3个！，3a！<Esc>，这里的Esc是必须的，否则命令不生效。
    w 向前移动一个单词（光标停在单词首部），如果已到行尾，则转至下一行行首。此命令快，可以代替l命令。
    b 向后移动一个单词 2b 向后移动2个单词
    e，同w，只不过是光标停在单词尾部
    ge，同b，光标停在单词尾部。
    ^ 移动到本行第一个非空白字符上。
    0（数字0）移动到本行第一个字符上，
    <HOME> 移动到本行第一个字符。同0健。
    $ 移动到行尾 3$ 移动到下面3行的行尾
    gg 移动到文件头。 = [[
    G（shift + g） 移动到文件尾。 = ]]
    f（find）命令也可以用于移动，fx将找到光标后第一个为x的字符，3fd将找到第三个为d的字符。
    F 同f，反向查找。
    跳到指定行，冒号+行号，回车，比如跳到240行就是 :240回车。另一个方法是行号+G，比如230G跳到230行。
    Ctrl + e 向下滚动一行
    Ctrl + y 向上滚动一行
    Ctrl + d 向下滚动半屏
    Ctrl + u 向上滚动半屏
    Ctrl + f 向下滚动一屏
    Ctrl + b 向上滚动一屏
    
撤销和重做
    u 撤销（Undo）
    U 撤销对整行的操作
    Ctrl + r 重做（Redo），即撤销的撤销。

删除命令
    x 删除当前字符
    3x 删除后三个字符
    X 删除前一个字符
    dl 删除当前字符   dl=x
    dh 删除前一个字符  dh=X
    dd 删除当前行
    dj 删除上一行
    dk 删除下一行
    2dd 删除下2行。
    D 删除当前字符之后的所有字符 D=d$
    d$ 删除当前字符之后的所有字符
    dgg 删除当前行之前所有行（不包括当前行）
    dG（d shift + g） 删除当前行之后所有行（不包括当前行）
    :1,10d 删除1-10行
    :11,$d 删除11行及以后所有的行
    :1,$d 删除所有行
    J(shift + j)　　删除两行之间的空行，实际上是合并两行。

拷贝和粘贴
    yy 拷贝当前行
    nyy 拷贝当前后开始的n行，比如2yy拷贝当前行及其下一行。
    p 在当前光标后粘贴,如果之前使用了yy命令来复制一行，那么就在当前行的下一行粘贴。
    shift+p 在当前行前粘贴
    :1,10 co 20 将1-10行插入到第20行之后。
    :1,$ co $ 将整个文件复制一份并添加到文件尾部。
    正常模式下按v（逐字）或V（逐行）进入可视模式，然后用jklh命令移动即可选择某些行或字符，再按y即可复制
    ddp交换当前行和其下一行
    xp交换当前字符和其后一个字符
    
剪切命令
    正常模式下按v（逐字）或V（逐行）进入可视模式，然后用jklh命令移动即可选择某些行或字符，再按d即可剪切
    ndd 剪切当前行之后的n行。利用p命令可以对剪切的内容进行粘贴
    :1,10d 将1-10行剪切。利用p命令可将剪切后的内容进行粘贴。
    :1, 10 m 20 将第1-10行移动到第20行之后。

退出命令
    :wq 保存并退出
    ZZ 保存并退出
    :q! 强制退出并忽略所有更改
    :e! 放弃所有修改，并打开原来文件。

窗口命令
    :split或new 打开一个新窗口，光标停在顶层的窗口上
    :split file或:new file 用新窗口打开文件
    split打开的窗口都是横向的，使用vsplit可以纵向打开窗口。
    Ctrl+ww 移动到下一个窗口
    Ctrl+wj 移动到下方的窗口
    Ctrl+wk 移动到上方的窗口

关闭窗口
    :close 最后一个窗口不能使用此命令，可以防止意外退出vim。
    :q 如果是最后一个被关闭的窗口，那么将退出vim。
    ZZ 保存并退出。
    关闭所有窗口，只保留当前窗口
    :only

录制宏
	按q键加任意字母开始录制，再按q键结束录制（这意味着vim中的宏不可嵌套），使用的时候@加宏名，比如qa。。。q录制名为a的宏，@a使用这个宏。

执行shell命令
    :!command
    :!ls 列出当前目录下文件
    :!perl -c script.pl 检查perl脚本语法，可以不用退出vim，非常方便。
    :!perl script.pl 执行perl脚本，可以不用退出vim，非常方便。
    :suspend或Ctrl - Z 挂起vim，回到shell，按fg可以返回vim。

注释命令
    perl程序中#开始的行为注释，所以要注释某些行，只需在行首加入#
    3,5 s/^/#/g 注释第3-5行
    3,5 s/^#//g 解除3-5行的注释
    1,$ s/^/#/g 注释整个文档。
    :%s/^/#/g 注释整个文档，此法更快。

帮助命令
    :help or F1 显示整个帮助
    :help xxx 显示xxx的帮助，比如 :help i, :help CTRL-[（即Ctrl+[的帮助）。
    :help 'number' Vim选项的帮助用单引号括起
    :help <Esc> 特殊键的帮助用<>扩起
    :help -t Vim启动参数的帮助用-
    ：help i_<Esc> 插入模式下Esc的帮助，某个模式下的帮助用模式_主题的模式
    帮助文件中位于||之间的内容是超链接，可以用Ctrl+]进入链接，Ctrl+o（Ctrl + t）返回

其他非编辑命令
    . 重复前一次命令
    :set ruler?　　查看是否设置了ruler，在.vimrc中，使用set命令设制的选项都可以通过这个命令查看
    :scriptnames　　查看vim脚本文件的位置，比如.vimrc文件，语法文件及plugin等。
    :set list 显示非打印字符，如tab，空格，行尾等。如果tab无法显示，请确定用set lcs=tab:>-命令设置了.vimrc文件，并确保你的文件中的确有tab，如果开启了expendtab，那么tab将被扩展为空格。
    :set paste 粘贴时不缩进。
```

### 可视模式下不能复制问题

```
vim /usr/share/vim/vim81/defaults.vim
/mouse搜索关键词mouse
将 set mouse=a 改为set mouse-=a（在等号前面加上一个减号）
输入:wq! 保存即可解决问题。
```



## ODBC 

```
1.查看操作系统上查看ODBC版本
	[dmdba@localhost]# odbc_config --version

2.查看ODBC配置文件存放的位置
	[root@localhost etc]# odbc_config --odbcini
	[root@localhost etc]# odbc_config --odbcinstini

3.修改odbc.ini文件
	[dmdba@localhost]# vim /etc/odbc.ini
    [dm]
    Deion = DM ODBC DSN
    Driver = DM7 ODBC DRIVER
    SERVER = localhost
    UID = SYSDBA
    PWD = SYSDBA
    TCP_PORT = 5236

4.修改odbcinst.ini文件
    [dmdba@localhost]# vi /etc/odbcinst.ini
    [DM7 ODBC DRIVER]
    Deion = ODBC DRIVER FOR DM7
    Driver = /opt/dmdbms/bin/libdodbc.so

5.测试连接
	[root@localhost]# isql dm SYSDBA SYSDBA
	
注意配置环境变量LD_LIBRARY_PATH(动态库的查找路径)，示例：
LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64::/usr/lib/oracle/11.2/client64/lib:/usr/local/dm7client/bin/:/usr/local/dm7client/drivers/odbc/
```



# ***<u>文件</u>***

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
## zip

```
压缩服务器上当前目录的内容为xxx.zip文件
	zip -r xxx.zip ./*

解压zip文件到当前目录
	unzip filename.zip

另：有些服务器没有安装zip包执行不了zip命令，但基本上都可以用tar命令的
```



## find

```
find / -name '*.logout*' 2>/dev/null
find . -type f -name *.svn*    | xargs rm -f
find . -name \*52\* 
```

## grep

```
grep LD /etc/profile.d/*.sh /etc/bash.bashrc
```

## mv

```
mv `ls|grep -v "test"` test
sudo mv `\ls libdm*.so|grep -v libdmmp.so` temp
sudo mv `ll lib*.so|grep dmdba|awk '{print $9}'` temp
```



## cp

```
cp -r svg/* /usr/local/apache2/htdocs/inc_chk/new_index/svg/
\cp ： 不询问
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

## 清空文件5种方法

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


# ***<u>日志</u>***

```
遇事先看 /var/log/secure 和 /var/log/messages

```

