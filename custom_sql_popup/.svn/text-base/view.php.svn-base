<?php 
/** 功能：自定义语句输入模块，作为弹出窗口使用，父页面通过include_once包含
 *       默认为查询语句，分为SELECT、FROM、WHERE、GROUP BY、HAVING、ORDER BY六部分子句
 *       可通过设置$("#custom_sql_main").data("customSQLParts")，指定要输入的语句TAB页及内容，如：
 *          $("#custom_sql_main").data("customSQLParts", [ {column: "UPDATE_STMT", name:"UPDATE子句", content:"UPDATE TB_TEST SET A = 'hahaha'", hint:"UPDATE子句，如：UPDATE tb_test SET col1='${now}''"}, 
 *                                                         {column: "WHERE_STMT", name:"WHERE子句", content:"WHERE col_a = '123'"} ]);
 *       另外应设置$("#custom_sql_main").data("options")对象，用于控制展示：
 *          必须项目有subServviceID、serviceID
 *          可选项目：onlySSVC：指定是否只列出稽核点的数据源，为FALSE则列出专题的数据源
 *                columnFormat：字段格式，两种选择之一：column、${column}
 *                enOrCn：允许输入英文/中文字段，三种选择：en、cn、en+cn，默认为en
 *                returnAttach：返回的数据附加到哪个jquery元素上，关闭对话框时，若设置了此元素，则回填到此元素的data上：returnAttach.data("customSQLParts", ...);
 *                returnDirectly：对话框关闭时，编辑后结果数据设为哪个DOM对象的值
 *                addtionalDS：额外附加的数据源（ds_id取值为-1000至-100），如下格式：
 *                  [{name: "数据源名称", ds_id: "数据源ID", columns: [{name: 字段英文名称, name_cn: 字段中文名称, explain: 字段备注},....]}
 *                   ,....
 *                  ]
 *                onlyAdditionalDS：true/false，是否只使用附加的数据源
 *                quoteInvalidList：无效的数据引用，数组，下标为quote_id，内容为无效原因说明，在此数组内的quote_id不可选择，radio失效，并将说明作为hint提示
 *       编辑完成的表达式，仍然保存在$("#custom_sql_main").data("customSQLParts")中
 *   
<script type="text/javascript" src="<?php echo includeFile($basePath . "/../js/ds_info.js"); ?>" ></script>   
    
    <?php require_once dirname(__FILE__) . "/../column_algorithm/view.php"; ?> 
<script type="text/javascript" src="<?php echo includeFile($basePath . "/mine.js"); ?>" ></script>
<script type="text/javascript" src="<?php echo includeFile($basePath . "/../js/comm_func.js"); ?>" ></script>
<script type="text/javascript" src="<?php echo includeFile($basePath . "/../js/fix_thead.js"); ?>" ></script>
<script type="text/javascript" src="<?php echo includeFile($basePath . "/../js/controller.js"); ?>" ></script>
<script type="text/javascript" src="<?php echo includeFile($basePath . "/../ds_info/ds_info.js"); ?>" ></script>  
<script type="text/javascript" src="<?php echo includeFile($basePath . "/mine_action.js"); ?>" ></script>
 */

$basePath = dirname(__FILE__);
require_once $basePath . "/../pub_util/comm_util.php";
?>

<link type="text/css" href="<?php echo includeFile($basePath . "/mine.css"); ?>" rel="stylesheet" />

<div id="custom_sql_main" class="hidden">
    <div id="custom_sql_upper">
        <div id="custom_sql_ds">
			<div class="textList">
                <table cellspacing="0" cellpadding="0" border="0" id="custom_sql_ds_list">
                    <thead class="datagrid-header">
        				<tr>
        					<th style="text-align: center; width: 35px">选择</th>
        					<th style="text-align: center;">数据名称</th>
        					<th style="text-align: center; width: 30px">别名</th>
        					<th style="text-align: center;">说明</th>
        				</tr>
                    </thead>
                    <tbody id="custom_sql_ds_body" class="tbody"></tbody>
                </table>
            </div>
        </div>
        
        <div id="custom_sql_column" class="fix_div">
			<div class="textList">
                <table cellspacing="0" cellpadding="0" border="0" id="custom_sql_column_list" data_ready="">
                    <thead class="datagrid-header">
        				<tr>
        					<th class="pointer" style="text-align: center;" title="单击将字段名称加入表达式，双击选择字段算法">字段名称</th>
        					<th class="pointer" style="text-align: center;">中文名称</th>
        					<th class="pointer" style="text-align: center;">字段说明</th>
        				</tr>
                    </thead>
                    <tbody id="custom_sql_column_body" class="tbody"></tbody>
                </table>
            </div>
        </div>
        <div class="container_clear"></div>
    </div>
    
    <div id="custom_sql_input" class="text_area_input cs_container">
        <ul id="custom_sql_stmt_part_ul" class="ul_tab_menu">
        </ul>
        <textarea id="custom_sql_input_textarea" class="sql_input"></textarea>
    </div>
    
</div>