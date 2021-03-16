# shiro

## 使用注解控制鉴权授权

```
注解							功能
@RequiresGuest				只有游客可以访问
@RequiresAuthentication		需要登录才能访问
@RequiresUser				已登录的用户或“记住我”的用户能访问
@RequiresRoles				已登录的用户需具有指定的角色才能访问
@RequiresPermissions		已登录的用户需具有指定的权限才能访问
```

## 使用 url配置控制鉴权授权

```
配置缩写					对应的过滤器							功能
anon					AnonymousFilter						指定url可以匿名访问
authc					FormAuthenticationFilter			指定url需要form表单登录，默认会从请求中获取username、password,rememberMe
															等参数并尝试登录，如果登录不了就会跳转到loginUrl配置的路径。
															我们也可以用这个过滤器做默认的登录逻辑，但是一般都是我们自己在控制器写登录逻辑的，
															自己写的话出错返回的信息都可以定制嘛。
authcBasic				BasicHttpAuthenticationFilter		指定url需要basic登录
logout					LogoutFilter						登出过滤器，配置指定url就可以实现退出功能，非常方便
noSessionCreation		NoSessionCreationFilter				禁止创建会话
perms					PermissionsAuthorizationFilter		需要指定权限才能访问
port					PortFilter							需要指定端口才能访问
rest					HttpMethodPermissionFilter			将http请求方法转化成相应的动词来构造一个权限字符串，这个感觉意义不大
roles					RolesAuthorizationFilter			需要指定角色才能访问
ssl						SslFilter							需要https请求才能访问
user					UserFilter							需要已登录或“记住我”的用户才能访问
```



# JWT

## 介绍

```
JWT（JSON Web Tokens）是一种用于安全的传递信息而采用的一种标准。
Web系统中，我们使用加密的Json来生成Token在服务端与客户端无状态传输，代替了之前常用的Session。
系统采用Redis作为缓存，解决Token过期更新的问题，同时集成SSO登录，完整过程这里来总结一下。
经常用在跨域身份验证。因为存在数字签名，因此可以起到防串改的作用。
```

## 格式

```
Header 头信息
{  
	"alg": "Algorithm  加密方法：HS256",  
	"cty": "Content Type ",  
	"typ": "Type" ,  
	"kid": "Key Id" 
}

Payload  载体信息：数据包放在这里
{  
	"iss": "Issuer JWT的签发者",  
	"aud": "Audience 接收JWT的一方",  
	"sub": "Subject JWT的主题",  
	"exp": "Expiration Time JWT的过期时间",  
	"nbf": "Not Before 在xxx之间，该JWT都是可用的",  
	"iat": "Issued At 该JWT签发的时间",  
	"jti": "JWT ID JWT的唯一身份标识",  
	"xxx": "自定义属性"
}

Signature 签名信息 = 加密算法(header + "." + payload, 密钥)

TOKEN
base64(Header).base64(Payload).Signature
```

## 请求流程

```
1. 用户使用账号和面发出post请求；
2. 服务器使用私钥创建一个jwt；
3. 服务器返回这个jwt给浏览器；
4. 浏览器将该jwt串在请求头中像服务器发送请求；
5. 服务器验证该jwt；
6. 返回响应的资源给浏览器。
```

## 登录主要流程

```
登录时，密码验证通过，取当前时间戳生成签名Token，放在Response Header的Authorization属性中，同时在缓存中记录值为当前时间戳的RefreshToken，并设置有效期。
客户端请求每次携带Token进行请求。
服务端每次校验请求的Token有效后，同时比对Token中的时间戳与缓存中的RefreshToken时间戳是否一致，一致则判定Token有效。
当请求的Token被验证时抛出TokenExpiredException异常时说明Token过期，校验时间戳一致后重新生成Token并调用登录方法。
每次生成新的Token后，同时要根据新的时间戳更新缓存中的RefreshToken，以保证两者时间戳一致。
```

## 主要应用场景

```
身份认证在这种场景下，一旦用户完成了登陆，在接下来的每个请求中包含JWT，可以用来验证用户身份以及对路由，服务和资源的访问权限进行验证。
由于它的开销非常小，可以轻松的在不同域名的系统中传递，所有目前在单点登录（SSO）中比较广泛的使用了该技术。 
信息交换在通信的双方之间使用JWT对数据进行编码是一种非常安全的方式，由于它的信息是经过签名的，可以确保发送者发送的信息是没有经过伪造的。
```

## 优点

```
1.简洁(Compact): 可以通过URL，POST参数或者在HTTP header发送，因为数据量小，传输速度也很快
2.自包含(Self-contained)：负载中包含了所有用户所需要的信息，避免了多次查询数据库
3.因为Token是以JSON加密的形式保存在客户端的，所以JWT是跨语言的，原则上任何web形式都支持。
4.不需要在服务端保存会话信息，特别适用于分布式微服务。
```

## 缺点

```
默认生成的token不加密，别人可以解析token获取到其中的数据，如果要传递敏感信息，可以先将信息加密后再放入token，或者将生成的token进行加密
每次延长token有效期，会从新生成一个token，需要前端替换原有的token
由于服务器不保存 session状态，因此无法在使用过程中废止某个token，或者更改 token的权限。
也就是说，一旦JWT签发了，在到期之前就会始终有效，需要在服务端设置相应的业务逻辑去处理。
```

# HttpServletRequest

## 介绍

```
HttpServletRequest对象代表客户端的请求，当客户端通过HTTP协议访问服务器时，HTTP请求头中的所有信息都封装在这个对象中，通过这个对象提供的方法，可以获得客户端请求的所有信息。
```

## 常用方法

```
getRequestURI()
	获取请求的资源路径
getRequestURL()
	获取请求的统一资源定位符（绝对路径）
getRemoteHost()
	获取客户端的 ip 地址
getHeader()
	获取请求头
getParameter()
	获取请求的参数
getParameterValues()
	获取请求的参数（多个值的时候使用）
getMethod()
	获取请求的方式 GET 或 POST
setAttribute()
	设置域数据
getAttribute()
	获取域数据
getRequestDispatcher()
	获取请求转发对象
```

## 示例

```
Enumeration<String> reqHeadInfos = httpServletRequest.getHeaderNames();//获取所有的请求头
System.out.println("获取到的客户端所有的请求头信息如下：");
while (reqHeadInfos.hasMoreElements()) {
	String headName = (String) reqHeadInfos.nextElement();
	String headValue = httpServletRequest.getHeader(headName);//根据请求头的名字获取对应的请求头的值
	System.out.println(headName+":"+headValue);
}
System.out.println("获取到的客户端Accept-Encoding请求头的值：");
String value = httpServletRequest.getHeader("Accept-Encoding");//获取Accept-Encoding请求头对应的值
System.out.println(value);
```



# Spring Cloud

## zuul

### Filter

参考：http://c.biancheng.net/view/5417.html

```
Zuul 中的过滤器总共有 4 种类型，且每种类型都有对应的使用场景。
1）pre
	可以在请求被路由之前调用。适用于身份认证的场景，认证通过后再继续执行下面的流程。
2）route
	在路由请求时被调用。适用于灰度发布场景，在将要路由的时候可以做一些自定义的逻辑。
3）post
	在 route 和 error 过滤器之后被调用。这种过滤器将请求路由到达具体的服务之后执行。适用于需要添加响应头，记录响应日志等应用场景。
4）error
	处理请求时发生错误时被调用。在执行过程中发送错误时会进入 error 过滤器，可以用来统一记录错误信息。
	
使用方法：
通过继承ZuulFilter然后覆写4个方法，示例：
public class IpFilter extends ZuulFilter {
    // IP黑名单列表
    private List<String> blackIpList = Arrays.asList("127.0.0.1");

    public IpFilter() {
        super();
    }

    @Override
    public boolean shouldFilter() {
        return true
    }

    @Override
    public String filterType() {
        return "pre";
    }

    @Override
    public int filterOrder() {
        return 1;
    }

    @Override
    public Object run() {
        RequestContext ctx = RequestContext.getCurrentContext();
        String ip = IpUtils.getIpAddr(ctx.getRequest());
        // 在黑名单中禁用
        if (StringUtils.isNotBlank(ip) && blackIpList.contains(ip)) {

            ctx.setSendZuulResponse(false);
            ResponseData data = ResponseData.fail("非法请求 ", ResponseCode.NO_AUTH_CODE.getCode());
            ctx.setResponseBody(JsonUtils.toJson(data));
            ctx.getResponse().setContentType("application/json; charset=utf-8");
            return null;
        }
        return null;
    }
}

1）shouldFilter
	是否执行该过滤器，true 为执行，false 为不执行，这个也可以利用配置中心来实现，达到动态的开启和关闭过滤器。
2）filterType
	过滤器类型，可选值有 pre、route、post、error。
3）filterOrder
	过滤器的执行顺序，数值越小，优先级越高。
4）run
	执行自己的业务逻辑，本段代码中是通过判断请求的 IP 是否在黑名单中，决定是否进行拦截。blackIpList 字段是 IP 的黑名单，判断条件成立之后，
	通过设置 ctx.setSendZuulResponse（false），告诉 Zuul 不需要将当前请求转发到后端的服务了。通过 setResponseBody 返回数据给客户端。
	
过滤器定义完成之后我们需要配置过滤器才能生效，IP 过滤器配置代码如下所示。
@Configuration
public class FilterConfig {
    @Bean
    public IpFilter ipFilter() {
        return new IpFilter();
    }
}

过滤器禁用
有的场景下，我们需要禁用过滤器，此时可以采取下面的两种方式来实现：
	利用 shouldFilter 方法中的 return false 让过滤器不再执行
	通过配置方式来禁用过滤器，格式为“zuul. 过滤器的类名.过滤器类型 .disable=true”。
	如果我们需要禁用“使用过滤器”部分中的 IpFilter，可以用下面的配置：
		zuul.IpFilter.pre.disable=true
```

# Spring Boot

## 连接池

```
目前最热门的数据库连接池，就要属阿里巴巴的Druid以及HikariCP了，它们也分别是Spring Boot 1.x和Spring Boot 2.x默认的数据库连接池。
```

## 日志

```
参考：	https://blog.csdn.net/weixin_43054590/article/details/88553997

常见日志框架：JUL、JCL、Log4j、Log4j2，Logback、SLF4j、Jboss-logging

企业级开发日志选择：
    日志门面：SLF4j；
    日志实现：Log4j、Logback；
    Log4j2功能非常强大，但是设计比较复杂并且没有日志门面与之相匹配，作为企业级日志会存在不稳定的问题；

日志选择逻辑：日志门面+日志实现，运行日志时调用的是日志门面的接口，但是配置采用的是日志实现的配置。

springboot日志选择：spring框架默认采用的是JCL日志门面，所以springboot底层默认排除了spring框架采用的JCL，选择：
    日志门面：SLF4j；
    日志实现：Logback；它相对于Log4j来说更加的强大功能更加齐全。
    
SLF4j：只导入SLF4j的jar包，没有实现日志，日志功能单一
SLF4j+Logback：导入slf4j-api.jar和Logback相关jar包

日志级别从低到高分为TRACE < DEBUG < INFO < WARN < ERROR < FATAL；
Spring Boot中默认配置ERROR、WARN和INFO级别的日志输出到控制台；
日志默认输出在控制台，日志输出内容springboot底层已配置好，开箱即用

logging.level.* : 作为package（包）的前缀来设置日志级别；日志级别从低到高分为TRACE < DEBUG < INFO < WARN < ERROR < FATAL
logging.file :配置日志输出的文件名，也可以配置文件名的绝对路径。
logging.path :配置日志的路径。如果没有配置logging.file,Spring Boot 将默认使用spring.log作为文件名；当logging.file与logging.path同时存在时，springboot按照logging.file定义的路径输出日志文件
logging.pattern.console :定义console中logging的样式。
logging.pattern.file :定义文件中日志的样式。
logging.pattern.level :定义渲染不同级别日志的格式。默认是%5p.
logging.exception-conversion-word :.定义当日志发生异常时的转换字
PID :定义当前进程的ID

根据不同的日志系统，springboot中你可以按如下规则组织配置文件名，就能被正确加载：
    Logback：logback-spring.xml, logback-spring.groovy, logback.xml, logback.groovy
    Log4j：log4j-spring.properties, log4j-spring.xml, log4j.properties, log4j.xml
    Log4j2：log4j2-spring.xml, log4j2.xml
    JDK (Java Util Logging)：logging.properties
    
引入自定义的logback.xml文件,在properties文件夹中进行如下声明
	logging.config=classpath:logging-test.xml
	
springboot集成log4j：
    方式一：
        第一步：将log4j对应的中间日志框架log4j-over-slf4j.jar依赖清除掉；
        第二步：将logback的依赖清除掉；
        第三步：引入log4j及其适配层日志框架的依赖，最后log4j就能成功运行了。
   方式二：
       第一步：移除spring-boot-starter-logging依赖包；
       第二步：添加spring-boot-starter-log4j依赖包，ok。
       
springboot的logback.xml配置内容：
如果我们觉得springboot默认的配置内容满足不了我们的需求，我们也可以自定义logback日志的xml对logback日志进行重新配置；

注意:springboot官方推荐使用logback-spring.xml,相对于 logback.xml它的配置功能更加齐全，比如logback-spring.xml可以配置profile多环境日志，logback.xml则不能实现此功能

logback.xml语法结构请参考：	https://www.jianshu.com/p/f67c721eea1b
```



```
日志输出格式：
    %d表示日期时间，
    %thread表示线程名，
    %-5level：级别从左显示5个字符宽度
    %logger{50} 表示logger名字最长50个字符，否则按照句点分割。 
    %msg：日志消息，
    %n是换行符
```

```
Class path contains multiple SLF4J bindings.警告的解决
参考：	https://blog.csdn.net/wohaqiyi/article/details/81009689

原因分析：
  上边的大概意思是说logback-classic 包和slf4j-log4j12 包，关于org/slf4j/impl/StaticLoggerBinder.class 这个类发生了冲突。
  发生这个错误的原因，首先logback 日志的开发者和log4j 的开发者据说是一波人，而springboot 默认日志是，较新的logback 日志。但是在以前流行的日志却是log4j ，而且很多的第三方工具都含有log4j 得引入。
  而我们在项目开发中，难免会引入各种各样的工具包，所以，基本上springboot 项目，如果不注意，肯定会出现这种冲突的。
```



# Spring Mvc

# Spring

```
参考：
	https://www.w3cschool.cn/wkspring/dcu91icn.html
```

![img](https://atts.w3cschool.cn/attachments/image/wk/wkspring/arch1.png)

```
Bean 与 Spring 容器之间的关系：
```

![img](https://atts.w3cschool.cn/attachments/image/20201030/1604037368126454.png)



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
@Transactional(rollbackFor = Exception.class)
    1）接口实现类或接口实现方法上，而不是接口类中。
    2）访问权限：public 的方法才起作用。@Transactional 注解应该只被应用到 public 方法上，这是由 Spring AOP 的本质决定的。
        将标签放置在需要进行事务管理的方法上，而不是放在所有接口实现类上：
        只读的接口就不需要事务管理，由于配置了@Transactional就需要AOP拦截及事务的处理，可能影响系统性能。
    3）错误使用：
        1.接口中A、B两个方法，A无@Transactional标签，B有，上层通过A间接调用B，此时事务不生效。
        2.接口中异常（运行时异常）被捕获而没有被抛出。
          默认配置下，spring 只有在抛出的异常为运行时 unchecked 异常时才回滚该事务，
          也就是抛出的异常为RuntimeException 的子类(Errors也会导致事务回滚)，
          而抛出 checked 异常则不会导致事务回滚 。可通过 @Transactional rollbackFor进行配置。
        3.多线程下事务管理因为线程不属于 spring 托管，故线程不能够默认使用 spring 的事务,
          也不能获取spring 注入的 bean 。
          在被 spring 声明式事务管理的方法内开启多线程，多线程内的方法不被事务控制。
          一个使用了@Transactional 的方法，如果方法内包含多线程的使用，方法内部出现异常，
          不会回滚线程中调用方法的事务。

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

### @ComponentScan

参考：https://www.jianshu.com/p/64aac6461d5b

```
会自动扫描指定包下全部标有@Component的类，并注册成bean，当然包括@Component下的子注解：@Service，@Repository，@Controller；
默认会扫描当前包和所有子包。
```

### @Configuration

参考：	https://www.jianshu.com/p/21f3e074e91a

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
	如果一个配置类使用了Profile 标签或者@Profile 作用在任何类中都必须进行启用才会生效，
	如果@Profile({"p1","!p2"}) 标识两个属性，那么p1 是启用状态 而p2 是非启用状态的。
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

### @ControllerAdvice 

```
@ControllerAdvice ，很多初学者可能都没有听说过这个注解，实际上，这是一个非常有用的注解，顾名思义，这是一个增强的 Controller。
使用这个 Controller ，可以实现三个方面的功能：
    全局异常处理
    全局数据绑定
    全局数据预处理

灵活使用这三个功能，可以帮助我们简化很多工作，需要注意的是，这是 SpringMVC 提供的功能，在 Spring Boot 中可以直接使用，下面分别来看。
参考：	
	https://www.cnblogs.com/lenve/p/10748453.html
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
    
使用标志位终止线程，变量要声明为volatile，让其它线程可见
```
# Spring中Bean的单例和多例

```
在Spring中，bean可以被定义为两种模式：prototype（多例）和singleton（单例）
    singleton（单例）：只有一个共享的实例存在，所有对这个bean的请求都会返回这个唯一的实例。
    prototype（多例）：对这个bean的每次请求都会创建一个新的bean实例，类似于new。
	注：Spring bean 默认是单例模式。如果要配置单例或者多例，可以在对应的bean上加一个@Scope("prototype")注解

```

# Future机制

```
常见的两种创建线程的方式。一种是直接继承Thread，另外一种就是实现Runnable接口。
这两种方式都有一个缺陷就是：在执行完任务之后无法获取执行结果。
从Java 1.5开始，就提供了Callable和Future，通过它们可以在任务执行完毕之后得到任务执行结果。
Future模式的核心思想是能够让主线程将原来需要同步等待的这段时间用来做其他的事情。（因为可以异步获得执行结果，所以不用一直同步等待去获得执行结果）
```
# ThreadLocal

```
1、ThreadLocal是什么
2、ThreadLocal怎么用
3、ThreadLocal源码分析
4、ThreadLocal内存泄漏问题

一、ThreadLocal是什么
    从名字我们就可以看到ThreadLocal叫做线程变量，意思是ThreadLocal中填充的变量属于当前线程，该变量对其他线程而言是隔离的。
    ThreadLocal为变量在每个线程中都创建了一个副本，那么每个线程可以访问自己内部的副本变量。

    从字面意思来看非常容易理解，但是从实际使用的角度来看，就没那么容易了，作为一个面试常问的点，使用场景那也是相当的丰富：

    1、在进行对象跨层传递的时候，使用ThreadLocal可以避免多次传递，打破层次间的约束。
    2、线程间数据隔离
    3、进行事务操作，用于存储线程事务信息。
    4、数据库连接，Session会话管理。
```

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



#  泛型

```
Java泛型中的各标记符含义： 
    E - Element (在集合中使用，因为集合中存放的是元素)
    T - Type（Java 类）
    K - Key（键）
    V - Value（值）
    N - Number（数值类型）
    R - Result （返回结果，多用于函数式编程）
    ？ -  表示不确定的java类型

PS: 其实以上这些对于java编译器来说作用都一样，都是作为一个占位作用，要在使用时就能确定类型，也就是说A,B,C...Z等大写字母都可以表示泛型，只不过以上泛型的定义，更多是我们程序员间约定俗成的命名方式，一种规范，从而达到“见其名则知其意”的目的，罢了。

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
参考：	
	https://www.cnblogs.com/coprince/p/8603492.html
```
# 接口

```
接口并不是类，编写接口的方式和类很相似，但是它们属于不同的概念。类描述对象的属性和方法。接口则包含类要实现的方法。

除非实现接口的类是抽象类，否则该类要定义接口中的所有方法。

接口无法被实例化，但是可以被实现。一个实现接口的类，必须实现接口内所描述的所有方法，否则就必须声明为抽象类。另外，在 Java 中，接口类型可用来声明一个变量，他们可以成为一个空指针，或是被绑定在一个以此接口实现的对象。

接口与类相似点：
    一个接口可以有多个方法。
    接口文件保存在 .java 结尾的文件中，文件名使用接口名。
    接口的字节码文件保存在 .class 结尾的文件中。
    接口相应的字节码文件必须在与包名称相匹配的目录结构中。
接口与类的区别：
    接口不能用于实例化对象。
    接口没有构造方法。
    接口中所有的方法必须是抽象方法。
    接口不能包含成员变量，除了 static 和 final 变量。
    接口不是被类继承了，而是要被类实现。
    接口支持多继承。
接口特性
    接口中每一个方法也是隐式抽象的,接口中的方法会被隐式的指定为 public abstract（只能是 public abstract，其他修饰符都会报错）。
    接口中可以含有变量，但是接口中的变量会被隐式的指定为 public static final 变量（并且只能是 public，用 private 修饰会报编译错误）。
    接口中的方法是不能在接口中实现的，只能由实现接口的类来实现接口中的方法。
抽象类和接口的区别
    1. 抽象类中的方法可以有方法体，就是能实现方法的具体功能，但是接口中的方法不行。
    2. 抽象类中的成员变量可以是各种类型的，而接口中的成员变量只能是 public static final 类型的。
    3. 接口中不能含有静态代码块以及静态方法(用 static 修饰的方法)，而抽象类是可以有静态代码块和静态方法。
    4. 一个类只能继承一个抽象类，而一个类却可以实现多个接口。
注：JDK 1.8 以后，接口里可以有静态方法和方法体了。

接口的声明语法格式如下：
[可见度] interface 接口名称 [extends 其他的接口名] {
        // 声明变量
        // 抽象方法
}

接口有以下特性：
    接口是隐式抽象的，当声明一个接口的时候，不必使用abstract关键字。
    接口中每一个方法也是隐式抽象的，声明时同样不需要abstract关键字。
    接口中的方法都是公有的。
    
接口的实现
    当类实现接口的时候，类要实现接口中所有的方法。否则，类必须声明为抽象的类。
    类使用implements关键字实现接口。在类声明中，Implements关键字放在class声明后面。
    
重写接口中声明的方法时，需要注意以下规则：
    类在实现接口的方法时，不能抛出强制性异常，只能在接口中，或者继承接口的抽象类中抛出该强制性异常。
    类在重写方法时要保持一致的方法名，并且应该保持相同或者相兼容的返回值类型。
    如果实现接口的类是抽象类，那么就没必要实现该接口的方法。
    
在实现接口的时候，也要注意一些规则：
    一个类可以同时实现多个接口。
    一个类只能继承一个类，但是能实现多个接口。
    一个接口能继承另一个接口，这和类之间的继承比较相似。
```

# 接口的作用

```
接口的作用就是把使用接口的人和实现接口的人分开，实现接口的人不必要关心谁去使用，而使用接口的人也不用关心谁实现的接口，由接口将他们联系在一起。
以上像一段绕口令，那么通过下面的几段程序解释： 
1、以生产和使用一台计算机为例，首先，我们定义了一个显卡的接口，他里面有显示功能和获取显卡名称的功能： 
    interface VidioCard { 
        void display(); 
        String getName(); 
    } 
    
2、显卡的生产者来了，他必须实现接口中定义的所有方法，也可以自己增添若干方法： 
    class HaolongVidio implements VidioCard { 
        String name="Haolong's vidiocard"; 
        
        void setName(String name){ 
            this.name=name; 
        } 
        
        public void display(){ 
            System.out.println("The Haolong's vidiocard is running!!"); 
        } 

        public String getName(){ 
            return name; 
        } 
	}; 
	显卡制造商生产出了显卡，并且通过setName方法贴上了自己的商标，而通过getName方法可以让使用者知道这块显卡的制造商。 
	
3、现在显卡已经生产出来了，但是我们还需要一块主板，把生产出来的显卡插到主板上才能够使用，那么我们去买主板： 
    class MainBorad { 
        String cpuname; 
        VidioCard vc; 

        void setCPU(String cpuname){ 
            this.cpuname=cpuname; 
        } 

        void setVidioCard(VidioCard vc){ 
            this.vc=vc; 
        } 

        void run(){ 
            System.out.println("wudi-mainbord!"); 
            System.out.println(vc.getName()); 
            vc.display(); 
            System.out.println("mainbord is running successful!"); 
        } 
    }; 
这是主板厂商生产的主板，这也就是我们所说的接口的使用者，在他生产主板的时候并不知道用户使用的是哪块显卡（程序中这样理解：Mainborad这个类只知道接口VidioCard中有哪些方法，但是并不知道接口的实现类HaolongVidio是怎么去实现接口的，也就是生产主板的厂商并没有必要考虑显卡是哪个厂商的，他要做的只是根据接口把显卡插槽做好，接口里没有实现的方法相当于插槽），但是他留出来了显卡的插槽（插槽就是接口），也就是他不关心谁实现的接口，但是他可以使用接口，预留出显卡的插槽让用户去选购显卡。 
4、现在我们用户开始组装计算机了： 
    public class ChengDuActor { 
        public static void main(String [] args){ 

            HaolongVidio hv=new HaolongVidio();//买了一块HaolongVidio显卡 
            MainBorad mb=new MainBorad();//买了一块主板 

            mb.setCPU("Intel");//买的是Inter主板 
            mb.setVidioCard(hv);//把HaolongVidio插到主板上（通过主板上setVidio方法） 

            //System.out.println(hv.getName()); 
            mb.run();//开电脑运行 
            System.out.println("success"); 
        } 
    }; 
以上看出接口的作用就是大力实现了java的开源性，使软件开发过程优化，接口重要的特征是实现了多样性，能够很好地解决C++中遗留的多继承中出现的问题。
```

# 为什么要用接口_为什么要使用接口

```
日常生活中，两个实体之间进行连接的部分称为接口。
如电脑和 U 盘连接的标准 USB 接口。接口可以确保不同实体之间的顺利连接。如不同的电脑厂家和 U 盘厂家只要按照相同的 USB 接口进行生产，那么所有的电脑和 U 盘就可以顺利的连接起来。

(1)Java 编程领域中，接口可以为不同类顺利交互提供标准。
例如：老师让学生张三和李四一起完成，java 程序来模拟营业员和计算器的行为。张三和李四进行工作分工，张三写计算机器，李四写营业员类。

张三和李四没有定义接口会出现的问题如下：

张三先定义了一个计算器类 Calculator 类并提供计算的方法, 注方法的名称
public class Calculator{
    public double count(double salary,double bonus){
        return salary+bonus;
    }
}

李四定义了代表营业员的 Seller 类：注意这里计算器的方法

class Seller{
	String name;// 营业员的名称
	Calculator calculator;

    public Seller(String name, Calculator calculator) {
        super();
        this.name = name;
        this.calculator = calculator;
    }

	// 计算的方法
	public void quote(double salary,double bonus){
		System.out.println(name+"说：您好：请支付"+calculator.countMoney(salary, bonus)+"元。");
	}
}

我们看到李四开发的时候想使用张三已经写好的计算器的类，李四想当然的认为计算钱的方法是 countMoney, 但是张三写计算器的时候使用的方法是 count, 那么李四的写的 Seller 类是错误的。

实现接口的好处如下：

为了保证张三和李四的书写的类可以正确的完成交互，李四定义了一个接口，并要求张三必须实现这个接口，接口的代码如下：

interface Icount{
	public double countMoney(double salary,double bonus);
}

那么张三在写计算器 Calculator；类的时候，实现 Icount 接口必须重写接口中的抽象方法。

这里要注意，这里说明了，接口不是写实现类的程序员写的，而是需要这个实现类的功能、把写实现类的任务交给其他人的程序员写的

那么张三的代买就应该是如下的：

public class Calculator implemenets Icount{
	public double countMoney(double salary,double bonus){
        return salary+bonus;
    }
}

这样就李四的代码就可以正常的执行了。

(2)接口可以降低类的依赖性，提高彼此的独立性

张三现在觉得计算器类的名字改成 SuperCalculator 更合适那么张三写的类代码就应该如下：

public class SuperCalculator implements Icount{
    public double countMoney(double salary,double bonus){
        return salary+bonus;
    }
}

李四的代码如下注意这里计算的使用接口来声明：

class Seller{
    String name;// 营业员的名称
    Icount calculator; // 这里使用接口声明

    public Seller(String name, Calculator calculator) {
        super();
        this.name = name;
        this.calculator = calculator;
    }

    // 计算的方法
    public void quote(double salary,double bonus){
        System.out.println(name+"说：您好：请支付"+calculator.countMoney(salary, bonus)+"元。");
    }
}

由以上的代码来看张三的类无论命名成什么李四的代码都不需要改，所以代码的依赖性降低，便于程序的维护。

这一点很关键，为了避免实现类的类型修改对调用的影响，声明的时候应该只声明接口的类型，相应的也只使用接口中定义的方法

(3)接口在使用的时候需要注意一下几点：
	1)接口是系统中最高层次的抽象类型
	2)接口本身必须十分稳定，接口一旦定制，就不允许随意修改，否则对接口实现类以及接口访问都会造成影响。(接口是需求的体现)
```



# 静态代码块、构造代码块、构造函数、普通代码块

```
一、静态代码块
1.在java类中(方法中不能存在静态代码块)使用static关键字和{}声明的代码块：
public class CodeBlock{
    static{
    	System.out.println("静态代码块");  
    }      
}

2.执行时机
	静态代码块在类被加载的时候就运行了，而且只运行一次，并且优先于各种代码块以及构造函数。如果一个类中有多个静态代码块，就会按照书写的顺序执行。

3.静态代码块的作用：
	一般情况下，如果有些代码需要在项目启动的时候执行，这时就需要静态代码快，比如一个项目启动需要加载很多配置文件等资源，就可以都放在静态代码块中。

4.静态代码块不能存在于任何方法体中
	这个很好理解，首先要明确静态代码块是在类加载的时候就运行了，我们分情况进行讨论：
    (1)对于普通方法，由于普通方法是通过加载类，然后new出实例化对象，通过对象才能运行这个方法，而静态代码块只需要加载类之后就能运行了。
    (2)对于静态方法，在类加载的时候，静态方法就已经加载了，但是我们必须通过类名或者对象名才能进行访问，也就是说相对于静态代码块，静态代码块是主动运行的，而静态方法是被动运行的。
    (3)不管哪种方法，我们需要明确的是静态代码块的存在在类加载的时候就自动运行了，而放在不管是普通方法中还是静态方法中，都是不能自动运行的。

5.静态代码块不能访问普通代变量
	(1)这个理解思维同上，普通代码块只能通过对象来进行调用，而不能防砸静态代码块中。
	
二、构造代码块
	1.格式：java类中使用{}声明的代码块(和静态代码块的区别是少了static关键字)　
    public class codeBlock {
        static {
            System.out.println("静态代码块");
        }
        {
            System.out.println("构造代码块");
        }
    }

	2.执行时机
	构造代码块在创建对象的时候被调用，每创建一次对象都会调用一次，但是优先于构造函数执行，需要注意的是，
	听名字我们就知道，构造代码块不是优先于构造函数执行的，而是依托于构造函数，
	也就是说，如果你不实例化对象，构造代码块是不会执行的。怎么理解呢？先看看下面的代码段：
	public class codeBlock {
        static {
            System.out.println("静态代码块");
        }
        {
            System.out.println("构造代码块");
        }
        public codeBlock(){
            System.out.println("无参构造函数");
        }
        public codeBlock(String str){
            System.out.println("有参构造函数");
        }
    }
    我们反编译生成的.class文件:
    public class codeBlock {
        public codeBlock(){
        	System.out.println("构造代码块");
            System.out.println("无参构造函数");
        }
        public codeBlock(String str){
        	System.out.println("构造代码块");
            System.out.println("有参构造函数");
        }
    }
    3.构造代码块的作用：
		(1)和构造函数的作用类似，都能够对象记性初始化，并且只要创建一个对象，构造代码块都会执行一次。
		但是反过来，构造函数则不会再每个对象创建的时候都执行(多个构造函数的情况下，建立对象时传入的参数不同则初始化使用对应的构造函数)
		(2)利用每次创建对象的时候都会提前调用一次构造代码块特性，我们做诸如统计创建对象的次数等功能。
		
三、构造函数
　　1.构造函数必须和类名完全相同。在java中，普通函数可以和构造函数同名，但是必须带有返回值。

　　2.构造函数的功能主要用于在类创建时定义初始化的状态。没有返回值，也不能用void来进行修饰。这就保证额它不仅什么也不用自动返回，而且根本不能有任何选择，而其他方法都有返回值，尽管方法体本身不会自动返回什么，但是仍然可以返回一些东西，而这些东西可能是不安全的；

　　3.构造函数不能被直接调用，必须通过New运算符在创建对象的时才会自动调用；而一般的方法是在程序执行到它的时候被调用的

　　4.当定义一个类的时候，通常情况下都会现实该类的构造函数，并在函数中指定初始化的工作也可省略，不过Java编译期会提供一个默认的构造函数，此默认的构造函数是不带参数的，即空参构造。而一般的方法不存在这一特点。
　　
四、普通代码块
　　1.普通代码块和构造代码块的区别是，构造代码块是在类中定义的，而普通代码块是在方法体重定义的。并且普通代码块的执行顺序和书写顺序是一致的
　　public class sayHelllo {
      System.out.println("普通代码块");
   }
   
五、执行顺序
　　1.静态代码块>构造代码块>构造函数>普通代码块
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

## 常见错误

### shorten command line

```
如果类路径太长，或者有许多VM参数，程序就无法启动。原因是大多数操作系统都有命令行长度限制。在这种情况下，IntelliJIDEA将试图缩短类路径。
shorten command line 选项提供三种选项缩短类路径。
    none：这是默认选项，idea不会缩短命令行。如果命令行超出了OS限制，这个想法将无法运行您的应用程序，但是工具提示将建议配置缩短器。
    JAR manifest：idea 通过临时的classpath.jar传递长的类路径。原始类路径在MANIFEST.MF中定义为classpath.jar中的类路径属性。
    classpath file：idea 将一个长类路径写入文本文件中。
建议使用JAR manifest
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

### 注意事项

```
--会执行单元测试
	mvn  -Dmaven.multiModuleProjectDirectory=M:\data-govern -Dmaven.home=E:\java\MAVEN\apache-maven-3.6.3   
	-DskipTests=true package

-- 不会执行单元测试
	mvn  -Dmaven.multiModuleProjectDirectory=M:\data-govern -Dmaven.home=E:\java\MAVEN\apache-maven-3.6.3   
	-Dmaven.test.skip=true package

maven插件选中了不执行单元测试  打包时还是会执行  原来它是加了 -DskipTests=true
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
# 语法

```
参考：
	https://www.runoob.com/java/java-data-structures.html

```

## 集合框架

```
Java 集合框架主要包括两种类型的容器，一种是集合（Collection），存储一个元素集合，另一种是图（Map），存储键/值对映射。
Collection 接口又有 3 种子类型，List、Set 和 Queue，再下面是一些抽象类，
最后是具体实现类，常用的有 ArrayList、LinkedList、HashSet、LinkedHashSet、HashMap、LinkedHashMap 等等。
如下图：
```

![img](https://www.runoob.com/wp-content/uploads/2014/01/2243690-9cd9c896e0d512ed.gif)



# 常用示例

## 常用

```
AutoKeyGet.GetKeyId()
```



```
ExceptionUtil.throwError(aliasPrefix.returnCode, aliasPrefix.errMsg);

@Slf4j

private Logger logger = LoggerFactory.getLogger(GvnXxlJobConfig.class);

H_api_key:Huitone@2214
H_sign:RoW1EOIN9Lsd2GzhoHitqQhxunqiPaGuEG0tqsF6wCxy99kl2EPhXJJgE4ICsedR0HnGFNx/wN39Sq4tGbPWR8o4jnh4RXgZ60vG0MTnFGVdRFLbft+QS5CjDKUdDziPD7UvhUcJSasUEz1YcyXH1k1upSrQcdMvgf2zaVaUNj0=
H_timestamp:1595836849999
H_token:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBpcmVUaW1lIjoxNTk1ODM4NjQ5OTQ0LCJ1c2VySXAiOiIxNzIuMTYuMTYuOTIiLCJ1c2VySWQiOjMwMywiYWNjb3VudCI6Inp4In0.zF6XoMx2RljYHaPpHuqsz7QzwpEzBIC8U9S9v7v9yxI
```

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

## stream

```
示例：
 boolean isRepeat = (saveVo.getDiffItemList().size())
 != (saveVo.getDiffItemList().stream().mapToLong(t -> t.getResultStore()).distinct().count());
 if (isRepeat) {
 	ExceptionUtil.throwError(LogicConvertEtlErr.INVALID_PARAM.getCode(), "比较结果存储字段不能重复！");
 }
 
 List<String> diffMethodList = list.stream().map(t->t.getDiffMethod()).distinct().collect(Collectors.toList());
 
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
 
/**
 * 通过简单的代码判断List中是否包含相同元素
 * @author wei 2017年7月10日 下午8:34:47
 */
public class ListHaveRepeat {
    public static void main(String[] args) {
        List<String> list = new ArrayList<String>();
        list.add("1");
        list.add("2");
        list.add("2");
        // 通过去重之后的HashSet长度来判断原list是否包含重复元素
        boolean isRepeat = list.size() != new HashSet<String>(list).size();
        System.out.println("list中包含重复元素：" + isRepeat);
    }
}
```



## selectByExample

```
Example exampleEtlJoin = new Example(TbUcCfgEtlJoin.class);
Example.Criteria criteriaEtlJoin  = exampleEtlJoin.createCriteria();
criteriaEtlJoin.andEqualTo("etlTaskId", tbUcCfgAdtRule.getAdtId());
exampleEtlJoin.orderBy("sequ");
List<TbUcCfgEtlJoin> etlJoinList = tbUcCfgEtlJoinService.selectByExample(exampleEtlJoin);
```

## selectOneByExample

```
Example example = new Example(TbUcCfgQuoteDs.class);
Example.Criteria criteria = example.createCriteria();
criteria.andEqualTo("dsId", dsId);
int count = this.selectCountByExample(example);
```

## updateByExampleSelective

```
首先：updateByExampleSelective(@Param(“record”) Xxx record, @Param(“example”) XxxExample example);

第一个参数 是要修改的部分值组成的对象，其中有些属性为null则表示该项不修改。

第二个参数 是一个对应的查询条件的类， 通过这个类可以实现 order by 和一部分的where 条件。

使用方法大概如下：

public void edit(Long id, String name) {
    Example example = new Example(Category.class);
    Example.Criteria criteria = example.createCriteria();
    criteria.andEqualTo("id",id);
    Category category = new Category();
    category.setName(name);
    categoryMapper.updateByExampleSelective(category,example);
}

updateByExampleSelective是更新一条数据中的某些属性，而不是更新整条数据。
而updateByExample需要将表的条件全部给出，也就是要给出一个对象，以下给出代码：

Example example = new Example(TbUcCfgEtlFilter.class);
Example.Criteria criteria = example.createCriteria();
criteria.andEqualTo("etlTaskId", tbUcCfgEtlTask.getEtlTaskId());
if (tbUcCfgEtlFilterService.updateByExampleSelective(tbUcCfgEtlFilter,example) < 1) {
	ExceptionUtil.throwError(LogicConvertEtlErr.OPERATE_FAIL.getCode(),"修改etl过滤表达式失败");
}

//修改-一致性规则表
Example exampleDiff = new Example(TbUcCfgDiff.class);
Example.Criteria criteriaDiff = exampleDiff.createCriteria();
criteriaDiff.andEqualTo("adtId", saveVo.getDiff().getAdtId());
tbUcCfgDiffService.updateByExampleSelective(saveVo.getDiff(),exampleDiff);
```

## deleteByExample

```
//删除etl任务 - tb_uc_cfg_etl_task
Example exampleEtlTask = new Example(TbUcCfgEtlTask.class);
Example.Criteria criteriaEtlTask = exampleEtlTask.createCriteria();
criteriaEtlTask.andEqualTo("etlTaskId", nodeId);
tbUcCfgEtlTaskService.deleteByExample(exampleEtlTask)
```

## For

```
for (TbUcCfgDiffItem cur : diffItems) {

}
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

## map

```
参考：
	https://blog.csdn.net/weixin_39723544/article/details/97976604
public static void main(String[] args) throws Exception {
    // 将集合中的所有的小写字母转为大写字母
    List<String> list = new ArrayList<>();
    list.add("hello");
    list.add("world");
    list.add("java");
    list.add("python");
    List<String> result = list.stream().map(String::toUpperCase).collect(Collectors.toList());
    System.out.println(result);
}
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

例：throws方法抛出异常
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

# Java 8 新特性

## computeIfAbsent

```
#computeIfAbsent:存在时返回存在的值，不存在时返回新值
#参数为：key，value计算方法
#当key不存在时，执行value计算方法，计算value

@Test
public void testMap() {
    Map<String, String> map = new HashMap<>();
    map.put("a","A");
    map.put("b","B");
    String v = map.computeIfAbsent("b",k->"v");  // 输出 B
    System.out.println(v);
    String v1 = map.computeIfAbsent("c",k->"v"); // 输出 v
    System.out.println(v1);
}
```

## computeIfPresent

```
HashMap<String,Integer> map = new HashMap<>();
map.put("1",1);
map.put("2",2);
map.put("3",3);
//只对map中存在的key对应的value进行操作
Integer integer = map.computeIfPresent("3", (k,v) -> v+1 );
Integer integer1 = map.computeIfPresent("4", (k,v) -> {
if (v==null)return 0;
return v+1;
} );
System.out.println(integer);
System.out.println(integer1);
System.out.println(map.toString());
```

## put

```
#put返回旧值，如果没有则返回null
@Test
public void testMap() {
    Map<String, String> map = new HashMap<>();
    map.put("a","A");
    map.put("b","B");
    String v = map.put("b","v"); // 输出 B
    System.out.println(v);
    String v1 = map.put("c","v");
    System.out.println(v1); // 输出：NULL
}
```

## putIfAbsent

```
#putIfAbsent返回旧值，如果没有则返回null,先计算value，再判断key是否存在
@Test
public void testMap() {
    Map<String, String> map = new HashMap<>();
    map.put("a","A");
    map.put("b","B");
    String v = map.putIfAbsent("b","v");  // 输出 B
    System.out.println(v);
    String v1 = map.putIfAbsent("c","v");  // 输出 null
    System.out.println(v1);
}
```



## compute

```
#（相当于put,只不过返回的是新值）,当key不存在时，执行value计算方法，计算value
@Test
public void testMap() {
    Map<String, String> map = new HashMap<>();
    map.put("a", "A");
    map.put("b", "B");
    String val = map.compute("b", (k, v) -> "v"); // 输出 v
    System.out.println(val);
    String v1 = map.compute("c", (k, v) -> "v"); // 输出 v
    System.out.println(v1);
}
```

# Java内存模型

```
参考：	
	https://www.cnblogs.com/zhengbin/p/6407137.html
	https://www.jianshu.com/p/15106e9c4bf3

java内存模型(Java Memory Model，JMM)是java虚拟机规范定义的，用来屏蔽掉java程序在各种不同的硬件和操作系统对内存的访问的差异，这样就可以实现java程序在各种不同的平台上都能达到内存访问的一致性。
```

# Java内存结构

```
参考：	https://www.jianshu.com/p/15106e9c4bf3
```

# java内存管理

```
参考：	
	http://blog.itpub.net/69904796/viewspace-2565255/
	https://www.cnblogs.com/steffen/p/11368018.html
	https://blog.csdn.net/qq_29078329/article/details/78929457
```

