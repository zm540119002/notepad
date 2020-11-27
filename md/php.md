# **常用**

```

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