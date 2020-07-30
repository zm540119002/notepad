================================================

================================================常用注解：
@Data ： 注在类上，提供类的get、set、equals、hashCode、canEqual、toString方法
@Value : 注解和@Data类似，区别在于它会把所有成员变量默认定义为private final修饰，并且不会生成set方法
@AllArgsConstructor ： 注在类上，提供类的全参构造
@NoArgsConstructor ： 注在类上，提供类的无参构造
@Setter ： 注在属性上，提供 set 方法
@Getter ： 注在属性上，提供 get 方法
@EqualsAndHashCode ： 注在类上，提供对应的 equals 和 hashCode 方法
@Log4j/@Slf4j ： 注在类上，提供对应的 Logger 对象，变量名为 log
@Override	注解是伪代码，用于表示被标注的方法是一个重写方法。
@Controller	声明为控制器，可返回jsp、html页面的名称并跳转到相应页面
@ResponseBody与@Controller结合使用，表明返回json数据
@RestController相当于@ResponseBody+@Controller 表明此控制器返回json
@RequestMapping(value= 'xx', method=XX)表明方法是处理那种类型、什么地址的请求，返回值默认解析为跳转路径
@GetMapping()	组合注解，是@RequestMapping(method = RequestMethod.GET)的缩写
@PostMapping()	组合注解，是@RequestMapping(method = RequestMethod.POST)的缩写
------------------------------------------------Spring 
@Transactional 注解管理事务
	@Transactional 可以作用在接口、类、类方法。
	作用于类：当把@Transactional 注解放在类上时，表示所有该类的public方法都配置相同的事务属性信息。
	作用于方法：当类配置了@Transactional，方法也配置了@Transactional，方法的事务会覆盖类的事务配置信息。
	作用于接口：不推荐这种使用方法，因为一旦标注在Interface上并且配置了Spring AOP 使用CGLib动态代理，将会导致@Transactional注解失效
================================================
PO(Persistant Object)
	可以看成是与数据库中的表相映射的java对象。最简单的PO就是对应数据库中某个表中的一条记录，多个记录可以用PO的集合。
	PO中应该不包含任何对数据库的操作。
	好处就是可以把一条记录作为一个对象处理，可以方便的转为其他对象。
VO(Value Object)
	VO值对象，通常用于业务层之间的数据传递，与PO一样仅包含数据，根据业务的需要与抽象出的业务对象实现对应或者非对应。
	VO主要对应界面显示的数据对象。对于一个WEB页面，或者SWT/SWING的一个界面，用一个VO对象对应整个界面的值。
相同点
	VO与PO均由一组属性和属性的get和set方法组成，结构上没有不同，但是本质上完全不同。
	VO是用new关键字创建，由GC回收。
差异点
	PO是向数据库中添加新数据时创建，删除数据库中数据时削除。并且PO只能存活在一个数据库连接中，断开连接就被销毁。
DAO(Data Access Object数据访问对象)
	用于访问数据库，通常与PO结合使用，DAO包含了各种数据库的操作方法，
	通过方法结合PO对数据库进行相关操作，夹在业务层逻辑与数据库资源中间，配合VO，提供数据库的CRUD（增删改查）操作。
DTO(Data Transfer Object,数据传输对象)
	主要用于远程调用等需要大量传输对象的地方。
	比如说，我们一张表有100个字段，那么对应的PO就有100个属性。但是我们界面上只要显示10个字段， 客户端用WEB service来获取数据，没有必要把整个PO对象传递到客户端， 这时我们就可以用只有这10个属性的DTO来传递结果到客户端，这样也不会暴露服务端表结构.到达客户端以后，如果用这个对象来对应界面显示，那此时它的身份就转为VO。
	DTO 是一组需要跨进程或网络边界传输的聚合数据的简单容器。它不应该包含业务逻辑，并将其行为限制为诸如内部一致性检查和基本验证之类的活动。注意，不要因实 现这些方法而导致 DTO 依赖于任何新类。在设计数据传输对象时，您有两种主要选择：使用一般集合；或使用显式的 getter 和 setter 方法创建自定义对象
	
DAO ：数据访问对象 —— 同时还有 DAO 模式
DTO ：数据传输对象 —— 同时还有 DTO 模式

================================================
import com.fasterxml.jackson.annotation.JsonFormat;
import com.alibaba.fastjson.JSONObject;
------------------------------------
import java.io.Serializable;
------------------------------------
import java.math.BigDecimal;
------------------------------------
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
------------------------------------
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
------------------------------------
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
================================================究研治理项目的网关布署到57环境上,mybatis事务使用
nohup java -jar data-govern.jar >> test.log &
nohup java -jar target/baop-gateway-1.0.1-SNAPSHOT.jar >> govern-geteway.log &
nohup java -jar baop-gateway-1.0.1-SNAPSHOT.jar >> baop-gateway-1.0.1-SNAPSHOT.log &
================================================

================================================

================================================

================================================

================================================
