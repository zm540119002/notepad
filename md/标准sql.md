

# 连接

![img](https://www.pianshen.com/images/877/9ddfe4ee7e238bddc3f84ac58c9d7525.JPEG)

# 语法

## case when

```
Case具有两种格式。简单Case函数和Case搜索函数。

第一种 格式 : 简单Case函数 :
格式说明    
　　　　case 列名
　　　　when   条件值1   then  选择项1
　　　　when   条件值2    then  选项2.......
　　　　else     默认值      end
eg:
　　　　select
　　　　case 　　job_level
　　　　when     '1'     then    '1111'
　　　　when　  '2'     then    '1111'
　　　　when　  '3'     then    '1111'
　　　　else       'eee' end
　　　　from     dbo.employee

第二种  格式 :Case搜索函数
格式说明   
　　　　case  
　　　　when  列名= 条件值1   then  选择项1
　　　　when  列名=条件值2    then  选项2.......
　　　　else    默认值 end
eg:
　　　　update  employee
　　　　set         e_wage =
　　　　case
　　　　when   job_level = '1'    then e_wage*1.97
　　　　when   job_level = '2'   then e_wage*1.07
　　　　when   job_level = '3'   then e_wage*1.06
　　　　else     e_wage*1.05
　　　　end

提示:通常我们在写Case When的语句的时候,会容易忘记 end 这个结束,一定要记得哟!
比较: 两种格式，可以实现相同的功能。
  　　简单Case函数的写法相对比较简洁，但是和Case搜索函数相比，功能方面会有些限制，比如写判断式。还有一个需要注意的问题，Case函数只返回第一个符合条件的     值，剩下的Case部分将会被自动忽略。
```

## SQL中on条件与where条件的区别

```
参考：
	https://www.cnblogs.com/Dreamice/p/9523533.html
	
on、where、having的区别
on、where、having这三个都可以加条件的子句 中，on是最先执行，where次之，having最后。有时候如果这先后顺序不影响中间结果的话，那最终结果是相同的。但因为on是先把不符合条件的记 录过滤后才进行统计，它就可以减少中间运算要处理的数据，按理说应该速度是最快的。   
    
   根据上面的分析，可以知道where也应该比having快点的，因为它过滤数据后才进行sum，所以having是最慢的。但也不是说having没用，因为有时在步骤3还没出来都不知道那个记录才符合要求时，就要用having了。   
    
   在两个表联接时才用on的，所以在一个表的时候，就剩下where跟having比较了。在这单表查询统计的情况下，如果要过滤的条件没有涉及到要计算字 段，那它们的结果是一样的，只是where可以使用rushmore技术，而having就不能，在速度上后者要慢。   
    
   如果要涉及到计算的字段，就表示在没计算之前，这个字段的值是不确定的，根据上篇写的工作流程，where的作用时间是在计算之前就完成的，而having就是在计算后才起作用的，所以在这种情况下，两者的结果会不同。   
    
   在多表联接查询时，on比where更早起作用。系统首先根据各个表之间的联接条件，把多个表合成一个临时表后，再由where进行过滤，然后再计算，计 算完后再由having进行过滤。由此可见，要想过滤条件起到正确的作用，首先要明白这个条件应该在什么时候起作用，然后再决定放在那里
```

