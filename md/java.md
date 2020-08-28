#### **常用**

```

```


#### **注解**

```
@Service用于标注业务层组件
@Controller用于标注控制层组件（如struts中的action）
@Repository用于标注数据访问组件，即DAO组件
@Component泛指组件，当组件不好归类的时候，我们可以使用这个注解进行标注。

@Bean 基础声明
Spring的@Bean注解用于告诉方法，产生一个Bean对象，然后这个Bean对象交给Spring管理。产生这个Bean对象的方法Spring只会调用一次，随后这个Spring将会将这个Bean对象放在自己的IOC容器中。
```
#### **注意事项**

```
在Spring中对于bean的默认处理都是单例的，我们通过上下文容器.getBean方法拿到bean容器，并对其进行实例化，这个实例化的过程其实只进行一次，即多次getBean 获取的对象都是同一个对象，也就相当于这个bean的实例在IOC容器中是public的，对于所有的bean请求来讲都可以共享此bean。

字符串用equals ,例如："".equals(yourStr)
```
#### **Future机制**

```
常见的两种创建线程的方式。一种是直接继承Thread，另外一种就是实现Runnable接口。
这两种方式都有一个缺陷就是：在执行完任务之后无法获取执行结果。
从Java 1.5开始，就提供了Callable和Future，通过它们可以在任务执行完毕之后得到任务执行结果。
Future模式的核心思想是能够让主线程将原来需要同步等待的这段时间用来做其他的事情。（因为可以异步获得执行结果，所以不用一直同步等待去获得执行结果）
```
####  **泛型**

```
顾名思义，就是将类型由原来的具体的类型参数化，类似于方法中的变量参数，此时类型也定义成参数形式（可以称之为类型形参），
然后在使用/调用时传入具体的类型（类型实参）。
泛型的本质是为了参数化类型（在不创建新的类型的情况下，通过泛型指定的不同类型来控制形参具体限制的类型）。也就是说在泛型使用过程中，
操作的数据类型被指定为一个参数，这种参数类型可以用在类、接口和方法中，分别被称为泛型类、泛型接口、泛型方法。

一个被举了无数次的例子：
List arrayList = new ArrayList();
arrayList.add("aaaa");
arrayList.add(100);
for(int i = 0; i< arrayList.size();i++){
    String item = (String)arrayList.get(i);
    Log.d("泛型测试","item = " + item);
}
毫无疑问，程序的运行结果会以崩溃结束：
java.lang.ClassCastException: java.lang.Integer cannot be cast to java.lang.String
ArrayList可以存放任意类型，例子中添加了一个String类型，添加了一个Integer类型，再使用时都以String的方式使用，因此程序崩溃了。为了解决类似这样的问题（在编译阶段就可以解决），泛型应运而生。
我们将第一行声明初始化list的代码更改一下，编译器会在编译阶段就能够帮我们发现类似这样的问题。
List<String> arrayList = new ArrayList<String>();
...
//arrayList.add(100); 在编译阶段，编译器就会报错

泛型只在编译阶段有效。看下面的代码：
List<String> stringArrayList = new ArrayList<String>();
List<Integer> integerArrayList = new ArrayList<Integer>();

Class classStringArrayList = stringArrayList.getClass();
Class classIntegerArrayList = integerArrayList.getClass();

if(classStringArrayList.equals(classIntegerArrayList)){
    Log.d("泛型测试","类型相同");
}
输出结果：D/泛型测试: 类型相同。

通过上面的例子可以证明，在编译之后程序会采取去泛型化的措施。也就是说Java中的泛型，只在编译阶段有效。在编译过程中，正确检验泛型结果后，会将泛型的相关信息擦出，并且在对象进入和离开方法的边界处添加类型检查和类型转换的方法。也就是说，泛型信息不会进入到运行时阶段。

对此总结成一句话：泛型类型在逻辑上看以看成是多个不同的类型，实际上都是相同的基本类型。

泛型有三种使用方式，分别为：泛型类、泛型接口、泛型方法

注意：
    泛型的类型参数只能是类类型，不能是简单类型。
    不能对确切的泛型类型使用instanceof操作。如下面的操作是非法的，编译时会出错。
    	if(ex_num instanceof Generic<Number>){ }
参考：	https://www.cnblogs.com/coprince/p/8603492.html
```
####  **idea-2020.1**

```
参考： https://www.jianshu.com/p/6b705a286be7
```
####  **maven**

*Linux安装*

```
cd /usr/local/src
	wget https://zysd-shanghai.oss-cn-shanghai.aliyuncs.com/software/linux/maven/apache-maven-3.6.1-bin.tar.gz
	tar -zxvf apache-maven-3.6.1-bin.tar.gz -C /usr/local
	cd ../apache-maven-3.6.1
	
环境变量
	1. 编辑环境变量
	vim /etc/profile

	2. 添加Maven的M2_HOME地址
	export M2_HOME=/usr/local/apache-maven-3.6.1
	export PATH=$PATH:$M2_HOME/bin

	3. 保存配置文件
	source /etc/profile
验证是否成功安装
	mvn -version
	
配置maven的镜像仓库
	vim  conf/settings.xml 
	<!-- 指定b本地仓库 -->
	<localRepository>/usr/local/apache-maven-3.6.1/repo</localRepository>
	
	设置镜像，在mirrors节点添加以下节点
	<!-- 从阿里云镜像下载jar包 -->
	<mirrors>
		<mirror>
			<id>alimaven</id>
			<name>aliyun maven</name>
			<url>http://maven.aliyun.com/nexus/content/groups/public/</url>
			<mirrorOf>central</mirrorOf>        
		</mirror>
	</mirrors>
	
	<!-- 指定jdk1.8 -->
	 <profiles>
		<profile>
                <id>jdk1.8</id>
                <activation>
                <activeByDefault>true</activeByDefault>
                <jdk>1.8</jdk>
                </activation>
                <properties>
                        <maven.compiler.source>1.8</maven.compiler.source>
                        <maven.compiler.target>1.8</maven.compiler.target>                        
						<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
                </properties>
        </profile>
	</profiles>

去到pom.xml 目录下
mvn -compire
参考： https://www.linuxidc.com/linux/2020-04/162861.htm
```

*完整示例：172.16.7.57*

```
cd /usr/local/web/data-govern/data-govern
mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true 
\cp target/data-govern-0.0.1-SNAPSHOT.jar /www/data_govern/jars/
ps -ef|grep java
kill 27985 #(pid)
tail -f /www/data_govern/jars/data-govern-0.0.1-SNAPSHOT.log
nohup java -Xdebug -Xrunjdwp:transport=dt_socket,address=48089,server=y,suspend=n -Dspring.profiles.active=dev -jar /www/data_govern/jars/data-govern-0.0.1-SNAPSHOT.jar >> /www/data_govern/logs/data-govern-0.0.1-SNAPSHOT.log 2>&1 &
```

```
\cp /usr/local/web/data-govern/*/target/*.jar /usr/local/web/data-govern/*/*/target/*.jar /www/data_govern/jars/
cp /usr/local/web/data-govern/*/target/*.jar /usr/local/web/data-govern/*/*/target/*.jar /www/data_govern/jars/
```

*可能错误：There are test failures*

*解决：	maven 打包跳过单元测试*

```
mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true 
mvn clean install -P dev -Dmaven.test.skip=true -Dmaven.javadoc.skip=true
```

*settings.xml（windows路径：C:\Users\Administrator\.m2）*

```
<?xml version="1.0" encoding="UTF-8"?>
 <!-- 英文注释已经被删除了，直接修改本地仓库地址用就行了。 -->
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
   <!-- 设置本地仓库的地址 -->
  <localRepository>C:\Users\Administrator\.m2\repository</localRepository>
  <pluginGroups>
  </pluginGroups>
  <proxies>
  </proxies> 
  <servers>  
  </servers>
 <!-- 设置国内的镜像 -->
    <mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
  </mirrors>
  <profiles>
  </profiles>
</settings>
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