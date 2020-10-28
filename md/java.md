# Spring Cloud

# Spring Boot

### 连接池

```
目前最热门的数据库连接池，就要属阿里巴巴的Druid以及HikariCP了，它们也分别是Spring Boot 1.x和Spring Boot 2.x默认的数据库连接池。
```

# Spring Mvc

# Spring



```
ExceptionUtil.throwError(aliasPrefix.returnCode, aliasPrefix.errMsg);

@Slf4j

private Logger logger = LoggerFactory.getLogger(GvnXxlJobConfig.class);

H_api_key:Huitone@2214
H_sign:RoW1EOIN9Lsd2GzhoHitqQhxunqiPaGuEG0tqsF6wCxy99kl2EPhXJJgE4ICsedR0HnGFNx/wN39Sq4tGbPWR8o4jnh4RXgZ60vG0MTnFGVdRFLbft+QS5CjDKUdDziPD7UvhUcJSasUEz1YcyXH1k1upSrQcdMvgf2zaVaUNj0=
H_timestamp:1595836849999
H_token:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBpcmVUaW1lIjoxNTk1ODM4NjQ5OTQ0LCJ1c2VySXAiOiIxNzIuMTYuMTYuOTIiLCJ1c2VySWQiOjMwMywiYWNjb3VudCI6Inp4In0.zF6XoMx2RljYHaPpHuqsz7QzwpEzBIC8U9S9v7v9yxI
```

# **概念解析**

## spring 

## spring ioc

```
pring IOC容器是框架的核心，IOC是控制反转的意思，可以用来降低程序代码之间的耦合度。把强耦合的代码依赖从代码中移出去，放到统一的XML配置文件中，将程序对组件的主要控制权交给IOC，由IOC统一加载和管理。例如，可以把本案例中的JavaBean组件的创建、实体类的创建、以及JavaBean组件的属性注入等代码从Principal类移出，放入到Spring的XML配置文件中。这样就实现了Principal类与JavaBean组件的代码解耦，也解决了项目案例技术架构所存在的问题。

Spring IOC容器的核心是把程序业务代码与事物（组件、POJO类）代码进行分离，程序有关事物的创建、属性和依赖对象的注入、以及生命周期交由容器进行加载和管理。业务代码只需从容器中获取组件或POJO实例对象即可，无需再考虑组件之间、组件与POJO之间的依赖关系以及属性的注入。
```

## spring mvc

## spring boot

## spring cloud

# 注解

```
参考： https://blog.csdn.net/yuzongtao/article/details/84314103
```

## 元注解

```
jdk1.5起开始提供了4个元注解：@Target、@Retention、@Documented、@Inherited
何谓元注解？就是注解的注解。
在程序开发中，有时候我们需要自定义一个注解，这个自定义注解类就需要被元注解修饰，以定义该类的一些基本特征。

例如，我们创建一个LogAnnotation的自定义注解类：

@Target({ ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
public @interface LogAnnotation {
	String module() default "";
}
@interface意思是声明一个注解，方法名对应参数名，返回值类型对应参数类型。

@Target注解用于定义注解的使用位置，如果没有该项，表示注解可以用于任何地方。@Target的格式为：
// 单参数
@Target({ ElementType.METHOD })
// 多参数
@Target(value = {ElementType.METHOD,ElementType.TYPE})
@Target的ElementType取值有以下类型：
    TYPE：类，接口或者枚举
    FIELD：域，包含枚举常量
    METHOD：方法
    PARAMETER：参数
    CONSTRUCTOR：构造方法
    LOCAL_VARIABLE：局部变量
    ANNOTATION_TYPE：注解类型
    PACKAGE：包

@Retention注解用于指明修饰的注解的生存周期，即会保留到哪个阶段。格式为：
@Retention(RetentionPolicy.RUNTIME)
RetentionPolicy的取值包含以下三种：
    SOURCE：源码级别保留，编译后即丢弃。
    CLASS：编译级别保留，编译后的class文件中存在，在jvm运行时丢弃，这是默认值。
    RUNTIME：运行级别保留，编译后的class文件中存在，在jvm运行时保留，可以被反射调用。
    
@Documented
	指明修饰的注解，可以被例如javadoc此类的工具文档化，只负责标记，没有成员取值。

@Inherited
@Inherited注解用于标注一个父类的注解是否可以被子类继承，如果一个注解需要被其子类所继承，则在声明时直接使用@Inherited注解即可。
如果没有写此注解，则无法被子类继承。下面做一个测试：
    //自定义一个注解
    @interface MyAnnoation
    {
        public String key() default "key1";
        public String value() default "value1";
    }

    @Target(ElementType.TYPE)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    //如果父类使用了HeritedApplication注解，则子类应该继承
    @Inherited
    @MyAnnoation
    @interface HeritedApplication {

    }

    //父类使用了@HeritedApplication注解
    @HeritedApplication
    class Person {

    }

    class Student extends Person{

    }

    class AnnotationInherited{
        public static void main(String[] args) throws Exception
        {
            Class clazz = Student.class;
            //Student类是否有@HeritedApplication
            if(clazz.isAnnotationPresent(HeritedApplication.class)){
                System.out.println("true");
            }
        }
    }
    运行程序，结果为 true。
```



## 常用

```
事务：
	@Transactional(rollbackFor = Exception.class)
@Param
	1.便于传多个参数；
	2.类似于别名之类的功能
	不使用@Param注解时，参数只能有一个，而且是JavaBean，在sql中只能引用JavaBean的属性。
	
@JsonProperty 此注解用于属性上，作用是把该属性的名称序列化为另外一个名称，示例：
    @JsonProperty("svgName")
    @Column(name = "file_name")
    @ApiModelProperty(value = "file_name", name = "fileName")
    private String fileName;
```

## spring

```
参考：
    https://www.jianshu.com/p/21f3e074e91a
    https://blog.csdn.net/weixin_40423597/article/details/80643990
```

### @Autowire和@Resource注解的区别

```
@Autowire和@Resource都是Spring支持的注解方式动态装配bean。

介绍
	@Autowire和@Resource都是Spring支持的注解方式动态装配bean。

详解
    @Autowire
    @Autowire默认按照类型(by-type)装配，默认情况下要求依赖对象必须存在。

如果允许依赖对象为null，需设置required属性为false，即
    @Autowire(required=false)
    private InjectionBean beanName;

如果使用按照名称(by-name)装配，需结合@Qualifier注解使用，即
    @Autowire
    @Qualifier("beanName")
    private InjectionBean beanName;

说明
    @Autowire按照名称(by-name)装配，则
    @Autowire + @qualifier("") = @Resource(name="")

@Resource
@Resource默认按照名称(by-name)装配，名称可以通过name属性指定。
    如果没有指定name
    当注解在字段上时，默认取name=字段名称装配。
    当注解在setter方法上时，默认取name=属性名称装配。
    当按照名称(by-name）装配未匹配时，按照类型(by-type)装配。
    当显示指定name属性后，只能按照名称(by-name)装配。
    
@Resoure装配顺序
    如果同时指定name和type属性，则找到唯一匹配的bean装配，未找到则抛异常；
    如果指定name属性，则按照名称(by-name)装配，未找到则抛异常；
    如果指定type属性，则按照类型(by-type)装配，未找到或者找到多个则抛异常；
    既未指定name属性，又未指定type属性，则按照名称(by-name)装配；如果未找到，则按照类型(by-type)装配。
对比
    对比项	@Autowire	@Resource
    注解来源	Spring注解	JDK注解(JSR-250标准注解，属于J2EE)
    装配方式	优先按类型	优先按名称
    属性	required	name、type
	作用范围	字段、setter方法、构造器	字段、setter方法
	
说明：
	作用范围在字段上，均无需在写setter方法
	
个人总结：
    @Autowired//默认按type注入
    @Qualifier("cusInfoService")//一般作为@Autowired()的修饰用
    @Resource(name="cusInfoService")//默认按name注入，可以通过name和type属性进行选择性注入
	一般@Autowired和@Qualifier一起用，@Resource单独用。
	当然没有冲突的话@Autowired也可以单独用
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
@ControllerAdvice
实现三个方面的功能：
    全局异常处理
    全局数据绑定
    全局数据预处理
```
# **注意事项**

```
在Spring中对于bean的默认处理都是单例的，我们通过上下文容器.getBean方法拿到bean容器，并对其进行实例化，这个实例化的过程其实只进行一次，即多次getBean 获取的对象都是同一个对象，也就相当于这个bean的实例在IOC容器中是public的，对于所有的bean请求来讲都可以共享此bean。

1.先判断null，再判断equals("")
2.字符串用equals ,例如："".equals(yourStr)

打开的资源都没有在finally里关闭的？？？如果不想写关闭，实现了autocloseable的用try-with-resources 写法
如果是实现了autocloseable接口的资源，用try with resource写法，否则在finally里执行关闭

java中e.printStackTrace()不要使用，请使用logger记录
logger.error("",e);

java的toString()导致空指针异常的技巧
解决空指针的代码：
    Object object = null;
    String d=object+"";
    或者先判断
    
如果mybatis有xml配置文件，要配成如上（加*）

JAVA中try、catch、finally带return的执行顺序：
参考：	
	https://www.cnblogs.com/pcheng/p/10968841.html
总结：
    1、finally中的代码总会被执行。
    2、当try、catch中有return时，也会执行finally。return的时候，要注意返回值的类型，是否受到finally中代码的影响。
    3、finally中有return时，会直接在finally中退出，导致try、catch中的return失效。
```
# Spring中Bean的单例和多例

```
在Spring中，bean可以被定义为两种模式：prototype（多例）和singleton（单例）
    singleton（单例）：只有一个共享的实例存在，所有对这个bean的请求都会返回这个唯一的实例。
    prototype（多例）：对这个bean的每次请求都会创建一个新的bean实例，类似于new。
	注：Spring bean 默认是单例模式。如果要配置单例或者多例，可以在对应的bean上加一个@Scope("prototype")注解

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
POJO To Json
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

# 线程安全

```
非线程安全：
    ArrayList
    HashMap
    StringBuilder
	LinkedList
线程安全的：
    Vector
    HashTable
    StringBuffer
```



# 常用示例

## list对象集合中获取某一列的集合数据

```
List<Book> list = Lists.newArrayList();

list.add(new Book("1", "sql基础大全", 200));
list.add(new Book("2", "Java基础", 500));
System.out.println(list);
List<String> nameList = list.stream().map(Book -> Book.getName()).collect(Collectors.toList());
System.out.println(nameList);

示例：
	List<TbUcCfgQuoteDs> list = tbUcCfgQuoteDsService.select(tbUcCfgQuoteDs);
	
    List<String> aliasList = list.stream().map(TbUcCfgQuoteDs -> TbUcCfgQuoteDs.getAlias()).collect(Collectors.toList());
    System.out.println(aliasList);
    结果：[A1, A1, A2, A3, A4]
    //取出别名数组里的数字
	List<Long> newAliasList = new ArrayList<>();
    for(String alias:aliasList){
    	newAliasList.add(getStrNumber(alias));
    }
    //取出最大的别名
    Long alias = Collections.max(newAliasList);
    System.out.println(alias);
	结果：4
```

## 字符串截取

```
字符串转数组：
	String[] columnIdArr = columnId.split(",");
去掉最后一个字符：
	response = response.substring(0,response.length()-1);
提取字母
	str.replaceAll("\\s*","").replaceAll("[^(A-Za-z)]","")
提取数字
	str.replaceAll("\\s*","").replaceAll("[^(0-9)]","")
提取数字+字母
	str.replaceAll("\\s*","").replaceAll("[^(a-zA-Z0-9)]","")
```

## 字符串拼接

```
1. plus方式
	当左右两个量其中有一个为String类型时，用plus方式可将两个量转成字符串并拼接。
    String a="";
    int b=0xb;
    String c=a+b;
    
2. concat方式
	当两个量都为String类型且值不为null时，可以用concat方式。
    String a="a";
    String b="b";
    String c= a.concat(b);
    理论上，此时拼接效率应该最高，因为已经假定两个量都为字符串，做底层优化不需要额外判断或转换，而其他方式无论如何优化，都要先走到这一步。

3. append方式
	当需要拼接至少三个量的时候，可以考虑使用StringBuffer#append()以避免临时字符串的产生
    StringBuffer buf=new StringBuffer()
    buf.append("a");
    if(someCondition){
    	buf.append("b");
    }
    buf.append("c");
    String d=buf.toString();
	当a,b,c拼接起来会很长时，可以给在构造器中传入一个合适的预估容量以减少因扩展缓冲空间而带来的性能开销。

StringBuffer buf=new StringBuffer(a.length()+b.length()+c.length());
JDK对外提供的一些涉及可append CharSequence的参数或返回值类型往往是StringBuffer类型，毕竟安全第一，而StringBuffer大多数情况(包括append操作)线程安全。

若不会出现多线程同时对一实例并发进行append操作，建议使用非线程安全的StringBuilder以获得更好性能

示例：
StringBuffer sql = new StringBuffer("update ");
sql.deleteCharAt(sql.length()-2).
    append(" where ( ").
    append(etlFilterList.get(0).getFilterExpr()).
    append(" ) ");
tbUcTaskParam.setValue(sql.toString());
```

## selectByExample

```
Example exampleUpdateColumn = new Example(TbUcCfgEtlUpdColumn.class);
Example.Criteria criteriaUpdateColumn  = exampleUpdateColumn.createCriteria();
criteriaUpdateColumn.andEqualTo("etlTaskId", tbUcCfgEtlTask.getEtlTaskId());
List<TbUcCfgEtlUpdColumn> updateColumns = tbUcCfgEtlUpdColumnService.selectByExample(example);

Example exampleParam = new Example(TbUcTaskParam.class);
Example.Criteria criteriaParam = exampleParam.createCriteria();
criteriaParam.andIn("taskId", oldTaskIdList);
if(tbUcTaskParamService.deleteByExample(exampleParam) <1 ){
	ExceptionUtil.throwError(StatusCode.FAILURE.getCode(),StatusCode.FAILURE.getMessage());
}
```

## selectOneByExample

```
Example example = new Example(TbUcCfgQuoteDs.class);
Example.Criteria criteria = example.createCriteria();
criteria.andEqualTo("dsId", dsId);
int count = this.selectCountByExample(example);
```



## List

```
List的遍历：
for(Iterator<String>    it    =    list.iterator();    it.hasNext();    )    {  
    ....  
}  
for(Iterator<String>    it    =    list.iterator();    it.hasNext();    )    {  
    ....  
}  
for(String   data    :    list)    {  
    .....  
} 
for(int    i=0;    i<list.size();    i++)    {  
    A    a    =    list.get(i);  
    ...  
}  //内部不锁定, 效率最高, 但是当写多线程时要考虑并发操作的问题。

List转换为Array可以这样处理：
    ArrayList<String> list=new ArrayList<String>();
    String[] strings = new String[list.size()];
    list.toArray(strings);

注：List直接转换,list.toArray()会抛异常，编译通过，执行异常。

反过来，将数组转成List如下：
    String[] s = {"a","b","c"};
    List list = java.util.Arrays.asList(s);
示例：
    for (TbUaCfgVarOutVo cur:tbUaCfgVarOutVoList){
        List<String> list = StringUtils.splitToStringList(cur.getNameCn(),"：");
        for (int i=0;i<list.size();i++){
            if(i==0){
                cur.setNameCn(list.get(i));
            }
            if(i==1){
                cur.setExplain(list.get(i));
            }
        }
    }	
```



## ArrayList

```
遍历arrayList的四种方法:
	List<String> list = new ArrayList<String>();
    list.add("luojiahui");
    list.add("luojiafeng");

    //方法1
    Iterator it1 = list.iterator();
        while(it1.hasNext()){
        System.out.println(it1.next());
    }

    //方法2
    for(Iterator it2 = list.iterator();it2.hasNext();){
        System.out.println(it2.next());
    }

    //方法3
    for(String tmp:list){
        System.out.println(tmp);
    }

    //方法4
    for(int i = 0;i < list.size(); i ++){
        System.out.println(list.get(i));
    }
1.HashSet   
    1)   HashSet不能够存储相同的元素，元素是否相同的判断：重写元素的equals方法。equals方法和hashCode方法必须兼容，
    如：equals方法判断的是用户的名字name，那么hashCode的返回的hashcode必须是name。hashcode（）；
    2)   HashSet存储是无序的，保存的顺序与添加的顺序是不一致的，它不是线性结构，而是散列结构，（通过散列表：散列单元指向链表）。
    因此，HashSet的查询效率相对比较高。
    3)   HashSet不是线程安全的，不是线程同步的。这需要自己实现线程同步：Collections.synchronizedCollection()，方法实现。

2.ArrayList
    1)   ArrayList中存放顺序和添加顺序是一致的。并且可重复元素。
    2)   不是线程安全的，不是线程同步的。
    3)   ArrayList是通过可变大小的数组实现的，允许null在内的所有元素。
    4)   ArrayList适合通过位子来读取元素。
对比：
    1)   ArrayList始终比HashSet性能要高
    2)   HashSet每次添加总要判断hashcode导致效率低
    3)   HashSet两种循环中iterator 方式不稳定，不过总是比foreach要快一点
```



# 异常

```
任何Java代码都可以抛出异常，如：自己编写的代码、来自Java开发环境包中代码，或者Java运行时系统。
无论是谁，都可以通过Java的throw语句抛出异常。从方法中抛出的任何异常都必须使用throws子句。
捕捉异常通过try-catch语句或者try-catch-finally语句实现。          

总体来说，Java规定：对于可查异常必须捕捉、或者声明抛出。允许忽略不可查的RuntimeException和Error。  

抛出异常的方法：throws和throw
    throws：通常被用在声明方法时，用来指定方法可能抛出的异常，多个异常可使用逗号分隔。throws关键字将异常抛给上一级，如果不想处理该异常，
    可以继续向上抛出，但最终要有能够处理该异常的代码。

    throw：通常用在方法体中或者用来抛出用户自定义异常，并且抛出一个异常对象。程序在执行到throw语句时立即停止，如果要捕捉throw抛出的异常，
    则必须使用try-catch语句块或者try-catch-finally语句。

例1：throws方法抛出异常
public class Shoot {
    static void pop()throws NegativeArraySizeException{
    	int[] arr = new int[-3];
    }
	public static void main(String[] args) {
		 try{
			 pop();
		 }catch(NegativeArraySizeException e){
			 System.out.println("pop()方法抛出的异常");
		 }
	}
 
}
运行结果：
	pop()方法抛出的异常
                 
例2：throw方法抛出异常
public class TestException {
	public static void main(String[] args) {
		int a = 6;
		int b = 0;
		try {  
			if (b == 0) throw new ArithmeticException(); // 通过throw语句抛出异常
			System.out.println("a/b的值是：" + a / b);
		}
		catch (ArithmeticException e) { // catch捕捉异常
			System.out.println("程序出现异常，变量b不能为0。");
		}
		System.out.println("程序正常结束。");
	}
}
运行结果：
    程序出现异常，变量b不能为0。
    程序正常结束。

对于try-catch-finally语句：先执行try 块中的代码，如果正常运行没有发生异常则执行完后执行finally 代码块中的代码；
如若在try 中发生异常且被catch 捕捉到则执行catch 中的代码块，然后执行finally 块中的代码；
但也存在以下4种特殊情况，finally块不会被执行：
      在前面的代码中使用了System.exit()退出程序；
      在finally语句块中发生异常；
      程序所在的线程死亡；
      关闭CPU。

```

