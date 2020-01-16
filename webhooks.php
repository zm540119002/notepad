<?php
/**Author		:	ZhangMin
 * Date 		: 	2019-11-18
 * Description 	:	gitlab自动部署
 * Version      : 	1.0
 ************************************************************************************************/
//网站目录
$webRootPath='/usr/local/apache2/htdocs/inc_chk/';

//打开网站目录下的hooks.log文件,需要在服务器上创建,并给写权限
$logFile = fopen($webRootPath.'hooks.log', 'a');

fwrite($logFile, '================ Update Start ==============='.PHP_EOL.PHP_EOL);

//自定义字串掩码 用于验证
$access_token = 'QhNO8YHqym5PHQQsexapF7041xOhzm62DRZ';

//接受的ip数组，也就是允许哪些IP访问这个文件 这里是gitlab服务器IP
$access_ip = array('172.16.7.54');

//如果使用www.xxx.com/xxx.php?token=xxxxxxx 的方式来传送验证字符串，则用这个方法获取
# $client_token = $_GET['token'];

// 获取请求端的secret token
$client_token = $_SERVER["HTTP_X_GITLAB_TOKEN"];

//获取请求端的IP
$client_ip = $_SERVER['REMOTE_ADDR'];

//把请求的IP和时间写进log
fwrite($logFile, 'Request on ['.date("Y-m-d H:i:s").'] from ['.$client_ip.']'.PHP_EOL);

//验证token 有错就写进日志并退出
if ($client_token !== $access_token) {
    echo "error 403";
    fwrite($logFile, "Invalid token [{$client_token}]".PHP_EOL);
    exit(0);
}

//验证ip
if ( !in_array($client_ip, $access_ip)) {
    echo "error 503";
    fwrite($logFile, "Invalid ip [{$client_ip}]".PHP_EOL);
    exit(0);
}

//获取请求端发送来的信息，具体格式参见gitlab的文档
$json = file_get_contents('php://input');
$data = json_decode($json, true);

//如果有需要 可以打开下面，把传送过来的信息写进log
# fwrite($logFile, 'Data: '.print_r($data, true).PHP_EOL);

//执行shell命令并把返回信息写进日志
$output=shell_exec("cd $webRootPath && git pull 2>&1");
fwrite($logFile, 'Info:'. $output.PHP_EOL);

fwrite($logFile,PHP_EOL. '================ Update End ==============='.PHP_EOL.PHP_EOL);

$logFile and fclose($logFile);

?>
