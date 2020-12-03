

# ResponseHeader

## Content Security Policy 

参考：

​		https://cloud.tencent.com/developer/section/1189856

​		http://www.ruanyifeng.com/blog/2016/09/csp.html

```
Content-Security-Policy:指令1 指令值1；指令2 指令值2；指令3 指令值3

CSP 指令
    default-src : 定义针对所有类型（js/image/css/font/ajax/iframe/多媒体等）资源的默认加载策略，如果某类型资源没有单独定义策略，就使用默认的。
    script-src : 定义针对 JavaScript 的加载策略。
    style-src : 定义针对样式的加载策略。
    img-src : 定义针对图片的加载策略。
    font-src : 定义针对字体的加载策略。
    media-src : 定义针对多媒体的加载策略，例如:音频标签<audio>和视频标签<video>。
    object-src : 定义针对插件的加载策略，例如：<object>、<embed>、<applet>。
    child-src :定义针对框架的加载策略，例如： <frame>,<iframe>。
    connect-src : 定义针对 Ajax/WebSocket 等请求的加载策略。不允许的情况下，浏览器会模拟一个状态为400的响应。
    sandbox : 定义针对 sandbox 的限制，相当于 <iframe>的sandbox属性。
    report-uri : 告诉浏览器如果请求的资源不被策略允许时，往哪个地址提交日志信息。
    form-action : 定义针对提交的 form 到特定来源的加载策略。
    referrer : 定义针对 referrer 的加载策略。
    reflected-xss : 定义针对 XSS 过滤器使用策略。
    
指令值	说明
    *	允许加载任何内容
    ‘none‘	不允许加载任何内容
    ‘self‘	允许加载相同源的内容
    www.a.com	允许加载指定域名的资源
    *.a.com	允许加载 a.com 任何子域名的资源
    https://a.com	允许加载 a.com 的 https 资源
    https：	允许加载 https 资源
    data：	允许加载 data: 协议，例如：base64编码的图片
    ‘unsafe-inline‘	允许加载 inline 资源，例如style属性、onclick、inline js、inline css等
    ‘unsafe-eval‘	允许加载动态 js 代码，例如 eval()
```



```
CSP 的实质就是白名单制度，开发者明确告诉客户端，哪些外部资源可以加载和执行，等同于提供白名单。它的实现和执行全部由浏览器完成，开发者只需提供配置。
CSP 大大增强了网页的安全性。攻击者即使发现了漏洞，也没法注入脚本，除非还控制了一台列入了白名单的可信主机。

两种方法可以启用 CSP:
一种是通过 HTTP 头信息的Content-Security-Policy的字段。
	Content-Security-Policy: script-src 'self'; object-src 'none';
	style-src cdn.example.org third-party.org; child-src https:
	
另一种是通过网页的<meta>标签。
	<meta http-equiv="Content-Security-Policy" content="script-src 'self'; object-src 'none'; 
	style-src cdn.example.org third-party.org; child-src https:">

上面代码中，CSP 做了如下配置。
    1、脚本：只信任当前域名
    2、<object>标签：不信任任何URL，即不加载任何资源
    3、样式表：只信任cdn.example.org和third-party.org
    4、框架（frame）：必须使用HTTPS协议加载
    5、其他资源：没有限制

以下选项限制各类资源的加载。
    script-src：外部脚本
    style-src：样式表
    img-src：图像
    media-src：媒体文件（音频和视频）
    font-src：字体文件
    object-src：插件（比如 Flash）
    child-src：框架
    frame-ancestors：嵌入的外部资源（比如<frame>、<iframe>、<embed>和<applet>）
    connect-src：HTTP 连接（通过 XHR、WebSockets、EventSource等）
    worker-src：worker脚本
    manifest-src：manifest 文件
    
default-src用来设置上面各个选项的默认值。
	Content-Security-Policy: default-src 'self'
	
上面代码限制所有的外部资源，都只能从当前域名加载。
如果同时设置某个单项限制（比如font-src）和default-src，前者会覆盖后者，即字体文件会采用font-src的值，其他资源依然采用default-src的值。

示例：禁用不安全的内联/评估，仅允许通过https：
    // header
    Content-Security-Policy: default-src https:
    // meta tag
    <meta http-equiv="Content-Security-Policy" content="default-src https:">
    
示例：预先存在的站点使用过多的内联代码进行修复，但希望确保仅通过 https 加载资源并禁用插件：
	Content-Security-Policy: default-src https: 'unsafe-eval' 'unsafe-inline'; object-src 'none'

```

X-Content-Type-Options

```
X-Content-Type-Options ：nosniff
X-Frame-Options  ：SAMEORIGIN
X-XSS-Protection ：1; mode=block
```

## php

```
php文件：
	header("Content-Security-Policy: script-src 'self';");
	setcookie('Secure','true','10','/','self',true,true);
php.ini:
	session.cookie_httponly = true
	session.cookie_secure = true
	如果开启则表明你的cookie只有通过HTTPS协议传输时才起作用
	总结如下：cookie的secure值为true时，在http中是无效的；在https中才有效。
```

## apache 

```
http.conf:
	<IfModule headers_module>
        Header always set Content-Security-Policy "default-src 'self' 'unsafe-inline' 'unsafe-eval' https://172.16.7.71;object-src 'none';"
        Header always set X-Content-Type-Options "nosniff"
        Header always set X-Xss-Protection "1; mode=block"
        Header always set X-Frame-Options "SAMEORIGIN"
        Header always edit Set-Cookie ^(.*)$ "$1;HttpOnly;Secure"
        Header always set Strict-Transport-Security "max-age=31536000;includeSubdomains; preload"
        Header always set Set-Secure "httponly;true;"
	</IfModule>
	
目录不可访问：
	Options Indexes FollowSymLinks 改成： Options FollowSymLinks
	其实就是将Indexes去掉，Indexes表示若当前目录没有index.html就会显示目录结构

```

## nginx

```
nginx:
	add_header  X-Frame-Options "SAMEORIGIN" always;
	add_header  X-Xss-Protection "1; mode=block" always;
	add_header  X-Content-Type-Options "nosniff" always;
	add_header  Referrer-Policy  "no-referrer-when-downgrade" always;
	add_header Content-Security-Policy "default-src 'self' script-src 'self'; https:" always;
	add_header Strict-Transport-Security "max-age=31536000; " always; 
	add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";
```

## java

```
//简称为HSTS。它允许一个HTTPS网站，要求浏览器总是通过HTTPS来访问它
	httpServletResponse.setHeader("strict-transport-security","max-age=16070400; includeSubDomains");

//这个响应头主要是用来定义页面可以加载哪些资源，减少XSS的发生
httpServletResponse.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'self'; frame-ancestors 'self'; object-src 'none'");

//互联网上的资源有各种类型，通常浏览器会根据响应头的Content-Type字段来分辨它们的类型。通过这个响应头可以禁用浏览器的类型猜测行为
httpServletResponse.setHeader("X-Content-Type-Options", "nosniff");

//1; mode=block：启用XSS保护，并在检查到XSS攻击时，停止渲染页面
httpServletResponse.setHeader("X-XSS-Protection", "1; mode=block");

//SAMEORIGIN：不允许被本域以外的页面嵌入
httpServletResponse.setHeader("X-Frame-Options", "SAMEORIGIN");
```

