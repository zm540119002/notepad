**参考**

```
https://www.mongodb.org.cn/
https://www.runoob.com/mongodb/mongodb-connections.html
```

#### **注意事项**

```
数据库也通过名字来标识。数据库名可以是满足以下条件的任意UTF-8字符串。
    不能是空字符串（"")。
    不得含有' '（空格)、.、$、/、\和\0 (空宇符)。
    应全部小写。
    最多64字节。
    有一些数据库名是保留的，可以直接访问这些有特殊作用的数据库。
文档中的键/值对是有序的。
文档中的值不仅可以是在双引号里面的字符串，还可以是其他几种数据类型（甚至可以是整个嵌入的文档)。
MongoDB区分类型和大小写。
MongoDB的文档不能有重复的键。
文档的键是字符串。除了少数例外情况，键可以使用任意UTF-8字符。
文档键命名规范：

键不能含有\0 (空字符)。这个字符用来表示键的结尾。
.和$有特别的意义，只有在特定环境下才能使用。
以下划线"_"开头的键是保留的(不是严格要求的)。
```

#### **概念解析**

```
默认数据库：   
    admin： 从权限的角度来看，这是"root"数据库。要是将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。
    	一些特定的服务器端命令也只能从这个数据库运行，比如列出所有的数据库或者关闭服务器。
    local: 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合
    config: 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息。
```

```
数据类型：
    String	字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。
    Integer	整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。
    Boolean	布尔值。用于存储布尔值（真/假）。
    Double	双精度浮点值。用于存储浮点值。
    Min/Max keys	将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。
    Arrays	用于将数组或列表或多个值存储为一个键。
    Timestamp	时间戳。记录文档修改或添加的具体时间。
    Object	用于内嵌文档。
    Null	用于创建空值。
    Symbol	符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。
    Date	日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。
    Object ID	对象 ID。用于创建文档的 ID。
    Binary Data	二进制数据。用于存储二进制数据。
    Code	代码类型。用于在文档中存储 JavaScript 代码。
    Regular expression	正则表达式类型。用于存储正则表达式

```



#### **常用**

```
show databases; 或 show dbs; //查看当前的数据库
use databaseName  选择库
show tables/collections 查看当前库下的collections
db.createCollection('collectionName');  //创建collection
collection 允许隐式创建
db.collectionName.insert(document);
db.collectionName.drop();       /删除collection
```

#### **启动**&关闭

```
安装目录/bin下，有一个叫mongod.exe的应用程序，这个程序就是用来启动你的mongodb服务器的。
在你想要存放数据的地方，新建一个文件夹，如db，我们推荐的数据库目录设置是：
data/
	conf	-->配置文件目录
		mongod.conf		-->配置文件
	db		-->数据库目录
	log		-->日志文件目录
		mongodb.log		-->日志记录文件
#启动
	/usr/local/mongoDB/bin/mongod --config /usr/local/mongoDB/data/conf/mongod.conf
	#auth方式启动
	/usr/local/mongoDB/bin/mongod --auth --config /usr/local/mongoDB/data/conf/mongod.conf
#关闭
	/usr/local/mongoDB/bin/mongod --config /usr/local/mongoDB/data/conf/mongod.conf --shutdown
    mongod.conf内容示例：
        port=27017 ##端口,默认27017,可以自定义
        dbpath= /usr/local/mongoDB/data/db ##数据文件存放目录
        logpath= /usr/local/mongoDB/data/logs/mongodb.log ##日志文件存放目录
        logappend=true ##开启日志追加添加日志
        fork=true ##以守护程序的方式启用，即在后台运行
        auth=true ##开启认证
        bind_ip=0.0.0.0 #开启远程连接
        
mongodb常用启动参数如下
    参数			描述
    --bind_ip	绑定服务IP，若绑定127.0.0.1，则只能本机访问，不指定默认本地所有IP
    --logpath	定MongoDB日志文件，注意是指定文件不是目录
    --logappend	使用追加的方式写日志
    --dbpath	指定数据库路径
    --port	指定服务端口号，默认端口27017
    --serviceName	指定服务名称
    --serviceDisplayName	指定服务名称，有多个mongodb服务时执行。
    --install	指定作为一个Windows服务安装。   
```

#### **数据库操作**

```
mongodb安装好后第一次进入是不需要密码的，也没有任何用户。在安装MongoDB之后，先关闭auth认证，启动服务端。
需要创建一个帐号，该账号需要有grant权限，即：账号管理的授权权限。注意一点，帐号是跟着库走的，所以在指定库里授权，必须也在指定库里验证(auth)。

#use dbName 如果数据库不存在，则创建数据库，否则切换到指定数据库。
use admin
db.createUser({user: "admin",pwd: "123456",roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]})

刚建立了 userAdminAnyDatabase 角色，用来管理用户，可以通过这个角色来创建、删除用户。
开启auth参数，认证通过后才能访问数据库。

use datastation
可以看到，我们刚创建的数据库 datastation 并不在数据库的列表中， 要显示它，我们需要向 datastation 数据库插入一些数据。
db.datastation.insert({"test":"测试数据"})
show dbs
show collections

MongoDB 中默认的数据库为 test，如果你没有创建新的数据库，集合将存放在 test 数据库中。
注意: 在 MongoDB 中，集合只有在内容插入后才会创建! 就是说，创建集合(数据表)后要再插入一个文档(记录)，集合才会真正创建。

MongoDB 删除数据库的语法格式如下：
db.dropDatabase()
删除当前数据库，默认为 test，你可以使用 db 命令查看当前数据库名。
```

#### **文档操作**

```
#创建集合语法格式如下：
db.createCollection("runoob") 
	show tables

#删除集合语法格式如下：
db.collection.drop()
	db.runoob.drop()
	show tables
	
在 MongoDB 中，你不需要创建集合。当你插入一些文档时，MongoDB 会自动创建集合。
db.mycol2.insert({"name" : "菜鸟教程"})
show tables

update() 方法用于更新已存在的文档。语法格式如下：
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
参数说明：
    query : update的查询条件，类似sql update查询内where后面的。
    update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
    upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
    multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
    writeConcern :可选，抛出异常的级别。
实例：
    db.col.insert({
        title: 'MongoDB 教程', 
        description: 'MongoDB 是一个 Nosql 数据库',
        by: '菜鸟教程',
        url: 'http://www.runoob.com',
        tags: ['mongodb', 'database', 'NoSQL'],
        likes: 100
    })
    db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})
    db.col.find().pretty()
    上语句只会修改第一条发现的文档，如果你要修改多条相同的文档，则需要设置 multi 参数为 true。
    db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}},{multi:true})

save() 方法通过传入的文档来替换已有文档，_id 主键存在就更新，不存在就插入。语法格式如下：
db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)
参数说明：
    document : 文档数据。
    writeConcern :可选，抛出异常的级别。
实例：
    以下实例中我们替换了 _id 为 56064f89ade2f21f36b03136 的文档数据：
    db.col.save({
        "_id" : ObjectId("56064f89ade2f21f36b03136"),
        "title" : "MongoDB",
        "description" : "MongoDB 是一个 Nosql 数据库",
        "by" : "Runoob",
        "url" : "http://www.runoob.com",
        "tags" : [
                "mongodb",
                "NoSQL"
        ],
        "likes" : 110
    })
    替换成功后，我们可以通过 find() 命令来查看替换后的数据
    db.col.find().pretty()
    {
            "_id" : ObjectId("56064f89ade2f21f36b03136"),
            "title" : "MongoDB",
            "description" : "MongoDB 是一个 Nosql 数据库",
            "by" : "Runoob",
            "url" : "http://www.runoob.com",
            "tags" : [
                    "mongodb",
                    "NoSQL"
            ],
            "likes" : 110
    }
```



#### **远程连接**

```
标准格式：
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
	示例： mongo mongodb://htgx:htgx@172.16.6.35:27017/admin
其他格式：mongo -u username -p pwd host:post/database(数据库名)
	示例： mongo -u htgx -p htgx 172.16.6.35:27017/admin

当该用户有相应权限时,可以查看collection==>查看集合命令:show collections
```
#### **导入导出**

```
备份数据库命令：mongodump -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -o 文件存在路径
	示例： 
	mongodump -h 172.16.6.35 --port 27017 -u htgx -p htgx -o /usr/local/mongo_bak_6_35
详细解释：
　　　　-h：mongodb所在的服务器地址（必须指定端口），不指定的话就是本地的127.0.0.1:27017
　　　　-u：用户名
　　　　-p：密码
　　　　-d：需要备份的数据库（导出整个mongodb就去掉）
　　　　-o：备份的数据存放的位置

恢复数据库命令: mongorestore -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 --drop 文件存在路径
--drop是先删除所有的数据，再恢复，不需要删除可不加;

mongoexport导出表，或导出表中部分字段：
命令格式：mongoexport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 -f 字段 -q 条件导出 --csv -o 文件名的具体路径(后缀格式可以是.dat或.csv);

mongoimport导入表，或者表中部分字段 ：
1.还原整表导出的非csv文件
　　　命令格式：mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --upsert --drop 文件名的具体路径   
　　　(--drop当不需要删除源文件可不加)
2.还原部分字段的导出文件
　　命令格式：mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --upsertFields 字段 --drop 文件名的具体路径 
　　(--drop当不需要删除源文件可不加)
3.还原导出的csv文件（导出数据时如果不加--csv选项，导出的数据就会存在很多双引号，导入就会失败）
　　命令格式：mongoimport -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -c 表名 --type 类型(csv) 
　　--headerline --upsert --drop 文件名的具体路径  

注意：如果数据库存在数据，要导入最新的数据，则需要加--upsert选项，会更新数据，否则会报错(提示重复键错误收集)
```
####  **迁移**

```
使用mongo自带命令来迁移数据，思路是先导出集合数据再导入到数据库中

导出命令：mongoexport
语法：mongoexport -d dbname -c collectionname -o filepath --type json/csv -f field
    -d：数据库名
    -c：集合名称
    -o : 导出数据文件的路径
    -type : 导出数据类型，默认json
关键参数说明：
    -h,--host ：代表远程连接的数据库地址，默认连接本地Mongo数据库；
    --port：代表远程连接的数据库的端口，默认连接的远程端口27017；
    -u,--username：代表连接远程数据库的账号，如果设置数据库的认证，需要指定用户账号；
    -p,--password：代表连接数据库的账号对应的密码；
    -d,--db：代表连接的数据库；
    -c,--collection：代表连接数据库中的集合；
    -f, --fields：代表集合中的字段，可以根据设置选择导出的字段；
    --type：代表导出输出的文件类型，包括csv和json文件；
    -o, --out：代表导出的文件名；
    -q, --query：代表查询条件；
    --skip：跳过指定数量的数据；
    --limit：读取指定数量的数据记录；
    --sort：对数据进行排序，可以通过参数指定排序的字段，并使用 1 和 -1 来指定排序的方式，其中 1 为升序排列，而-1是用于降序排列,如sort({KEY:1})。
注意：
　　当查询时同时使用sort,skip,limit，无论位置先后，最先执行顺序 sort再skip再limit。
　　
导入命令：mongoimport
语法：mongoimport -d dbname -c collectionname --file filename --headerline --type json/csv -f field
    -d：数据库名
    -c：集合名称
    --file : 选择导入的文件
    -type : 文件类型，默认json
    -f : 字段，type为csv是必须设置此项
关键参数说明：
    -h,--host ：代表远程连接的数据库地址，默认连接本地Mongo数据库；
    --port：代表远程连接的数据库的端口，默认连接的远程端口27017；
    -u,--username：代表连接远程数据库的账号，如果设置数据库的认证，需要指定用户账号；
    -p,--password：代表连接数据库的账号对应的密码；
    -d,--db：代表连接的数据库；
    -c,--collection：代表连接数据库中的集合；
    -f, --fields：代表导入集合中的字段；
    --type：代表导入的文件类型，包括csv和json,tsv文件，默认json格式；
    --file：导入的文件名称
    --headerline：导入csv文件时，指明第一行是列名，不需要导入；
```
```
完整示例：
172.16.7.57:
	mongoexport -d datastation -o /usr/local/mongo_bak_7_57/databank-authapi -c databank-authapi
	mongoexport -d datastation -o /usr/local/mongo_bak_7_57/databank-dbserver -c databank-dbserver
172.16.6.35:
	mongoimport -d datastation -c databank-authapi --file /usr/local/mongo_bak_7_57/databank-authapi
	mongoimport -d datastation -c databank-dbserver --file /usr/local/mongo_bak_7_57/databank-dbserver
```



####  **认证**

```
1、当开启了安全检查之后，只有通过身份认证的用户才能进行数据的读写操作
2、admin和local是两个特殊的数据库，它们当中的用户可对任何数据库进行操作
3、经认证后，管理员用户可对任何数据库进行读写操作，同时能执行只有管理员才能执行的命令
4、在开启了安全检查的数据库启动前，应至少添加一个管理员用户
```
#### **角色**

```
Built-In Roles（内置角色）：
    1. 数据库用户角色：read、readWrite;
    2. 数据库管理角色：dbAdmin、dbOwner、userAdmin；
    3. 集群管理角色：clusterAdmin、clusterManager、clusterMonitor、hostManager；
    4. 备份恢复角色：backup、restore；
    5. 所有数据库角色：readAnyDatabase、readWriteAnyDatabase、userAdminAnyDatabase、dbAdminAnyDatabase
    6. 超级用户角色：root  
    // 这里还有几个角色间接或直接提供了系统超级用户的访问（dbOwner 、userAdmin、userAdminAnyDatabase）
    7. 内部角色：__system
    
具体角色的功能： 
    Read：允许用户读取指定数据库
    readWrite：允许用户读写指定数据库
    dbAdmin：允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
    userAdmin：允许用户向system.users集合写入，可以找指定数据库里创建、删除和管理用户
    clusterAdmin：只在admin数据库中可用，赋予用户所有分片和复制集相关函数的管理权限。
    readAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读权限
    readWriteAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读写权限
    userAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的userAdmin权限
    dbAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的dbAdmin权限。
    root：只在admin数据库中可用。超级账号，超级权限
    
数据库用户角色
    read: 只读数据权限
    readWrite:学些数据权限
数据库管理角色
    dbAdmin: 在当前db中执行管理操作的权限
    dbOwner: 在当前db中执行任意操作
    userADmin: 在当前db中管理user的权限
备份和还原角色
    backup
    restore
夸库角色
    readAnyDatabase: 在所有数据库上都有读取数据的权限
    readWriteAnyDatabase: 在所有数据库上都有读写数据的权限
    userAdminAnyDatabase: 在所有数据库上都有管理user的权限
    dbAdminAnyDatabase: 管理所有数据库的权限
集群管理
    clusterAdmin: 管理机器的最高权限
    clusterManager: 管理和监控集群的权限
    clusterMonitor: 监控集群的权限
    hostManager: 管理Server
超级权限
	root: 超级用户
自定义角色
	内置角色只能控制User在DB级别上执行的操作，管理员可以创建自定义角色，控制用户在集合级别（Collection-Level）上执行的操作，
	即，控制User在当前DB的特定集合上执行特定的操作
```



####  **用户**

```
use admin
#查看已存在的用户
db.system.users.find().pretty()
show users
#删除用户
db.system.users.remove({user:"root"})
db.system.users.remove({"db" : "datastations"})

user：用户名
pwd：密码
db：指定该用户的数据库，admin是用于权限控制的数据库，如果没有需要新建一个
roles：指定用户的角色，可以用一个空数组给新用户设定空角色；在roles字段,可以指定内置角色和用户定义的角色。

创建超级用户
	安装完之后，打开命令行，进入mongodb安装目录，在bin目录下执行 mongod 启动， 该模式是不需要安全认证的模式，
	先创建一个有grant权限的用户，如root权限的用户：
	> use admin
    switched to db admin
    > 
    > db.createUser({
    	user:"admin",
    	pwd:"admin",
    	roles:[{role:"root",db:"admin"}]
	})
	创建root用户以便运行superuser才能运行的命令(比如db.shutdownServer()命令只有在admin数据库下由下面的用户执行才能成功)
	db.createUser({
    	user:"root",
    	pwd:"root",
    	roles:[{role:"root",db:"admin"}]
	})
	db.auth("root","root")
```
```
创建所有数据库管理用户
	db.createUser({ user: "useradmin", pwd: "123456", roles: [{ role: "userAdminAnyDatabase", db: "admin" }] })
```

```
创建普通用户
    db.createUser({
        user:"htgx",
        pwd:"123456",
        roles:[
            {role:"read", db:"datastation"},
            {role:"readWrite", db:"datastation"}
        ]
    })
注：添加完用户后可以使用show users或db.system.users.find()查看已有用户
```

```
删除用户

切换到用户授权的db
use xx

执行删除操作
db.dropUser("username")
```

```
更新用户

切换到用户授权的db
use xx

执行更新
字段会覆盖原来的内容

db.updateUser("username",{
    pwd:"new password",
    customData:{
        "title":"PHP developer"
    }
})
```

```
更新用户密码

use xx
db.changeUserPassword("username","newpassword")
```

```
删除用户角色

use xx

db.revokeRolesFromUser(
    "usename",
    [
      { role: "readWrite", db: "accounts" }
    ]
)
```

```
添加用户角色

use xx

db.grantRolesToUser(
    "reportsUser",
    [
      { role: "read", db: "accounts" }
    ]
)
```

```
角色管理

自定义角色

自定义角色保存在admin数据库system.roles集合中

切换到admin数据库
use admin

执行添加

db.createRole({
     role: "manageOpRole",
     privileges: [
       { resource: { cluster: true }, actions: [ "killop", "inprog" ] },
       { resource: { db: "", collection: "" }, actions: [ "killCursors" ] }
     ],
     roles: []
}
```

```
删除角色

use admin
db.dropRole("rolename")
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
