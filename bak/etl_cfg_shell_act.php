<?php
/**
 * Created by PhpStorm.
 * User: zhangmin
 * Date: 2019/11/12
 * Time: 15:38
 */
include_once("../audit_config/pub_func.php");
include_once("../pub_lib/pub_head.php");
include_once("../pub_lib/db_cfg.php");
include_once("../pub_lib/JSON/JSON.php");
include_once("../pub_lib/common.php");
session_start();
if(!isset($_SESSION['ses_opt_id']) && ($_SESSION['ses_opt_id'] == "")){
    header("Location: ../login.php");
    exit;
}
if(!$conn=dblogin("UA_DBG_44")){
    printf("connect database  failed!");
    exit;
}
?>
<?php
if($_REQUEST['act']=="save"){
    $responce->sqls = [];

    if(!isset($_POST['algorithm_task_id']) || !is_numeric($_POST['algorithm_task_id'])) {//新增
        $id = getSeqId("uc_public.f_get_cfg_id()","F");

        $insert_algorithm_task=array();
        $_POST['algorithm_task_id'] = $insert_algorithm_task['algorithm_task_id'] = $id;
        $insert_algorithm_task['algorithm_task_name'] = "'".charProc($_POST['algorithm_task_name'])."'";
        $insert_algorithm_task['classify'] = "'".charProc($_POST['classify'])."'";
        $insert_algorithm_task['ds_id'] = "'".charProc($_POST['ds_id'])."'";
        $insert_algorithm_task['sub_service_id'] = "'".charProc($_POST['sub_service_id'])."'";
        $insert_algorithm_task['indb_time'] = "sysdate";
        $insert_algorithm_task['indb_staff'] = "'".$_SESSION['ses_opt_id']."'";
        $responce->sqls[] = format_insert_sql($insert_algorithm_task,'tb_uc_cfg_algorithm_task');

        foreach ($_POST['in_param'] as $key=>$value) {
            $insert_param=array();
            $insert_param['algorithm_task_id'] = $id;
            foreach ($value as $k=>$v){
                $insert_param[$k] = "'".charProc($v)."'";
            }
            $responce->sqls[] = format_insert_sql($insert_param,$key);
        }
    }else{
        $update_algorithm_task=array();
        $update_algorithm_task_W = array();
        $update_algorithm_task_W['algorithm_task_id'] = $_POST['algorithm_task_id'];
        $update_algorithm_task['algorithm_task_name'] = "'".charProc($_POST['algorithm_task_name'])."'";
        $update_algorithm_task['classify'] = "'".charProc($_POST['classify'])."'";
        $update_algorithm_task['ds_id'] = "'".charProc($_POST['ds_id'])."'";
        $update_algorithm_task['sub_service_id'] = "'".charProc($_POST['sub_service_id'])."'";
        $update_algorithm_task['indb_time'] = "sysdate";
        $update_algorithm_task['indb_staff'] = "'".$_SESSION['ses_opt_id']."'";
        $responce->sqls[] = format_update_sql($update_algorithm_task,$update_algorithm_task_W,'tb_uc_cfg_algorithm_task');

        foreach ($_POST['in_param'] as $key=>$value) {
            $update_param=array();
            $update_param_W = array();
            $update_param_W['algorithm_task_id'] = $_POST['algorithm_task_id'];
            foreach ($value as $k=>$v){
                $update_param[$k] = "'".charProc($v)."'";
            }
            $responce->sqls[] = format_update_sql($update_param,$update_param_W,$key);
        }
    }

    $oEntityDo->beginDBTrans();//开启事务
    foreach ($responce->sqls as $sql) {
        $sql = encodeChar("utf-8","gbk",$sql);
        $ret=$oEntityDo->ExcuteSQL($sql,$oDBSession,EntityKeyWord::$DBCommitType["_Commit_No_Auto_"]) ;
        if($ret<0){
            $oEntityDo->rollbackDBTrans();//回滚
            $info="保存失败！\r\n数据库返回：".$oDBSession->Error['message'];
            errorResponse($responce,$info);
        }
    }
    $oEntityDo->commitDBTrans();//提交事务

    $responce->postData = $_POST;
    successResponse($responce,'保存成功');
}else if($_REQUEST['act']=='getData'){
    $responce->sqls = [];

    $sql = "select algorithm_task_id,algorithm_task_name,classify,ds_id,sub_service_id 
              from ua_dbg.tb_uc_cfg_algorithm_task 
             where algorithm_task_id=" . $_POST['node_id'];
    $responce->sqls[] = $sql;
    $algorithmTask = execute_type_sql($sql);
    $responce->algorithmTask = array_change_key_case($algorithmTask[0],CASE_LOWER);

    $param_table = '';
    switch (trim($responce->algorithmTask['classify'])) {
        case 1:
            $param_table = 'exponent_smooth_param';
            break;
        case 2:
            $param_table = 'holt_winter_param';
            break;
        case 3:
            $param_table = 'arima_param';
            break;
        case 4:
            $param_table = 'rnn_param';
            break;
        case 5:
            $param_table = 'lstm_param';
            break;
    }
    if ($param_table) {
        $sql = "select * from " . $param_table . " where algorithm_task_id=" . $_POST['node_id'];
        $responce->sqls[] = $sql;
        $param = execute_type_sql($sql);
        $param = array_change_key_case($param[0],CASE_LOWER);
        $responce->param->$param_table = $param;
    }

    successResponse($responce,'保存成功');
}else if($_REQUEST['act']==''){

}else if($_REQUEST['act']==''){

}else if($_REQUEST['act']==''){
}
