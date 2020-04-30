=====================================================================================

=====================================================================================
-------------------------------------------------------npm
查询npm的版本——npm -v
安装最新版本——npm i npm -g
-------------------------------------------------------webpack
查看webpack版本——webpack -v
安装webpack（全局安装）——npm install webpack -g
npm install webpack-cli -g
-------------------------------------------------------安装vue.js
查看vue.js 的版本——vue -V   （注意后面的V是大写的，需要安装完cue-cli脚手架之后才能查看的到）
-------------------------------------------------------安装package.json中的插件
进入项目文件夹里（有package.json的文件夹），然后输入命令
npm install
-------------------------------------------------------安装vue
# 最新稳定版本
$ npm install vue -g
# 最新稳定 CSP 兼容版本
$ npm install vue@csp -g
默认安装路径：
C:\Users\Administrator\AppData\Roaming\npm
-------------------------------------------------------安装vue-cli
	npm install vue-cli -g  	--全局安装vue-cli2.0
	vue init webpack demo		--初始化项目
	cd demo
	npm install
	npm run dev
-------------------------------------------------------
	npm install @vue/cli -g		--全局安装vue-cli3.0
	vue create demo
	cd demo
	vue run serve
-------------------------------------------------------卸载vue-cli
npm uninstall vue-cli -g
-------------------------------------------------------打包
npm run build
-------------------------------------------------------
npm i @antv/g6-editor --save 
=====================================================================================vue create提示符不工作
如果你在 Windows 上通过 minTTY 使用 Git Bash，交互提示符并不工作。你必须通过 winpty vue.cmd create hello-world 启动这个命令
不过，如果你仍想使用 vue create hello-world，则可以通过在 ~/.bashrc 文件中添加以下行来为命令添加别名。 alias vue='winpty vue.cmd' 你需要重新启动 Git Bash 终端会话以使更新后的 bashrc 文件生效
其中 .bashrc文件是位于git/etc文件夹下的  bash.bashrc  文件。在文件的最后一行写入
alias vue='winpty vue.cmd'
并重启Git Bash更改即可生效。
bash.bashrc默认路径： C:\Program Files\Git\etc
=====================================================================================Vue __ob__: Observer
__ob__: Observer这些数据是vue这个框架对数据设置的监控器，一般都是不可枚举的。

网上有很多解决的方案：

第一种：__ob__: Observer 是 Vue 对数据监控添加的属性，如果想去掉可以用赋值的方式。例如Object.assign({},this.owner)。 用这种方式也是可以解决。

第二种：假设list里面存放的就是那些带有__ob__: Observer的可以用JSON.parse(JSON.stringify(this.list))
=====================================================================================
axios.post(isurl,Qs.stringify(o),{'
    header:{
        'Content-Type': 'multipart/form-data'
    }
})
=====================================================================================
const _this = this;
const url = 'data_clean.php';
axios.defaults.timeout = 20000;
axios.defaults.headers.post['Content-Type'] = 'multipart/form-data';
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8';
axios.post(url,Qs.stringify(_this.postData)).
then(function (response) {
	if(response.data.rows && response.data.rows.length){
		_this.total = Number(response.data.total);
		_this.tableData = response.data.rows;
	}else{
		_this.$message({
			showClose: true,
			message: response.data.retMsg,
			duration: 3000,
			type: 'error',
			center: true
		});
	}
}).catch(function (error) {
	console.log(error);
});
--------------------------------------------------------------------
const _this = this;
const url = 'http://172.16.7.71:8182/api/rest/getRuleList';
_this.postData = {
	"status":0,
	"pageSize":_this.pageSize,
	"pageIndex":_this.currentPage
};
axios.defaults.timeout = 20000;
axios.post(url,JSON.stringify(_this.postData)).
then(function (response) {
	// console.log(response);
	if(response.data.retCode==0){
		_this.total = Number(response.data.pageNum);
		_this.tableData = response.data.data;
	}else{
		_this.$message({
			showClose: true,
			message: response.data.retMsg,
			duration: 3000,
			type: 'error',
			center: true
		});
	}
}).catch(function (error) {
	console.log(error);
});

const url = 'action.php?act=dataQualityEvolve&sub_sys_type=1&data_date=20191013';
const url = 'action.php?act=dataQualityEvolve&sub_sys_type=4';
const url = 'action.php?act=dataMapWithArea&data_date=20191106&sub_sys_type=2&problem_type=2';
axios.defaults.timeout = 20000;
axios.get(url).
then(function (response) {
	console.log(response);
}).catch(function (error) {
	console.log(error);
});
--------------------------------------------------------------------
const url = 'http://172.16.7.71:8182/api/rest/file/upload';
let fd = new FormData();
fd.append('uploadfile',file,file.name);
axios.post([url],fd,{
	// 加这里
	headers: {
	}
}).then(function (response) {
	if(response.data.retCode==0){
		_this.$message({
			message: '成功',
			type: 'success'
		});
	}else{
		_this.$message({
			showClose: true,
			message: response.data.retMsg,
			duration: 3000,
			type: 'error',
			center: true
		});
	}
}).catch(function (error) {
	console.log(error);
});
return false; //返回false不会自动上传
=====================================================================================
//监听-回显-事件
bus.$on('setTransfer', function(param){
	console.log(param);
});
//触发-回显-事件
bus.$emit('setTransfer',_this.fieldValue);
//监听-获取穿梭框值-事件
// bus.$on('get_transfer', function(param){
//     console.log(param);
// });
//触发-获取穿梭框值-事件
// bus.$emit('get_transfer',_this.fieldValue);
=====================================================================================
<el-input v-focus></el-input>
directives: {
  // 注册一个局部的自定义指令 v-focus
  focus: {
    // 指令的定义
    inserted: function (el) {
      // 聚焦元素
      el.querySelector('input').focus()
    }
  }
},
directives: {
	focus: {
		inserted: function (el, {value}) {
			if (value) {
				$(el).find("input").focus();//聚焦输入框
			}
		}
	}
},
//自定义指令
Vue.directive('focus', {
	inserted: function(el, binding) {
		//console.log(el)
		el.focus()
	}
})
=====================================================================================
[{…}]
0:
chapter_id: "1734292"
chapter_title: "1"
chapter_title_disabled: "true"
paragraph_list: Array(1)
0:
paragraph_id: "1734293"
paragraph_title: "11"
paragraph_title_disabled: "true"
paragraph_type: "TEXT"

_this.postData.chapter_list = _this.postData.chapter_list(chapter => {
	chapter = chapter.paragraph_list(paragraph => {
		return !!paragraph.paragraph_title_disabled;
	});
	return !!chapter.chapter_title_disabled;
});

console.log(_this.postData.chapter_list);
_this.postData.chapter_list = _this.postData.chapter_list(chapter => {
	chapter = chapter.paragraph_list(paragraph => {
		return !!paragraph.paragraph_title_disabled;
	});
	return !!chapter.chapter_title_disabled;
});
console.log(_this.postData.chapter_list);
=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================

=====================================================================================