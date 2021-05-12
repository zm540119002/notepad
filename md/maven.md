# *Linux版*

## 安装配置

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

## 注意事项

```
--会执行单元测试
	mvn  -Dmaven.multiModuleProjectDirectory=M:\data-govern -Dmaven.home=E:\java\MAVEN\apache-maven-3.6.3   
	-DskipTests=true package

-- 不会执行单元测试
	mvn  -Dmaven.multiModuleProjectDirectory=M:\data-govern -Dmaven.home=E:\java\MAVEN\apache-maven-3.6.3   
	-Dmaven.test.skip=true package

maven插件选中了不执行单元测试  打包时还是会执行  原来它是加了 -DskipTests=true
mvn clean install -P dev -Dmaven.test.skip=true -Dmaven.javadoc.skip=true
```

# windows版

## *C:\Users\Administrator\.m2\settings.xml*

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

