<?php
require_once dirname(__FILE__) . '/../pub_util/comm_util.php';
require_once dirname(__FILE__) . '/action_imp.php';

$action=getRequest("action");
$resultJSON = "";
switch($action) {
    case "get_column_algorithm" :
        echo getColumnAlgorithm();
        break;
    case "get_node_ds_list" :
        echo getNodeDSList();
        break;
    case "get_column_list" :
        echo getColumnList();
        break;
    case "get_column_detail_list" :
        echo getColumnDetailList();
        break;
    default :
        $notFoundErr = array();
        echo json_encode(array(array("__ERROR_MESSAGE__" => "错误，未实现此动作")));
}