# **常用**

```

```

## PHP取整

```
1.直接取整，舍弃小数，保留整数：intval()；
2.四舍五入取整：round()；
3.向上取整，有小数就加1：ceil()；
4.向下取整：floor()。

一、intval—对变数转成整数型态
    intval如果是字符型的会自动转换为0。
    intval(3.14159);  // 3
    intval(3.64159);  // 3
    intval('ruesin'); //0

二、四舍五入：round()
    根据参数2指定精度将参数1进行四舍五入。参数2可以是负数或零（默认值）。
    round(3.14159);      // 3
    round(3.64159);      // 4
    round(3.64159, 0);   // 4
    round(3.64159, 2);   // 3.64
    round(5.64159, 3);   // 3.642
    round(364159, -2);   // 364200

三、向上取整，有小数就加1：ceil()
    返回不小于 value 的下一个整数，value 如果有小数部分则进一位。
    这个方法，在我们写分页类计算页数时经常会用到。
    ceil(3.14159);  // 4
    ceil(3.64159);  // 4

四、向下取整：floor()
    返回不大于 value 的下一个整数，将 value 的小数部分舍去取整。
    floor(3.14159);    // 3
    floor(3.64159);    // 3
```



# 常见问题

## **连不上数据库常见原因**

```
ip限制
ip冲突
```
## ERR_CONNECTION_TIMED_OUT

```
关闭防火墙： 
	service iptables stop 
启动oracle： 
    su - oracle
    sqlplus /nolog
    conn /as sysdba
    startup | shutdown
启动oracle监听：
    su - oracle
    lsnrctl status
    lsnrctl start|stop
vim /etc/hosts
```

## 访问慢

```
数据库服务器
vim /etc/resolv.conf
注释掉dns配置

```



# **安装**

```

```
# session

```
会话过期设置php.ini：
    session.cookie_lifetime = 30
    session.gc_maxlifetime = 30
```

# 治理系统

## 添加治理域

```

1、参数配置-公共参数页面新增治理域，从表tb_ua_cfg_biz_domain找到biz_domain_id
2、找到inc_chk\audit_config\adt_role_func.php文件，搜索function getHasSingleCfgByRole关键字，
	修改：select * from tb_ua_cfg_biz_domain a where a.biz_domain_id  in ('1698600','1698601','1700708','1700709','1740679') 
3、治理开发平台-我的治理服务：上线
4、参数配置-权限管理-角色管理：赋权

--  '1698600','1698601','1700708','1700709','1744944'

select distinct C.SERVICE_ID, C.SERVICE_NAME, C.BIZ_DOMAIN, C.SEQU
  from TB_UC_CFG_REPORT           A,
       tb_ua_cfg_sub_service_type B,
       tb_ua_cfg_service_type     C
 where 1 = 1
   and a.sub_service_id = b.sub_service_id
   and a.service_id = c.service_id
   and b.status = 'O'
   and b.ONLINE_STATUS = 'ONLINE'
   and C.BIZ_DOMAIN = 1744944
   
   --select * from TB_UC_CFG_REPORT
   
   select * from tb_ua_cfg_biz_domain where name_cn like ( '主网系统')
   select * from tb_ua_cfg_service_type where biz_domain = (select biz_domain_id from tb_ua_cfg_biz_domain where name_cn like ( '主网系统'))
   select * from tb_ua_cfg_sub_service_type where service_id in (select service_id from tb_ua_cfg_service_type where biz_domain = 1744944)
 
 
   select * from TB_UC_ROLE_RIGHT where role_id='1000' and uc_rsc_type='SUB_SERVICE' 
   delete TB_UC_ROLE_RIGHT where role_id='1000' and uc_rsc_type='SUB_SERVICE' 
   insert into TB_UC_ROLE_RIGHT(ROLE_RIGHT_ID,ROLE_ID,UC_RSC_TYPE,UC_RSC_ID,RIGHT) 		values(SEQ_UA_TO_CFG.nextval,'1000','SUB_SERVICE',1723201,'EDIT') 
```
## 权限

```

```

# 现场部署

```
全局替换：
    172.16.7.55 -> 替换为现场数据库ip
    172.16.7.71 -> 替换为现场清洗接口ip
惠州要求不要公司logo：
    inc_chk/new_index/index.php文件：
        注释：<img src="images/logo.png" />
    inc_chk/login_html.php文件：
        注释：<img src="./app/images/ht-logo.png" class="ht-logo" alt="汇通国信" />
```

