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

## 正则验证

```
//首先过滤特殊字符
let pattern = /^.*(['|\"|\/|<|>|\\|&|%|+]).*$/ ;
if (pattern.test(sPW)) {
    alert("出于安全考虑，密码不能有这些: ' , \" ,\/, < , > , \\ ,& , % , +,\| 特殊字符！") ;
    return false ;
}

// 密码必须为数字+字母+符号（不包含：' , " , < , > , \ ,$ , % , + 特殊字符） ！
// var patrn = /(?=.*[\d]+)(?=.*[a-zA-Z]+)(?=.*[^a-zA-Z0-9]+).{8,20}/ ;
// 密码必须包含数字和字母，且不能小于8位
// var pattern = /^(?=.*?[0-9])(?=.*?[a-z])[0-9a-z_]{8,}$/ ;
// 密码必须同时含有字母，数字，字符，且不小于8位
pattern = /^(?![^a-zA-Z]+$)(?!\D+$)(?![a-zA-Z0-9]+$).{8,}$/ ;
if (!pattern.test(sPW)) {
    alert("密码必须同时含有字母，数字，字符，且不小于8位！") ;
    return false ;
}


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