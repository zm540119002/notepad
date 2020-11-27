# 箭头函数

## 参考

```
 https://www.liaoxuefeng.com/wiki/1022910821149312/1031549578462080
```

# 常用

## 遍历

```
// for
var arr = [1, 2, 3]
for(var i = 0; i < arr.length; i++) {
    //do something
};

// for...of...
for(var i of arr) {
    //do something
};

// for...in..
for(var i in arr) {
    //do something
};

// forEach()
arr.forEach((item, index, arr) => {
    //do something});
});

// map()
arr.map((value,index,array) => {
　　//do something
});
```



# 常见错误

## TypeError: data.map is not a function

```
let nameList = data.map(item => item.name);
原因1：data不是数组
解决方法：将data转换为数组
	let data = Array.from(data);
```

## Uncaught SyntaxError: Malformed arrow function parameter list