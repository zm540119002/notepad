/** 字段算法模块，触发事件的对象必须有data_type属性（字段类型）
 *  应该包含在顶层DIV内（左边不能有别的控件），否则定位会出错
 */

include("/audit_config/js/comm_func.js", "/audit_config/js/controller.js");
function ColumnAlgorithm() {
	
}

ColumnAlgorithm.columnAlgorithm = [];
ColumnAlgorithm.options = [];

/**
 * 用于绑定到字段名称的双击处理函数，调用方式为：ColumnAlgorithm.show.call(this, dbsType, alias, textArea)，其中this为字段名称对象
 * @param dbsType：数据库类型
 * @param alias：数据源别名
 * @param textArea：要插入表达式的textArea对象，可如下传参：$("#custom_sql_input_textarea").get(0)
 * @returns 传入的this参数
 */
ColumnAlgorithm.show = function(dbsType, alias, textArea) {
	if (ColumnAlgorithm.columnAlgorithm.length > 0) {
		$("#custom_sql_algorithm_select").empty();
		var msg = clone(ColumnAlgorithm.columnAlgorithm);
		
		var dataType = $(this).attr('data_type');
		var caHtml = "";
		for (var i = 0; i < msg.length; i++) {
			if (msg[i]['DATA_TYPE'] != dataType || dbsType != msg[i]['DBS_TYPE']) {
				continue;
			}
			var line =
				"<option " +
					"class='" + msg[i]['DBS_TYPE'] + msg[i]['DATA_TYPE'] + "' " +
					"title='" + msg[i]['REMARK'] + "' " +
					"value='" + htmlEncode(msg[i]['EXPR']) + "' " +
				">" + msg[i]['NAME'] + "</option>";
			caHtml = caHtml + line;
		}
		if (caHtml == "") {
			return false;
		}
		$("#custom_sql_algorithm_select").append(caHtml);
		$("#custom_sql_algorithm_select").data("column_name", (alias ? alias + "." : "") + $(this).val());
		var parentLeft = $("#custom_sql_algorithm").parent().offset().left;
		var parentTop = $("#custom_sql_algorithm").parent().offset().top;
		var left = parseInt($(this).offset().left) + parseInt($(this).width()); // - parseInt(parentLeft) - 10;
		var top = parseInt($(this).offset().top) + parseInt($(this).height()); // - parseInt(parentTop) + 30;
		$("#custom_sql_algorithm").css({"position": "absolute", "left": left, "top": top, "width": "150px", display: "block"}).show();
	} else {
		ColumnAlgorithm.getColumnAlgorithm();
		return;
	}
	
	// 单击字段算法选项，将算法表达式插入语句编辑框的光标处
	$("#custom_sql_algorithm_select >option").die("click");
	$("#custom_sql_algorithm_select >option").live("click", function() {
		var columnName = $("#custom_sql_algorithm_select").data("column_name");
		var condWidget = columnName.match(/\$\{条件_/) ? true : false;	// 条件控件字段，表达式得用标志注释包起来
		if (ColumnAlgorithm.options["columnFormat"] == "${column}") {
			columnName = "${" + columnName + "}";
		}

		var expr = $(this).attr("value").replace(/\$\{column\}/i, columnName);
		if (condWidget) {
			expr = "/*uc_rpt_cond_start*/ " + expr + " /*uc_rpt_cond_end*/";
		}
		insertText(textArea, htmlDecode(expr) + " ", "...");		// 插入后，选中“插入内容”中的...

		$("#custom_sql_algorithm").hide();
		textArea.focus();
	});
	
	return(this);
};

ColumnAlgorithm.closeIt = function() {
	$("#custom_sql_algorithm").hide();
};

ColumnAlgorithm.getColumnAlgorithm = function() {
	controller.request.call($('#custom_sql_algorithm'), 'column_algorithm', {});
};

$(function() {	
	if ($("div").find("#custom_sql_algorithm").length == 0) {
		$("body").append('<div id="custom_sql_algorithm" style="position: absolute; z-index: 2050; display: none;">' +
							'<select id="custom_sql_algorithm_select" multiple="multiple" size="8">' +
	    					'</select>' +
	    				 '</div>');
	}	
	controller.addRequest('column_algorithm', '#custom_sql_algorithm', function(gmsg) {
		if (gmsg != null) {
			var msg = gmsg['ROWS'];
			if (msg != null) {
				ColumnAlgorithm.columnAlgorithm = clone(msg);
			}
		}
	}, true)

	ColumnAlgorithm.getColumnAlgorithm();
});