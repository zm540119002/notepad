# 箭头函数

## 参考

```
 https://www.liaoxuefeng.com/wiki/1022910821149312/1031549578462080
```

# 常用

# 常见错误

## TypeError: data.map is not a function

```
let nameList = data.map(item => item.name);
原因1：data不是数组
解决方法：将data转换为数组
	let data = Array.from(data);
```

