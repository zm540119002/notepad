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

### 误删idea 的.iml文件后的处理方法

```
生成.ipr文件: mvn idea:project
生成.iws文件: mvn idea:workspace
生成.iml文件: mvn idea:module
```

## 快捷键

```
iter
var

```

