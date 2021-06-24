# 语法

```
创建用户、授权
	使用 SYSDBA 账户 登录达梦，默认密码：SYSDBA 或者  SYSDBA123
命令：
    CREATE USER USER_NAME;      ---创建用户
    GRANT DBA TO USER_NAME;    ---授予DBA角色

修改用户密码命令：
	ALTER USER USER_NAME IDENTIFIED  BY “用户口令”;   ---设置密码
```

# 注意事项

## 扩展

```
达梦扩展需配置linux环境变量
    vim /etc/profile
    export LD_LIBRARY_PATH=/data/home/dmdbms/bin
	注意：有些系统LD_LIBRARY_PATH参数无效，得把达梦dmdbms/bin目录下的so copy到 /usr/bin目录下：cp -pi dmdbms/bin/*so /usr/bin
```

