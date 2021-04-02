# 内容安全策略CSP（Content-Security-Policy）

```
3.CSP 语法
    3.1 策略
    每一条策略都是指令与指令值组成：

    Content-Security-Policy:指令1 指令值1
    策略与策略之间用分号隔开,例如：

    Content-Security-Policy:指令1 指令值1；指令2 指令值2；指令3 指令值3
    在一条策略中，如果一个指令中有多个指令值，则指令值之间用空号隔开：

    Content-Security-Policy:指令a 指令值a1 指令值a2
3.2 CSP 指令
    default-src : 定义针对所有类型（js/image/css/font/ajax/iframe/多媒体等）资源的默认加载策略，如果某类型资源没有单独定义策略，就使用默认的。
    script-src : 定义针对 JavaScript 的加载策略。
    style-src : 定义针对样式的加载策略。
    img-src : 定义针对图片的加载策略。
    font-src : 定义针对字体的加载策略。
    media-src : 定义针对多媒体的加载策略，例如:音频标签<audio>和视频标签<video>。
    object-src : 定义针对插件的加载策略，例如：<object>、<embed>、<applet>。
    child-src :定义针对框架的加载策略，例如： <frame>,<iframe>。
    connect-src : 定义针对 Ajax/WebSocket 等请求的加载策略。不允许的情况下，浏览器会模拟一个状态为400的响应。
    sandbox : 定义针对 sandbox 的限制，相当于 <iframe>的sandbox属性。
    report-uri : 告诉浏览器如果请求的资源不被策略允许时，往哪个地址提交日志信息。
    form-action : 定义针对提交的 form 到特定来源的加载策略。
    referrer : 定义针对 referrer 的加载策略。
    reflected-xss : 定义针对 XSS 过滤器使用策略。
3.3 CSP 指令值
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
————————————————
原文链接：https://blog.csdn.net/qq_25623257/article/details/90473859

2.1 资源加载限制
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
        2.2 default-src
        default-src用来设置上面各个选项的默认值。

Content-Security-Policy: default-src 'self' ：限制所有的外部资源，都只能从当前域名加载。
如果同时设置某个单项限制（比如font-src）和default-src，前者会覆盖后者，即字体文件会采用font-src的值，其他资源依然采用default-src的值。

2.3 URL 限制
    有时，网页会跟其他 URL 发生联系，这时也可以加以限制。
    frame-ancestors：限制嵌入框架的网页
    base-uri：限制<base#href>
    form-action：限制<form#action>
    
2.4 其他限制
	其他一些安全相关的功能，也放在了 CSP 里面。
    block-all-mixed-content：HTTPS 网页不得加载 HTTP 资源（浏览器已经默认开启）
    upgrade-insecure-requests：自动将网页上所有加载外部资源的 HTTP 链接换成 HTTPS 协议
    plugin-types：限制可以使用的插件格式
    sandbox：浏览器行为的限制，比如不能有弹出窗口等。
    
2.5 report-uri
	有时，我们不仅希望防止 XSS，还希望记录此类行为。report-uri就用来告诉浏览器，应该把注入行为报告给哪个网址。
    Content-Security-Policy: default-src 'self'; ...; report-uri /my_amazing_csp_report_parser;
    上面代码指定，将注入行为报告给/my_amazing_csp_report_parser这个 URL。

三、Content-Security-Policy-Report-Only
	除了Content-Security-Policy，还有一个Content-Security-Policy-Report-Only字段，表示不执行限制选项，只是记录违反限制的行为。
    它必须与report-uri选项配合使用。
    Content-Security-Policy-Report-Only: default-src 'self'; ...; report-uri /my_amazing_csp_report_parser;

四、选项值
    每个限制选项可以设置以下几种值，这些值就构成了白名单。
    主机名：example.org，https://example.com:443
    路径名：example.org/resources/js/
    通配符：*.example.org，*://*.example.com:*（表示任意协议、任意子域名、任意端口）
    协议名：https:、data:
    关键字'self'：当前域名，需要加引号
    关键字'none'：禁止加载任何外部资源，需要加引号
    多个值也可以并列，用空格分隔。
    Content-Security-Policy: script-src 'self' https://apis.google.com
    如果同一个限制选项使用多次，只有第一次会生效。
        # 错误的写法
            script-src https://host1.com; script-src https://host2.com

        # 正确的写法
            script-src https://host1.com https://host2.com
    如果不设置某个限制选项，就是默认允许任何值。

五、script-src 的特殊值
	除了常规值，script-src还可以设置一些特殊值。注意，下面这些值都必须放在单引号里面。
    'unsafe-inline'：允许执行页面内嵌的&lt;script>标签和事件监听函数
    unsafe-eval：允许将字符串当作代码执行，比如使用eval、setTimeout、setInterval和Function等函数。
    nonce值：每次HTTP回应给出一个授权token，页面内嵌脚本必须有这个token，才会执行
    hash值：列出允许执行的脚本代码的Hash值，页面内嵌脚本的哈希值只有吻合的情况下，才能执行。
    nonce值的例子如下，服务器发送网页的时候，告诉浏览器一个随机生成的token。

    Content-Security-Policy: script-src 'nonce-EDNnf03nceIOfn39fn3e9h3sdfa'
    页面内嵌脚本，必须有这个token才能执行。

    <script nonce=EDNnf03nceIOfn39fn3e9h3sdfa>
      // some code
    </script>
    hash值的例子如下，服务器给出一个允许执行的代码的hash值。

    Content-Security-Policy: script-src 'sha256-qznLcsROx4GACP2dm0UCKCzCG-HiZ1guq6ZZDob_Tng='
    下面的代码就会允许执行，因为hash值相符。

    <script>alert('Hello, world.');</script>
    注意，计算hash值的时候，<script>标签不算在内。

    除了script-src选项，nonce值和hash值还可以用在style-src选项，控制页面内嵌的样式表。

六、注意点
	（1）script-src和object-src是必设的，除非设置了default-src。

	因为攻击者只要能注入脚本，其他限制都可以规避。而object-src必设是因为 Flash 里面可以执行外部脚本。

	（2）script-src不能使用unsafe-inline关键字（除非伴随一个nonce值），也不能允许设置data:URL。


```

# httpd.conf

```
<IfModule headers_module>
    #
    # Avoid passing HTTP_PROXY environment to CGI's on this or any proxied
    # backend servers which have lingering "httpoxy" defects.
    # 'Proxy' request header is undefined by the IETF, not listed by IANA
    #
    RequestHeader unset Proxy early
    #Header always set Content-Security-Policy "default-src https: data: blob: 'unsafe-inline' 'unsafe-eval'"
    Header always set Content-Security-Policy: "default-src 'self' 'unsafe-inline'  https://172.16.7.71;img-src 'self' data: base64;script-src 'self' 'unsafe-inline' 'unsafe-eval';"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Xss-Protection "1; mode=block"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always edit Set-Cookie ^(.*)$ "$1;HttpOnly;Secure"
    Header always set Strict-Transport-Security "max-age=31536000;includeSubdomains; preload"
    Header always set Set-Secure "httponly;true;"
</IfModule>

<IfModule headers_module>
    #
    # Avoid passing HTTP_PROXY environment to CGI's on this or any proxied
    # backend servers which have lingering "httpoxy" defects.
    # 'Proxy' request header is undefined by the IETF, not listed by IANA
    #
    RequestHeader unset Proxy early
    Header always set Content-Security-Policy "default-src 'self' 'unsafe-inline' 'unsafe-eval' https: data: blob: https://192.20.1.86;"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Xss-Protection "1; mode=block"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always edit Set-Cookie ^(.*)$ "$1;HttpOnly;Secure"
    Header always set Strict-Transport-Security "max-age=31536000;includeSubdomains; preload"
    Header always set Set-Secure "httponly;true;"
</IfModule>

```

