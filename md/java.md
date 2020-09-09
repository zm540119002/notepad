# **常用**

```

```

# **概念解析**

## spring ioc

```
pring IOC容器是框架的核心，IOC是控制反转的意思，可以用来降低程序代码之间的耦合度。把强耦合的代码依赖从代码中移出去，放到统一的XML配置文件中，将程序对组件的主要控制权交给IOC，由IOC统一加载和管理。例如，可以把本案例中的JavaBean组件的创建、实体类的创建、以及JavaBean组件的属性注入等代码从Principal类移出，放入到Spring的XML配置文件中。这样就实现了Principal类与JavaBean组件的代码解耦，也解决了项目案例技术架构所存在的问题。

Spring IOC容器的核心是把程序业务代码与事物（组件、POJO类）代码进行分离，程序有关事物的创建、属性和依赖对象的注入、以及生命周期交由容器进行加载和管理。业务代码只需从容器中获取组件或POJO实例对象即可，无需再考虑组件之间、组件与POJO之间的依赖关系以及属性的注入。
```



## spring 

## spring mvc

## spring boot

# 注解

## spring

### 综合

```
https://www.jianshu.com/p/21f3e074e91a
```

### @Configuration

```
用于定义配置类，可替换XML配置文件，被注解的类内部包含一个或多个@Bean注解方法。可以被AnnotationConfigApplicationContext或者AnnotationConfigWebApplicationContext 进行扫描。用于构建bean定义以及初始化Spring容器。

标注在类上，该类会被CGLIB动态代理生成子类，可以达到这样的效果：在某@Bean方法下调用另一个标注了@Bean的方法，得到的会是同一个Bean对象；
@Configuration
public class AppConfig {
    @Bean
    public Man getMan() {
        Man man = new Man();
        man.setName("吕彬彬");
        man.setAge(23);
        return man;
    }
    
    @Bean
    public Man getMan2() {
        return getMan();
    }
}
获取bean会发现getMan和getMan2对象是同一个对象，去掉Configuration的话就是两个不同的对象
@Configuration注解注意点：
    1.可以作为Component标签使用；  
    2.标注的类不能是final类型的（final类无法动态代理生成子类）；
    3.注解类里的@Bean对象的id默认是方法名，如果设置了@Bean的name或者value属性，取第一个作为beanId，name中其他的作为别名使用；
    4. 标注了@Configuration的类不能是普通内部类，如果非要是个内部类，那就静态内部类也是可以的； 因为普通内部类依赖于外部类的存在；
```

### @Bean

参考： https://www.cnblogs.com/javazhiyin/p/11175068.html

```
Spring的@Bean注解用于告诉方法，产生一个Bean对象，然后这个Bean对象交给Spring管理。产生这个Bean对象的方法Spring只会调用一次，随后这个Spring将会将这个Bean对象放在自己的IOC容器中。

SpringIOC 容器管理一个或者多个bean，这些bean都需要在@Configuration注解下进行创建，在一个方法上使用@Bean注解就表明这个方法需要交给Spring进行管理。

@Bean另外一个重要的功能是能够和其他注解产生化学反应，@profile,@scope,@lazy,@depends-on @primary等
```

### @Profile

```
@Profile的作用是把一些meta-data进行分类，分成Active和InActive这两种状态，然后你可以选择在active 和在Inactive这两种状态下配置bean，在Inactive状态通常的注解有一个！操作符，通常写为：@Profile("!p")，这里的p是Profile的名字。

三种设置方式：

可以通过ConfigurableEnvironment.setActiveProfiles()以编程的方式激活

可以通过AbstractEnvironment.ACTIVE_PROFILES_PROPERTY_NAME (spring.profiles.active )属性设置为JVM属性

作为环境变量，或作为web.xml 应用程序的Servlet 上下文参数。也可以通过@ActiveProfiles 注解在集成测试中以声明方式激活配置文件。

作用域

作为类级别的注释在任意类或者直接与@Component 进行关联，包括@Configuration 类

作为原注解，可以自定义注解

作为方法的注解作用在任何方法

注意:

如果一个配置类使用了Profile 标签或者@Profile 作用在任何类中都必须进行启用才会生效，如果@Profile({"p1","!p2"}) 标识两个属性，那么p1 是启用状态 而p2 是非启用状态的。
```

## spring mvc

### @Value

```
该注解的作用是将我们配置文件的属性读出来，有@Value(“${}”)和@Value(“#{}”)两种方式
${ property : default_value }
#{ obj.property? :default_value }
第一个注入的是外部配置文件对应的property，第二个则是SpEL表达式对应的内容。 
那个default_value，就是前面的值为空时的默认值。注意二者的不同，#{}里面那个obj代表对象。
${}:用于获取配置文件中的属性值，通常用于获取写在application.properties中的内容，例如：@Value(""${jdbc.url})
#{}:用于获取SpEL表达式的值，可以表示常量的值，或者获取bean中的属性
注意事项
    将配置文件交给sping加载,最好不要交给springMVC加载 避免出现错误,因为web.xml配置时spring的监听先启动,
    springMVC的Dispatcherservlet接收到请求时初始化springMVC的配置文件。
```

## spring boot

```
@Service用于标注业务层组件
@Controller用于标注控制层组件（如struts中的action）
@Repository用于标注数据访问组件，即DAO组件
@Component泛指组件，当组件不好归类的时候，我们可以使用这个注解进行标注。

```
# **注意事项**

```
在Spring中对于bean的默认处理都是单例的，我们通过上下文容器.getBean方法拿到bean容器，并对其进行实例化，这个实例化的过程其实只进行一次，即多次getBean 获取的对象都是同一个对象，也就相当于这个bean的实例在IOC容器中是public的，对于所有的bean请求来讲都可以共享此bean。

1.先判断null，再判断equals("")
2.字符串用equals ,例如："".equals(yourStr)
```
# **Future机制**

```
常见的两种创建线程的方式。一种是直接继承Thread，另外一种就是实现Runnable接口。
这两种方式都有一个缺陷就是：在执行完任务之后无法获取执行结果。
从Java 1.5开始，就提供了Callable和Future，通过它们可以在任务执行完毕之后得到任务执行结果。
Future模式的核心思想是能够让主线程将原来需要同步等待的这段时间用来做其他的事情。（因为可以异步获得执行结果，所以不用一直同步等待去获得执行结果）
```
#  **泛型**

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
# *IntelliJ IDEA-2020.1*

```
参考： https://www.jianshu.com/p/6b705a286be7
```
## *常用插件（plugin）*

```
Lombok
	开发神器，可以简化你的实体类，让你i不再写get/set方法，还能快速的实现builder模式，以及链式调用方法，总之就是为了简化实体类而生的插件。
CamelCase
	将不是驼峰格式的名称，快速转成驼峰格式，安装好后，选中要修改的名称，按快捷键shift+alt+u
GsonFormat 
	把 JSON 字符串直接实例化成类
Grep console
	自定义日志颜色，idea控制台可以彩色显示各种级别的log，安装完成后，在console中右键就能打开，
	并且可以设置不同的日志级别的显示样式，可以直接根据关键字搜索你想要的，搜索条件是支持正则表达式的
MyBatis Log Plugin
	Mybatis现在是java中操作数据库的首选，在开发的时候，我们都会把Mybatis的脚本直接输出在console中，但是默认的情况下，输出的脚本不是一个可以直接执行的。
	如果我们想直接执行，还需要在手动转化一下。MyBatis Log Plugin 这款插件是直接将Mybatis执行的sql脚本显示出来，无需处理，可以直接复制出来执行的。
String Manipulation
	强大的字符串转换工具。使用快捷键，Alt+m。
Maven Helper
	一键查看maven依赖，查看冲突的依赖，一键进行exclude依赖
Restfultookit
	Spring MVC网页开发的时候，我们都是通过requestmapping的方式来定义页面的URL地址的，为了找到这个地址我们一般都是cmd+shift+F的方式进行查找，
	大家都知道，我们URL的命名一个是类requestmapping+方法requestmapping，查找的时候还是有那么一点不方便的，restfultookit就能很方便的帮忙进行查找。

```

*Cannot resolve method "XX" 问题解决*

```
1、安装lombok插件，点击菜单栏中的【File】->【Setting】->【Plugins】-> 输入 lombok ，【install】-> 【Ok】
2、允许插件运行， 点击菜单栏中的【File】->【Setting】->搜索框直接输入【Annotation Processors】-> 
	将 Enable Annotation Processors 打勾，重启软件即可。
```

#  **maven**

## *Linux版*

### 安装配置

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

### *可能错误*

```
报错：There are test failures
解决：maven 打包跳过单元测试
mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true 
mvn clean install -P dev -Dmaven.test.skip=true -Dmaven.javadoc.skip=true
```

## windows版

*C:\Users\Administrator\.m2\settings.xml*

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
#  ****ThreadLocal****

```
1、ThreadLocal是什么
2、ThreadLocal怎么用
3、ThreadLocal源码分析
4、ThreadLocal内存泄漏问题

参考： https://www.jianshu.com/p/98b68c97df9b
```
```
一、ThreadLocal是什么

从名字我们就可以看到ThreadLocal叫做线程变量，意思是ThreadLocal中填充的变量属于当前线程，该变量对其他线程而言是隔离的。ThreadLocal为变量在每个线程中都创建了一个副本，那么每个线程可以访问自己内部的副本变量。

从字面意思来看非常容易理解，但是从实际使用的角度来看，就没那么容易了，作为一个面试常问的点，使用场景那也是相当的丰富：

1、在进行对象跨层传递的时候，使用ThreadLocal可以避免多次传递，打破层次间的约束。
2、线程间数据隔离
3、进行事务操作，用于存储线程事务信息。
4、数据库连接，Session会话管理。
```

