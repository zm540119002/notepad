

# 常用命令

```
sudo gitlab-ctl start # 启动所有 gitlab 组件；
sudo gitlab-ctl stop # 停止所有 gitlab 组件；
sudo gitlab-ctl restart # 重启所有 gitlab 组件；
sudo gitlab-ctl status # 查看服务状态；
sudo gitlab-ctl reconfigure # 启动服务；
sudo vim /etc/gitlab/gitlab.rb # 修改默认的配置文件；
gitlab-rake gitlab:check SANITIZE=true --trace # 检查gitlab；
sudo gitlab-ctl tail # 查看日志；
```



# gitlab 配置详解

```

gitlab配置文件
	/etc/gitlab/gitlab.rb

unicorn配置文件
	/var/opt/gitlab/gitlab-rails/etc/unicorn.rb

nginx配置文件
	/var/opt/gitlab/nginx/conf/gitlab-http.conf

gitlab仓库默认位置
	/var/opt/gitlab/git-data/repositories
```

# 日志系统

```

```



# 502 Whoops, GitLab is taking too much time to respond

```
一、异常现象：
	gitlab访问错误Whoops, GitLab is taking too much time to respond
二、问题定位
	问题定位8080端口被占用：
三、解决方案
	解决方案01：
        将占用的8080端口的进程杀死
        或者卸载占用8080端口的软件
        修改正在占用8080端口程序的端口运行
        重新启动gitlab
	解决方案02：
        将external_url添加一个未被使用的端口
        	external_url 'http://192.168.45.146
        修改为没有使用的端口即可：
        	external_url 'http://192.168.45.146:8899'
        将下面这3行打开注释
        默认注释：
            unicorn['port'] = 8088
            postgresql['shared_buffers'] = "256MB"
            postgresql['max_connections'] = 200
        	重新启动gitlab，即可
        gitlab常用命令：
            重启配置，并启动gitlab服务 sudo gitlab-ctl reconfigure
            启动所有 gitlab sudo gitlab-ctl start
            重新启动GitLab sudo gitlab-ctl restart
            停止所有 gitlab sudo gitlab-ctl stop
            查看服务状态 sudo gitlab-ctl status
            查看Gitlab日志 sudo gitlab-ctl tail
            修改默认的配置文件 sudo vim /etc/gitlab/gitlab.rb
            检查gitlab gitlab-rake gitlab:check SANITIZE=true --trace
            
可能问题：
端口：
	firewall-cmd --query-port=9090/tcp
	firewall-cmd --permanent --add-port=9091/tcp
```

# 三步解决gitlab 磁盘空间不足问题处理

```
参考：
	https://blog.csdn.net/ss300400a/article/details/102466458
	
默认情况下omnibus-gitlab 将仓库数据存储在 /var/opt/gitlab/git-data目录下，仓库存放在子目录 repositories里面。 以可以通过修改/etc/gitlab/gitlab.rb 的这一行来自定义 git-data 的父目录

[root@gitlab ~]#  mkdir /home/data/gitlab/git-data   //创建目录
[root@gitlab ~]#  vim /etc/gitlab/gitlab.rb   //修改默认路径
# 把注释取消然后指定新的仓库存储位置 
git_data_dirs({ "default" => { "path" => "/home/data/gitlab/git-data" } })

注： /home/data/gitlab/git-data 这个是手动创建的目录
	
git_data_dirs({
    "default" => {
        "path" => "/home/data/gitlab/git-data",
        "failure_count_threshold" => 10,
        "failure_wait_time" => 30,
        "failure_reset_time" => 1800,
        "storage_timeout" => 30
    }
})

使设置生效
1.没有数据的情况下
[root@gitlab ~]#  gitlab-ctl stop      //有的需要使用 sudo gitlab-ctl stop
[root@gitlab ~]# gitlab-ctl reconfigure //使修改生效

2.有数据的情况下
如果 /var/opt/gitlab/git-data 目录已经存在Git仓库数据， 你可以用下面的命令把数据迁移到新的位置:

# 准备迁移之前要停止GitLab服务，防止用户写入数据。
[root@gitlab ~]# gitlab-ctl stop
 
# 注意 'repositories'后面不带斜杠，而
# '/home/gitlab-data'后面是有斜杠的。
[root@gitlab ~]# rsync -av /var/opt/gitlab/git-data/repositories /home/data/gitlab/git-data
 
# 如果需要修复权限设置，
# 可运行下面的命令进行修复。
[root@gitlab ~]# gitlab-ctl reconfigure
 
# 再次检查下  /home/gitlab-data 的目录. 正常情况应该有下面这个子目录:
# repositories
[root@gitlab git-data]# ls /home/data/gitlab/git-data
repositories


# 将 刚刚迁移的包 @hashed 放入到repositories 下
[root@gitlab git-data]#mv @hashed repositories 
 
# 完工! 启动GitLab，验证下是否能
# 通过web访问Git仓库。
[root@gitlab ~]# gitlab-ctl start

设置存储仓库数据的备用目录
注意的是：自GitLab 8.10开始,可以通过在/etc/gitlab/gitlab.rb文件中添加下面的几行配置， 来增加多个 git 数据存储目录。

git_data_dirs({
  "default" => { "path" => "/var/opt/gitlab/git-data" },  //默认存储目录
  "alternative" => { "path" => " /home/gitlab-data" }     //备用存储目录
})

```

