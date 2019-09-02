<?php
require_once dirname(__FILE__).'/../../pub_lib/oracle.php';
require_once dirname(__FILE__).'/../../pub_lib/pub_head.php';
require_once dirname(__FILE__).'/../../pub_lib/JSON/JSON.php' ;
require_once dirname(__FILE__).'/../../pub_lib/Util/XmlUtil.php';
require_once dirname(__FILE__).'/../../entity/entityDo/EntityDo.php';
require_once dirname(__FILE__).'/../pub_func.php';
require_once dirname(__FILE__) . '/../pub_util/comm_util.php';

/** 功能： 取得字段算法列表
 *
 */
function getColumnAlgorithm() {
    $sWhere_db_expr_n = array();
    $resultData = getDataTable("TB_UC_CFG_COLUMN_ALGORITHM",$sWhere_db_expr_n,"DBS_TYPE,DATA_TYPE,SEQU");
    
    $result = array();
    $result['ROWS'] = $resultData;
    
    return json_encode($result);
}

function getNodeDSList() {
    $serviceID = getRequest("service_id");
    $ssvcID = getRequest("sub_service_id");
    $onlySSVC = getRequest("only_ssvc");
    $total_rows = 0;
    
    $ssvcFilter = "a.sub_service_id = " . $ssvcID;
    /*if ($onlySSVC == "false") {	改为只取本稽核点的数据源
        $ssvcFilter = "a.sub_service_id in (
                        select sub_service_id from tb_ua_cfg_sub_service_type tc 
                        where tc.service_id = " . $serviceID . ")";
    }*/
    
    $sSql = " SELECT -1 quote_id, -1 ds_id, '系统内置变量' name, '' alias, '系统变量' explain, 'O' dbs_type, '' username, '' table_name
              FROM dual
              UNION ALL
              SELECT * FROM (
                  SELECT a.quote_id, b.ds_id, b.name, a.alias, b.explain, NVL(e.dbs_type, 'O') dbs_type, d.username, c.name table_name
                  FROM tb_uc_cfg_quote_ds a, tb_uc_cfg_ds b, tb_uc_cfg_ds_table c, tb_ua_sys_object d, tb_ua_sys_dbs e
                  WHERE a.ds_id = b.ds_id and b.ds_id = c.ds_id(+) and c.db_id = d.id(+) and d.object_id = e.id(+) and " 
                        . $ssvcFilter . 
                " ORDER BY (case when a.sub_service_id = " . $ssvcID . " THEN '0' ELSE '1' END) ASC, regexp_substr(a.alias, '[A-Za-z]+'), to_number(regexp_substr(a.alias, '\\d+')) 
               )";
    
    $sSql = encodeChar("utf-8","gbk",$sSql);
    $resultData = getEntityDo()->getItems1(-1,-1,$sSql,null,$total_rows,EntityKeyWord::$DBCommitType["_Commit_Auto_"]) ;
    
    $result = array();
    $result['ROWS'] = $resultData;
    
    return json_encode($result);
}

/**
 * 通过ds_id或quote_id取得数据源字段ID，ds_id参数未设置时，尝试通过quote_id
 * @return string
 */
function getColumnList() {
    $dsID = getRequest("ds_id");
    $quoteID = getRequest("quote_id");
    $total_rows = 0;
    
    if ((!isset($dsID) || $dsID == "") && $quoteID > 0) {
    	$dsID = "(SELECT ds_id FROM tb_uc_cfg_quote_ds WHERE quote_id = " . $quoteID . ")";
    }

    $sSql = " SELECT a.column_id, a.name, a.name_cn, a.data_type, a.explain, a.property
              FROM tb_uc_cfg_ds_column a
              WHERE a.ds_id = " . $dsID . " and class='U' ORDER BY sequ";
    if ($dsID == -1) {
        $sSql = " SELECT inner_var_id column_id, a.disp_name name, substr(a.memo, 1, instr(a.memo, '：')-1) name_cn, 
                        'VARCHAR2' data_type, substr(a.memo, instr(a.memo, '：')+1) explain, '' property
                  FROM tb_ua_cfg_var a
                  ORDER BY sequ";
    }
    
    $sSql = encodeChar("utf-8","gbk",$sSql);
    $resultData = getEntityDo()->getItems1(-1,-1,$sSql,null,$total_rows,EntityKeyWord::$DBCommitType["_Commit_Auto_"]) ;
    
    $result = array();
    $result['ROWS'] = $resultData;
    if (getRequest("jasperDataID")) {
        $result['jasperDataID'] = getRequest("jasperDataID");
    }
    
    return json_encode($result);
}

function getColumnDetailList() {
    $dsID = getRequest("ds_id");
    $total_rows = 0;

    $sSql = " SELECT a.column_id, a.name, a.name_cn, a.data_type, a.explain, 
                a.std_column_id, a.property, a.fmt_desc, a.unit, a.data_length || ',' || a.data_precision data_length, a.status
              FROM tb_uc_cfg_ds_column a
              WHERE a.ds_id = " . $dsID . " and class='U' ORDER BY sequ";
    if ($dsID == -1) {
        $sSql = " SELECT inner_var_id column_id, a.disp_name name, substr(a.memo, 1, instr(a.memo, '：')-1) name_cn, 
                        'VARCHAR2' data_type, substr(a.memo, instr(a.memo, '：')+1) explain
                  FROM tb_ua_cfg_var a
                  ORDER BY sequ";
    }
    
    $sSql = encodeChar("utf-8","gbk",$sSql);
    $resultData = getEntityDo()->getItems1(-1,-1,$sSql,null,$total_rows,EntityKeyWord::$DBCommitType["_Commit_Auto_"]) ;
    
    $result = array();
    $result['ROWS'] = $resultData;
    
    return json_encode($result);
}