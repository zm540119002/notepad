/****************   页面交互JS   ********************
 * 
 */
include("/audit_config/js/comm_func.js", "/audit_config/custom_sql_popup/mine_action.js");
include("/audit_config/js/comm_func.js", "/audit_config/js/fix_thead.js");
include("/audit_config/js/comm_func.js", "/audit_config/js/controller.js");
include("/audit_config/js/comm_func.js", "/audit_config/ds_info/ds_info.js");
include("/audit_config/js/comm_func.js", "/audit_config/ds_info/column_algorithm.js");

// 初始化子句列表、数据源列表、数据字段算法列表
$(function() {
	$("#custom_sql_stmt_part_ul li").live("click", function() {
		var $ul_li = $("#custom_sql_stmt_part_ul li");
		var oldIndex = $ul_li.index($("#custom_sql_stmt_part_ul li").filter(".selected"));

		$(this).addClass("selected").siblings().removeClass("selected");
		var index = $ul_li.index(this);
		
		CustomSQLDo.customSQLParts[oldIndex].content = $("#custom_sql_input_textarea").val();
		$("#custom_sql_input_textarea").val(CustomSQLDo.customSQLParts[index].content);
		showHint(this);
	}).live("hover", function(event) {
		if (event.type == "mouseenter") {
			$(this).addClass("hover");
		} else {
			$(this).removeClass("hover");
		}
	});
	
	// AJAX取得数据源列表
	if (CustomSQLDo.options) {
		CustomSQLDo.getDSList(CustomSQLDo.options["serviceID"], CustomSQLDo.options["subServiceID"], CustomSQLDo.options["onlySSVC"]);
	}
});

// 字段列表动作
$(function() {	
	// 双击字段名显示字段算法列表
	$("#custom_sql_column_body input[name='name_en']").live("dblclick", function(event) {
		clearTimeout(CustomSQLDo.customSQLTimeout);
		$(this).addClass("selected").parent().find("input[name='name_en'").removeClass("selected");
		
		$("#custom_sql_algorithm_select").empty();
		var dbsType = $("#custom_sql_ds_body input[type='radio']").filter(":checked").attr("dbs_type");
		var alias = $("#custom_sql_ds_body input[type='radio']").filter(":checked").parent().siblings().find("input[name=alias]").val();
		clearHint(getActiveTabLi());
		// 绑定字段算法模块
		ColumnAlgorithm.show.call(this, dbsType, alias, $("#custom_sql_input_textarea").get(0));
		
		event.stopPropagation();
		//return false;
	});
	
	// 单击英文字段名，将字段名插入语句编辑框的光标处
	$("#custom_sql_column_body input[name='name_en']").live("click", function(event) {
		clearTimeout(CustomSQLDo.customSQLTimeout);	  // 防止双击事件触发单击
		var alias = $("#custom_sql_ds_body input[type='radio']").filter(":checked").parent().siblings().find("input[name=alias]").val();
		var columnName = (alias ? alias + "." : "") + $(this).val() + " ";
		var condWidget = columnName.match(/\$\{条件_/) ? true : false;	// 条件控件字段，表达式得用标志注释包起来
		if (CustomSQLDo.options["columnFormat"] == "${column}" && columnName.search(/^\s*\$\{[^}]+\}\s*$/) < 0) {
			columnName = "${" + $.trim(columnName) + "}";
		}

		if (condWidget) {
			columnName = "/*uc_rpt_cond_start*/ " + columnName + " /*uc_rpt_cond_end*/";
		}
		CustomSQLDo.customSQLTimeout = setTimeout(function() {
			ColumnAlgorithm.closeIt();
			clearHint(getActiveTabLi());
			insertText($("#custom_sql_input_textarea").get(0), columnName);
		}, 300); 
		event.stopPropagation();
	});
	
	$("#custom_sql_column").live("click", function() {
		ColumnAlgorithm.closeIt();
		return false;
	});
});

function getActiveTabLi() {
	var $ul_li = $("#custom_sql_stmt_part_ul li");
	for (var i=0; i<$ul_li.length; ++i) {
		if ($($ul_li[i]).hasClass("selected")) {
			return $ul_li[i];
		}
	}
}

function showHint(obj) {
	if ($("#custom_sql_input_textarea").val() == "") {
		var $ul_li = $("#custom_sql_stmt_part_ul li");
		var index = $ul_li.index(obj);		
		if (typeof(CustomSQLDo.customSQLParts[index]['hint']) != 'undefined') {
			$("#custom_sql_input_textarea").val(CustomSQLDo.customSQLParts[index]['hint']);
			$("#custom_sql_input_textarea").css("color", "#909090");
		}
	}
}

function clearHint(obj) {
	var $ul_li = $("#custom_sql_stmt_part_ul li");
	var index = $ul_li.index(obj);		
	if (typeof(CustomSQLDo.customSQLParts[index]['hint']) != 'undefined' && $("#custom_sql_input_textarea").val() == CustomSQLDo.customSQLParts[index]['hint']) {
		$("#custom_sql_input_textarea").val("");
		$("#custom_sql_input_textarea").css("color", "#000000");
	}
}

// 数据源列表交互动作
$(function() {
	$("#custom_sql_ds_body input[type=radio]").live("click", function() {
		CustomSQLDo.getColumnList($(this).attr("ds_id"));	
				
		$("#custom_sql_column_list").FixedHead({
			tableLayout: 'fixed',
			searchBind: '0',
			searchIndexes: '0,1'
		}, true);
		
		$(this).parent().parent().siblings().find("input[type='radio'][checked=true]").attr("checked", false);
		$(this).attr("checked", true);
	});
	
	$("#custom_sql_ds_body input[name='ds_name']").live("click", function() {
		var tbName = DSInfo.tableName($(this).attr('username'), $(this).attr('table_name'));
		var alias = $(this).parent().siblings().find("input[name='alias']").val();
		insertText($("#custom_sql_input_textarea").get(0), tbName + ' ' + alias);
	});
	
	$("#custom_sql_input_textarea").live("keyup blur", function() {
		showHint(getActiveTabLi());
	});
	
	$("#custom_sql_input_textarea").live("keydown click", function() {
		clearHint(getActiveTabLi());
	});
});