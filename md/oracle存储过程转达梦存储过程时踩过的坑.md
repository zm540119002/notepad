达梦存储过程的语法与oracle的高度相似，但有好多细节还是有差异。我在这次项目迁移中踩过不少小坑，在这里给大家分享一下。



说明一下，我用的版本是达梦8，迁移时碰到的问题有些我已经反馈给达梦的官方群管理员，估计以后会有修复。



# rpad问题

达梦的rpad函数，**计算中文时永远是认为一个中文字符中两个字节**，即使数据库设置的字符集是utf8（目前就发现rpad/lpad函数有这个问题，其它字符串函数都能正确识别，当字符集是utf8时能识别出来一个字符中3个字节）

测试代码：

```sql
select rpad('我是hch', 6), lengthb('我是hch') from dual -- 达梦输出"我是hc 9"
union all
select rpad('我是hch', 5), length('我是hch') from dual -- 达梦输出"我是h 5" 
union all
select rpad('我是hch', 3), length('我是hch') from dual; -- 达梦输出"我 5"
```



这个问题达梦的工作人员说以后会修复，目前我的解决方法是自己写一个rpad函数

```sql
 function rpad_dm(string varchar2, padded_length number, pad_string varchar2 := ' ')
    return varchar2 IS
    v_len number := lengthb(string);
  BEGIN
  	    dbms_output.put_line('v_len - padded_length = ' );
  	if padded_length < v_len THEN
  		return substrb(string, 1, padded_length); --如果输入长度小于原字符串长度，则调用substrb截断
  	elsif padded_length = v_len THEN
  		return string; --如果长度相等直接返回原串即可
  	else
  		return string || rpad(' ', padded_length - v_len, pad_string); --如果长度大于原字符串，则在后面补空格
  	end if;
  END;
```



# 短路问题

一般编程语言都会提供短路功能，在计算与或逻辑时，如果前半段逻辑已经能确定真假时，后半段逻辑不会执行。

plsql里面也实现了短路功能，我们一般会利用这个特性减少一些代码，例如先判断变量是否为空，如果不为空再使用变量做运算：

> if (var is not null and va.exists('error') ) then dbms_output.put_line('yes');  fi;

但在达梦的存储过程，短路却没有实现。上面的代码不管var是否为空，都会进行va.exists('error')这个逻辑。如果不幸var的变量是空的，就会导致运行异常。



测试代码1：

```sql
dbms_output.enable;
declare
  v_flag boolean;
begin
  -- 请问这个存储过程执行异常，报"非法的参数数据"  是不是达梦的bug oracle下是可以正常运行的
  -- 还是有什么设置可以让存储过程正常执行
  if  (to_number('1') != 1) and to_number('abc') = 1 then
    dbms_output.put_line('yes');
  end if;
  dbms_output.put_line('ok');
end;
```



测试代码2：

```sql
dbms_output.enable;
declare
       TYPE TEST_RPT_LIST IS TABLE OF number INDEX BY PLS_INTEGER;
       o_demo_list TEST_RPT_LIST;
       i_report_id number := 17410491;
BEGIN
  -- 验证达梦8 if短路
  select 1 BULK COLLECT INTO o_demo_list from dual;
  dbms_output.put_line('o_demo_list(1) = ' || o_demo_list(1));


  if o_demo_list(1) = 1 or o_demo_list(2) = 2 THEN -- or 短路没问题
  	dbms_output.put_line('or yes'); -- or yes能正常输出
  end if;

  if o_demo_list(1) != 1 and o_demo_list(2) = 2 THEN -- o_demo_list(1) != 1 不成立  为什么还要执行o_demo_list(2) = 2判断
    dbms_output.put_line('and yes'); -- 这里永远不应该输出
  end if;

  dbms_output.put_line('done'); -- 走不到done
EXCEPTION
  WHEN no_data_found THEN
     dbms_output.put_line('no_data_found tbl_demo_tab ' || 'ID ' || to_char(i_report_id));
  WHEN OTHERS THEN
    -- RAISE;
    dbms_output.put_line('err:' || sqlcode || sqlerrm);
END;

```

**不只是if有短路问题，decode，case when等类似的都会有短路问题。**

"case 判断 when 表达式1 else 表达式2 end" 在oracle是如果条件成立则执行条件1并返回其值，而在达梦是同时执行表达式1和表达式2，并根据判断结果返回一个值。

解决方法是不要偷懒，不依赖短路实现，多写几个if判断，或者把decode拆成多个if else语句。



# 深浅拷贝问题

**oracle的table数组变量的赋值，默认是值复制（即深拷贝），而达梦默认是引用复制（即浅拷贝）。**

也就是说在oracle使用 tmpArr := arr (tmpArr 和arr 都是数组)，然后对这个tmpArr操作，不会影响arr的值，而在达梦，修改tmpArr数组元素的内容就是在修改arr



测试代码

```sql
        FOR vv IN 1 .. 5 -- crontab 初始化赋值
        LOOP                
                CASE vv
                WHEN 1 THEN
                        v_obj.minutes := tmpArr;
                WHEN 2 THEN
                        v_obj.hours := tmpArr;
                WHEN 3 THEN
                        v_obj.days := tmpArr;
                WHEN 4 THEN
                        v_obj.months := tmpArr;
                WHEN 5 THEN
                        v_obj.weeks := tmpArr;
                END CASE;
        END LOOP;
```

在oracle对v_obj这样赋值后，v_obj.minutes和v_obj.hours是两个不同的变量，分别对两个变量修改，相互之间不会出现干扰。而在达梦8，v_obj下面所有变量都指向同一个数组，**对v_obj任意一个成员修改，都会同时影响其它成员的值。**



解决方法是自己写一个数组拷贝函数，例如这样：

```sql
function copy1kList(v_input t_str_list) return t_str_list IS
    v_tmplist t_str_list;
    v_ind PLS_INTEGER;
  begin
    --TYPE t_str_list  IS TABLE OF VARCHAR2(1024) INDEX BY PLS_INTEGER;
  	if v_input.count > 0 then
  		/*
  		//在v_input里面的元素不连续时，这样会有bug
  		for vv in v_input.first .. v_input.last LOOP
  			v_tmplist(vv) := v_input(vv);
  		end loop;
  		*/
  		v_ind = v_input.first;
  		while v_ind is not null
  		loop
  			v_tmplist(v_ind) := v_input(v_ind);
  			v_ind = v_input.next(v_ind);
  		end loop;
  	end if;
  	return v_tmplist;
  end;
```

使用这个函数代替数组变量赋值就能维持代码行为与oracle一致。





# 时区问题

达梦8安装后默认的时区，不是操作系统的时区，而是0时区。这会导致sysdate返回时间有误，需要修改/etc/dm_svc.conf文件，在文件中添加TIME_ZONE=(480)才正常，如下：

> [root@ecs-htgx-0003 etc]# vi /etc/dm_svc.conf
> \# 以#开头的行表示是注释
> \# 全局配置区 dm_svc.conf
> TIME_ZONE=(480)
> LANGUAGE=(cn)
>
> DMHTGX=（192.168.0.137:5236)
>
> \# 服务配置区
> [DMHTGX] 
> LOGIN_MODE=(2)



# regexp_replace

达梦的正则匹配有问题，我踩的一个坑是这个：

---------------------



select regexp_replace('CC4.city', '([\(+-\*/|><=,]|^)(.+)', '\2', 1, 1, 'i') from dual;

这个语句执行结果oracle跟达梦不一样

----

select regexp_replace('CC4.city', '([+-\*]|^)(.+)', '\2', 1, 1, 'i') from dual; --输出 C4.city
--把+和-调换位置  oracle输出结果是一样的，但达梦却是不一样
select regexp_replace('CC4.city', '([-+\*]|^)(.+)', '\2', 1, 1, 'i') from dual; --输出 CC4.city

----

**仔细分析一下，是因为达梦把[]里面的+号字符，认为是正则表达式的元字符+（匹配前面的子表达式一次或多次）**



# 级联删除问题

oracle用户迁移到达梦数据库后，发现多了好多触发器。仔细看了一下代码，应该是实现外键case delete的。估计是达梦不支持外键级联删除，在迁移时自动把这些级联删除改成触发器。

不过改成触发器后，就无法实现oracle的延迟约束功能了（alter session set constraints=deferred）

这个问题无解





# BULK COLLECT问题

使用BULK COLLECT的查询语句，查不到记录时行为不同：oracle的BULK COLLECT查询默认是不会抛出no_data_found异常的，而达梦会。

解决方法是捕获no_data_found异常后做忽略处理。



# DBMS_SQL包问题

 DBMS_SQL有bug呀，获取出来的col_max_len是0，例子如下：

```sql
 create table mydual as
 select * from dual;

 declare
  v_col_cnt           NUMBER;
  v_cursorid          NUMBER;
  v_desc_t            DBMS_SQL.desc_tab2;
 begin
 	dbms_output.enable;
  	v_cursorid := DBMS_SQL.open_cursor;
 	DBMS_SQL.parse(v_cursorid, 'select ''123'' c1, DUMMY c2 from mydual', dbms_sql.native);
    DBMS_SQL.describe_columns(v_cursorid, v_col_cnt, v_desc_t);
    FOR i IN 1..v_col_cnt LOOP
		dbms_output.put_line('i ' || i || ' name = ' || v_desc_t(i).col_name || 
			' col_max_len = ' || v_desc_t(i).col_max_len);
	END LOOP;
 end;
```

 **DBMS_SQL这个包还有其它好多bug**，具体我没记下来，大家使用小心点了。



# prior和next问题

当下标值在容器中找不到时，达梦无法正确获取prior和next，验证的存储过程如下：

```sql
declare
    type v_mp_type is table of number index by PLS_INTEGER;
    v_mp v_mp_type;
begin
    dbms_output.enable;
	v_mp(1) := 1;
	v_mp(3) := 2;
	-- oracle输出1 达梦输出空
	dbms_output.put_line('v_mp.prior(2) = ' || v_mp.prior(2));
end;
```



解决方法是自己写prior和next函数：

```sql
-- 需要写函数代替oracle的prior和next
function get_prior_index(v_mp IN v_mp_type, v_ind IN PLS_INTEGER) return PLS_INTEGER
is 
    v_vv_last PLS_INTEGER := null;
	vv PLS_INTEGER := v_mp.first;
begin
	-- 遍历v_mp 做比较 
	while vv is not null
	loop
		-- 如果发现某个下标值比传进来的v_ind大或者相等 则返回上一个下标值
		-- (如果是第一个下标则返回NULL)
	    if (vv >= v_ind) then return v_vv_last; end if;
	    v_vv_last := vv;
		vv := v_mp.next(vv);
	end loop;
	

	-- 如果遍历完所有下标，仍未找到大于等于v_ind的值，则返回最大的下标v_mp.last
	return v_vv_last;

end;

function get_next_index(v_mp IN v_mp_type, v_ind IN PLS_INTEGER) return PLS_INTEGER
is 
	v_vv_last PLS_INTEGER := null;
	vv PLS_INTEGER := v_mp.last;
begin
	-- 反序遍历v_mp 做比较 
	while vv is not null
	loop
		-- 如果发现某个下标值小于等于v_ind 则返回上一个下标值
		--（如果是最大的下标则返回NULL）
		if (vv <= v_ind) then return v_vv_last; end if;
		v_vv_last := vv;
		vv := v_mp.prior(vv);
	end loop;
	

	-- 如果反序遍历完所有下标，仍未找到小于等于v_ind的值，则返回最小的下标v_mp.first
	return v_vv_last;

end;




```



# 日期计算问题

这个网上有很多文章介绍过了，达梦默认两个整数相除，结果类型还是整数，而oracle是小数。

所以在oracle我们可以使用trunc(v_date)-1/86400获取1秒前的时间，但在达梦，这样写跟trunc(v_date) - 0是一样的。

解决方法是改成trunc(v_date)-1.0/86400



# 出参问题

如果把一个变量传给一个函数做为函数出参，以获取函数返回值，oracle默认会把这个函数清空，而达梦不会。

这就导致一个问题，

验证代码如下：

```sql
/*测试出参  在oracle期待输出为空 但是达梦会出现error*/
create or replace procedure testKinstarerOutParam(str OUT varchar2) as
begin
    dbms_output.put_line('str = ' || str);
    if (str is not null) THEN
        RAISE_APPLICATION_ERROR(-20001, '出参没有清空');
    end if;
end;
/

create or replace procedure testKinstarerCallOutParam as
       strIn varchar2(64) := 'error';
begin
       testKinstarerOutParam(strIn);
end;
/

dbms_output.enable;
begin testKinstarerCallOutParam(); end;
```



# lob支持问题

oracle可以使用to_char函数对lob类型字段操作，但在达梦，有时这样操作会失败，报错为DBMS_LOB.READ line 1157 



# diutil包缺失

不知道为什么，达梦没有提供diutil包。里面有一些函数，挺方便，没有真可惜。所以我自己写了一个

```sql
CREATE OR REPLACE PACKAGE diutil IS


  -- bool_to_int:  translates 3-valued BOOLEAN TO NUMBER FOR USE
  --               IN sending BOOLEAN parameter / RETURN VALUES
  --               BETWEEN pls v1 (client) AND pls v2. since sqlnet
  --               has no BOOLEAN bind variable TYPE, we encode
  --               booleans AS false = 0, true = 1, NULL = NULL FOR
  --               network transfer AS NUMBER
  --
  FUNCTION bool_to_int( b BOOLEAN) RETURN NUMBER;
  
    -- int_to_bool:  translates 3-valued NUMBER encoding TO BOOLEAN FOR USE
  --               IN sending BOOLEAN parameter / RETURN VALUES
  --               BETWEEN pls v1 (client) AND pls v2. since sqlnet
  --               has no BOOLEAN bind variable TYPE, we encode
  --               booleans AS false = 0, true = 1, NULL = NULL FOR
  --               network transfer AS NUMBER
  --
  function int_to_bool( n NUMBER) return boolean;
  
  function get_sql_hash(name IN varchar2, v_hash OUT RAW,
                        pre10ihash OUT number)
    return number;

  function rpad_dm(string varchar2, padded_length number, pad_string varchar2 := ' ')
    return varchar2;
  
  function copy1kList(v_input ua_utl_def.t_str_1k_list) return ua_utl_def.t_str_1k_list;
end diutil;

CREATE OR REPLACE PACKAGE BODY diutil IS
  --------------------
  -- bool_to_int
  --------------------
  FUNCTION bool_to_int(b BOOLEAN) RETURN NUMBER IS
  BEGIN
    IF b THEN
      RETURN 1;
    ELSIF NOT b THEN
      RETURN 0;
    ELSE
      RETURN NULL;
    END IF;
  END bool_to_int;
  
    --------------------
  -- int_to_bool
  --------------------
  FUNCTION int_to_bool(n NUMBER) RETURN BOOLEAN IS
  BEGIN
    IF n IS NULL THEN
      RETURN NULL;
    ELSIF n = 1 THEN
      RETURN true;
    ELSIF n = 0 THEN
      RETURN false;
    ELSE
      RAISE value_error;
    END IF;
  END int_to_bool;
  
  function get_sql_hash(name IN varchar2, v_hash OUT RAW,
                        pre10ihash OUT number)
    return number IS
    v_hash_varchar2 VARCHAR2(128);
    v_hash_tmp VARCHAR2(128);
  BEGIN
    --  Compute a hash value for the given string using md5 algo
  --  Input arguments:
  --    name  - The string to be hashed.
  --    hash  - An optional field to store all 16 bytes of returned
  --            hash value.
  --    pre10ihash - An optional field to store the pre 10i database
  --                 version hash value.
  --  Returns:
  --    A hash value (last 4 bytes)  based on the input string.
  --    The md5 hash algorithm computes a 16 byte hash value, but
  --    we only return the last 4 bytes so that we can return an
  --    actual number.  One could use an optional RAW parameter to
  --    get all 16 bytes and to store the pre 10i hash value of 4
  --    4 bytes in the pre10ihash optional parameter.
  	-- Utl_Raw.Cast_To_Raw(
  	
  	v_hash_varchar2 := DBMS_OBFUSCATION_TOOLKIT.MD5(name);
  	v_hash := Utl_Raw.cast_to_raw(v_hash_varchar2);
  	v_hash_tmp := substrb(v_hash, 13, 4);
  	
  	pre10ihash := to_number(v_hash_tmp, 'XXXXXXXXXX');  --TODO: 这里实现有问题 pre10ihash是啥意思我没看懂
  	
  	-- select Utl_Raw.Cast_To_Raw(DBMS_OBFUSCATION_TOOLKIT.MD5(input_string =>'abc')) a from Dual
  	return to_number(v_hash_tmp, 'XXXXXXXXXX'); 
  END;
  
  function rpad_dm(string varchar2, padded_length number, pad_string varchar2 := ' ')
    return varchar2 IS
    v_len number := lengthb(string);
  BEGIN
  	    dbms_output.put_line('v_len - padded_length = ' );
  	if padded_length < v_len THEN
  		return substrb(string, 1, padded_length); --如果输入长度小于原字符串长度，则调用substrb截断
  	elsif padded_length = v_len THEN
  		return string; --如果长度相等直接返回原串即可
  	else
  		return string || rpad(' ', padded_length - v_len, pad_string); --如果长度大于原字符串，则在后面补空格
  	end if;
  END;


  function copy1kList(v_input ua_utl_def.t_str_1k_list) return ua_utl_def.t_str_1k_list IS
    v_tmplist ua_utl_def.t_str_1k_list;
    v_ind PLS_INTEGER;
  begin
  	if v_input.count > 0 then
  		/*
  		for vv in v_input.first .. v_input.last LOOP
  			v_tmplist(vv) := v_input(vv);
  		end loop;
  		*/
  		v_ind = v_input.first;
  		while v_ind is not null
  		loop
  			v_tmplist(v_ind) := v_input(v_ind);
  			v_ind = v_input.next(v_ind);
  		end loop;
  	end if;
  	return v_tmplist;
  end;
end diutil;
```



# 存储过程建失败不会提示

在达梦客户端执行新建存储过程时需要注意，即使创建成功了，也只代表语法正确。很可能存储过程有其它问题导致没建成功，仍是无效状态。

解决方法是创建存储过程之后再手动执行 alter PROCEDURE 存储过程名称 compile;



# FORMAT_ERROR_BACKTRACE没有调用处行号问题

众所周知，oracle提供一个函数dbms_utility.format_error_backtrace，用于获取异常模块处理时调用，获取函数堆栈信息，里面会有明确的函数名称和源码位置信息

但达梦调用这个函数返回的是一堆看不懂的内部符号

这个问题对我迁移造成不少困扰，因为我们业务的主要逻辑就是在存储过程里面实现的。我们需要在程序出异常时登记日志，记录函数堆栈信息，以方便跟踪。

经过我不懈研究，终于解决了达梦无法获取堆栈信息的问题，这里跟大家分享一下解决方法：

```sql

dbms_output.enable;
select * from  q$log order by 1 desc;
select * from q$error_instance order by 1 desc;

CREATE OR REPLACE PROCEDURE logIntoDb(loglevel PLS_INTEGER, inf IN varchar2, callStack IN varchar2)
IS
    PRAGMA AUTONOMOUS_TRANSACTION; --日志登记需要使用自治事务
BEGIN
	-- loglevel 0 debug 10 inf 20 err
	INSERT INTO q$log
          (id, "CONTEXT", text, call_stack, created_on, created_by, app_system, app_module)
        VALUES
          (q$log_seq.nextval,
           decode(logLevel, 0, 'debug', 'other'),
           inf,
           callStack,
           SYSDATE,
           USER,
           'unify_audit',
           'logIntoDb');
    commit;
END;
alter PROCEDURE logIntoDb compile;

CREATE OR REPLACE FUNCTION getErrorBackTrace() return varchar2
IS
	-- 达梦不能直接获取堆栈信息，需要套在函数里面 
	c_stack VARCHAR2(6000) := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
BEGIN
    return c_stack;
END;
/
alter FUNCTION getErrorBackTrace COMPILE;

CREATE OR REPLACE PROCEDURE debugHt(inf IN varchar2)
IS
	-- 默认不使用异常 这样不能记录行号
	-- 使用异常可以记录行号但性能会下降，用于调试
	v_useException boolean := true;
BEGIN
	if (v_useException) then
		-- 主动创建一个异常，这样才可以FORMAT_ERROR_BACKTRACE函数才有值
		RAISE_APPLICATION_ERROR(-20001, 'debug');
	else
		logIntoDb(0, inf, DBMS_UTILITY.format_call_stack);
	end if;
exception
  when others then
    -- 达梦的DBMS_UTILITY.FORMAT_ERROR_BACKTRACE函数必须隔位获取
    -- 不然只能获取当前函数的堆栈信息
	logIntoDb(0, inf, getErrorBackTrace());
END;
/
alter PROCEDURE debugHt COMPILE;


CREATE OR REPLACE PROCEDURE proc2
IS
BEGIN
    debugHt('hello log');
	execute immediate 'delete * from dual1233';
exception 
    when others then
    	debugHt('hello exp');
END;
/
alter PROCEDURE proc2 COMPILE;

CREATE OR REPLACE PROCEDURE proc3
IS
BEGIN
    proc2();
END;
/

CREATE OR REPLACE PROCEDURE proc4
IS
BEGIN
    proc3();
END;
/

begin proc4(); end;


```





这些坑比较隐蔽，花了我不少时间调试才发现，我把它们总结出来，希望能对你有所帮助。

