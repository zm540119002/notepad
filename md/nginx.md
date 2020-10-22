# 语法详解

```
语法规则： location [=|~|~*|^~] /uri/ { … }
= 开头表示精确匹配

^~ 开头表示uri以某个常规字符串开头，理解为匹配 url路径即可。nginx不对url做编码，因此请求为/static/20%/aa，可以被规则^~ /static/ /aa匹配到（注意是空格）。

~ 开头表示区分大小写的正则匹配

~*  开头表示不区分大小写的正则匹配

!~和!~*分别为区分大小写不匹配及不区分大小写不匹配 的正则

/ 通用匹配，任何请求都会匹配到。

多个location配置的情况下匹配顺序为（参考资料而来，还未实际验证，试试就知道了，不必拘泥，仅供参考）：

首先匹配 =，其次匹配^~, 其次是按文件中顺序的正则匹配，最后是交给 / 通用匹配。当有匹配成功时候，停止匹配，按当前匹配规则处理请求。

例子，有如下匹配规则：

location = / {精确匹配，必须是127.0.0.1/
	#规则A
}

location = /login {精确匹配，必须是127.0.0.1/login
	#规则B
}

location ^~ /static/ {非精确匹配，并且不区分大小写，比如127.0.0.1/static/js.
	#规则C
}

location ~ \.(gif|jpg|png|js|css)$ {区分大小写，以gif,jpg,js结尾
	#规则D
}

location ~* \.png$ {不区分大小写，匹配.png结尾的
	#规则E
}

location !~ \.xhtml$ {区分大小写，匹配不已.xhtml结尾的
	#规则F
}

location !~* \.xhtml$ {
	#规则G
}

location / {什么都可以
	#规则H
}
```

## 静态资源

```
# 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用
location ^~ /static/ {
    root /webroot/static/;
}
示例：
location ^~ /svg/ {
	root /www/wwwroot/front/;
}
location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    root /webroot/res/;
}
```

