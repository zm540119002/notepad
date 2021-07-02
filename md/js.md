# ES模块化

https://www.cnblogs.com/edward-life/p/13416833.html

https://www.cnblogs.com/vigourice/p/14905096.html

https://blog.csdn.net/weixin_30929195/article/details/96987890?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EOPENSEARCH%7Edefault-4.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EOPENSEARCH%7Edefault-4.control

```

```

# 箭头函数

https://www.liaoxuefeng.com/wiki/1022910821149312/1031549578462080

```
 
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

# 语法

## 继承

```
参考：	
	https://www.cnblogs.com/ranyonsue/p/11201730.html

既然要实现继承，那么首先我们得有一个父类，代码如下：

// 父类
function Person(name) { // 给构造函数添加了参数
  this.name = name;
  this.sum = function() {
    alert(this.name)
  }
}
Person.prototype.age = 10; // 给构造函数添加了原型属性

1、原型链继承
    // 原型链继承
    function Per() {
      this.name = "ker";
    }
    Per.prototype = new Person(); // 主要
    var per1 = new Per();
    console.log(per1.age); // 10
    // instanceof 判断元素是否在另一个元素的原型链上
    // per1 继承了Person的属性，返回true
    console.log(per1 instanceof Person); // true

    重点：让新实例的原型等于父类的实例 特点：

    实例可继承的属性有：实例的构造函数的属性，父类构造函数属性，父类原型的属性。（新实例不会继承父类实例的属性！） 缺点：
    新实例无法向父类构造函数传参
    继承单一
    所有新实例都会共享父类实例的属性（原型上的属性是共享的，一个实例修改了原型属性，另一个实例的原型属性也会被修改！）

2、借用构造函数继承
    核心：使用父类的构造函数来增强子类实例，等于是复制父类的实例属性给子类（没用到原型）

    funciton Con () {
      Person.call(this, "jer"); // 重点
      this.age = 12;
    }
    var con1 = new Con();
    console.log(con1.name); // "jer"
    console.log(con1.age); // "12"
    console.log(con1 instanceof Person); // false

    重点：用.call()和.apply()将父类构造函数引入子类函数（在子类函数中做了父类函数的自执行（复制）） 特点：
        只继承了父类构造函数的属性，没有继承父类原型的属性
        解决了原型链继承缺点1，2，3
        可以继承多个构造函数属性（call多个）
        在子实例中可向父实例传参 缺点：
        只能继承父类构造函数的属性
        无法实现构造函数的服用（每次用每次都要重新调用）
        每个新实例都有父类构造函数的副本，臃肿
        
3、组合继承（组合原型链继承和借用构造函数继承）（常用）
    // 组合原型链和构造函数继承
    function SubType (name) {
      Person.call(this, name); // 借用构造函数模式
    }
    SubType.prototype = new Person(); // 原型链继承
    var sub = new SubType("gar");
    console.log(sub.name); // "gar"继承了构造函数属性
    console.log(sub.age); // 10继承了父类原型的属性

    重点：结合了两种模式的优点，传参和复用 特点：
        可以继承父类原型上的属性，可以传参，可复用
        每个新实例引入的构造函数属性是私有的 缺点：调用了两次父类构造函数（耗内存），子类的构造函数会代替原型上的那个父类构造函数

4、原型式继承
    // 先封装一个函数容器，用来输出对象和承载继承的原型
    function content(obj) {
      function F() {}
      F.prototype = obj; // 继承了传入的参数
      return new F(); // 返回函数对象
    }
    var sup = new Person(); // 拿到父类的实例
    var sup1 = content(sup);
    console.log(sup1.age); // 10 继承了父类函数的属性

    重点：用一个函数包装一个对象，然后返回这个函数的调用，这个函数就变成了个可以随意增添属性的实例或对象。
    Object.create()就是这个原理 特点：类似于复制一个对象，用函数来包装 缺点：

    所有实例都会继承原型上的属性
    无法实现复用（新实例属性都是后面添加的）

5、寄生式继承
    function content(obj) {
      function F() {}
      F.prototype = obj; // 继承了传入的参数
      return new F(); // 返回函数对象
    }
    var sup = new Person();
    // 这个函数经过声明之后就成了可增添属性的对象
    console.log(typeof subobject); // function
    console.log(typeof sup2); // object
    console.log(sup2.name); // "gar"，返回了个sub对象，继承了sub属性
    重点：就是给原型式继承外面套了个壳子 特点：没有创建自定义类型，因为只是套了个壳子返回对象（这个），
    这个函数顺利成章就成了创建的新对象 缺点：没有到原型，无法复用

6、寄生组合式继承（常用）
    寄生：在函数内返回对象然后调用 组合：

    函数的原型等于另一个实例
    在函数中用apply或者calL引入另一个构造函数，可传参
    // 寄生
    function content(obj) {
      function F() {}
      F.prototype = obj;
      return new F();
    }
    // content就是F实例的另一个表示法
    var con = content(Person.prototype);
    // con实例（F实例）的原型继承了父类函数的原型
    // 上述更像是原型链继承，只不过只继承了原型属性

    // 组合
    function Sub() {
      Person.all(this); // 这个继承了父类构造函数的属性
    } // 解决了组合式两次调用构造函数属性的缺点
    // 重点
    Sub.prototype = con; // 继承了con实例
    con.constructor = Sub; // 一定要修复实例
    var sub1 = new Sub();
    // Sub的实例就继承了构造函数属性，父类实例，con的函数属性
    console.log(sub1.age); // 10;
    重点：修复了组合继承的问题

7、总结
    继承这些知识点与其说是对象的继承，更像是函数的功能用法，如何用函数做到复用，组合，这些和使用继承的思考是一样的，上述几个继承的方法都可以手动修复他们的缺点，但就是多了这个手动修复就变成了另一种继承模式。这些继承模式的学习重点是学它们的思想，不然你会在coding书本上的例子的时候，会觉得明明可以直接继承为什么还要搞这么麻烦。就像原型式继承它用函数复制了内部对象的一个副本，这样不仅可以继承内部对象的属性，还能把函数（对象，来源内部对象的返回）随意调用，给它们添加属性，改个参数就可以改变原型对象，而这些新增的属性也不会相互影响。
```

## 原型

```
参考：	
	https://www.jianshu.com/p/72156bc03ac1
	
```

```
参考：	
	https://blog.csdn.net/weixin_38654336/article/details/83050165

一、首先大家在对JS原型进行解释的时候，会涉及两个概念：构造函数、原型对象
    1.构造函数：通俗的一句话说，就是你在script标签里面声明的那个函数：
        <body>
        <script>
            function students() {
                /* 我就是构造函数 */
            }
        </script>
        </body>
    2.原型对象：在声明了一个函数之后，浏览器会自动按照一定的规则创建一个对象，这个对象就叫做-原型对象。这个原型对象其实是储存在了内存当中。

    3.在声明了一个函数后，这个构造函数（声明了的函数）中会有一个属性prototype，这个属性指向的就是这个构造函数（声明了的函数）对应的原型对象；
    原型对象中有一个属性constructor，这个属性指向的是这个构造函数（声明了的函数）。下面一张图可以很简单理解：
```



![img](https://img-blog.csdn.net/20181014202412732?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl8zODY1NDMzNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

```
二、使用构造函数创建对象
我们的构造函数使用new来创建对象的时候，就像下面这样：
<body>
<script>
    function students() {
        /* 我就是构造函数 */
    }
    var stu = new students();
</script>
</body>
此时，stu就是那个构造函数students创建出来的对象，这个stu对象中是没有prototype属性的，prototype属性只有在构造函数students中有，请看图！
可以看出，构造函数students中有prototype属性，指向的是students对应的原型对象；而stu是构造函数students创建出来的对象，他不存在prototype属性，所以在调用prototype的时候的结构是undefined，但stu有一个__proto__属性，stu调用这个属性可以直接访问到构造函数students的原型对象（也就是说，stu的__proto__属性指向的是构造函数的原型对象），请看图。
```

![img](https://img-blog.csdn.net/20181014210900962?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl8zODY1NDMzNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

```
说明（引用前面提到的文章的内容，因为很重要）：
    从上面的代码中可以看到，创建stu对象虽然使用的是students构造函数，但是对象创建出来之后，这个stu对象其实已经与students构造函数没有任何关系了，
    stu对象的__proto__属性指向的是students构造函数的原型对象。
    如果使用new students()创建多个对象stu1、stu2、stu3，则多个对象都会同时指向students构造函数的原型对象。
    我们可以手动给这个原型对象添加属性和方法，那么stu1,stu2,stu3…这些对象就会共享这些在原型中添加的属性和方法。
    如果我们访问stu中的一个属性name，如果在stu对象中找到，则直接返回。如果stu对象中没有找到，则直接去stu对象的__proto__属性指向的原型对象中查找，
    如果查找到则返回。(如果原型中也没有找到，则继续向上找原型的原型—原型链)。
    如果通过stu对象添加了一个属性name，则stu对象来说就屏蔽了原型中的属性name。 换句话说：在stu中就没有办法访问到原型的属性name了。
    通过stu对象只能读取原型中的属性name的值，而不能修改原型中的属性name的值。 stu.name = “李四”; 
    并不是修改了原型中的值，而是在stu对象中给添加了一个属性name。
    
三、与原型有关的几个方法
1. prototype属性
	prototype 存在于构造函数中 (其实任意函数中都有，只是不是构造函数的时候prototype我们不关注而已) ，他指向了这个构造函数的原型对象。

2.constructor属性
	constructor属性存在于原型对象中，他指向了构造函数

如下面代码：
    <script type="text/javascript">
        function students () {
        }
        alert(students.prototype.constructor === students); // true
    </script>
我们根据需要，可以students.prototype 属性指定新的对象，来作为students的原型对象。但是这个时候有个问题，新的对象的constructor属性则不再指向students构造函数了。

3.__proto__ 属性(注意：左右各是2个下划线)

​ 用构造方法创建一个新的对象之后，这个对象中默认会有一个属性__proto__, 这个属性就指向了构造方法的原型对象。
```

