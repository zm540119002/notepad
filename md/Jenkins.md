# Manage Jenkins

```

```

## System Configuration（配置服务器）

```
SSH Servers->add，添加服务器
name
hostname
username
Remote Directory
勾选：Use password authentication, or use a different key
填写密码：Passphrase / Password
```

# 示例

## Exec command

```
#jenkins使用非交互式shell，读取不到dev的环境变量，先加载dev的环境变量
.  /etc/profile
.  ~/.bash_profile
cd  /www/data_govern/jars/temp
mv */*/*.jar */*/*/*.jar  /www/data_govern/jars
true  > ~/env.log
env > ~/env.log
which java >> ~/env.log
nohup /home/dev/sbin/start_all.sh
```

