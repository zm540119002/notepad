/**   事件处理类
 * 
 */

//include('/audit_config/custom_sql_popup/mine_action.js', '/audit_config/js/controller.js');
//include('/audit_config/custom_sql_popup/mine_action.js', '/audit_config/ds_info/ds_info.js');

function CustomSQLDo() {
}

CustomSQLDo.customSQLParts = [];
CustomSQLDo.options = null;
CustomSQLDo.customSQLTimeout = null;

$(function() {
	controller.addRequest('node_ds_list', '#custom_sql_ds_body', function(gmsg) {
		function additionalAdded(dsID) {
			for (var ii = 0, n= msg.length; ii < n; ++ii) {
				if (msg[ii]['DS_ID'] == dsID) {
					return true;
				}
			}
			return false;
		}
		var msg = [];
		if (gmsg != null) {
			msg = gmsg['ROWS'];
		}
		if (CustomSQLDo.options["additionalDS"]) {	// 个例数据源，由外部模块提供
			if (CustomSQLDo.options['onlyAdditionalDS']) {
				msg = [];
			}
			var dsHtml = "";
			for (i=0; i<CustomSQLDo.options["additionalDS"].length; ++i) {
				var ds = CustomSQLDo.options["additionalDS"][i];
				if (! additionalAdded(ds['DS_ID'])) {
					msg.unshift(ds);
					controller.suplyDirectly('ds_column_list', {ds_id: ds['DS_ID']}, {ROWS: ds.columns});
				}
			}
		}
		$("#custom_sql_ds_body").empty();
		for (var i = 0; i < msg.length; i++) {
			for ( var key in msg[i]) {
				if (msg[i][key] == null)
					msg[i][key] = "";
				msg[i][key] = msg[i][key].toString().replace(/'/g, "&apos;");
			}
			var line = 
				"<tr quote_id=" + msg[i]['QUOTE_ID'] + ">" +
					"<td><input type='radio' readonly class='pointer' value='" + msg[i]['QUOTE_ID'] + "'" +
						" ds_id='" + msg[i]['DS_ID'] + "'" +
						" dbs_type='" + msg[i]['DBS_TYPE'] + "'" +
						"/>" +
					"</td>" +
					"<td><input type='text' class='dis_writable none pointer' name='ds_name' readonly value='" + htmlEncode(msg[i]['NAME']) + "'" +
						" username='" + htmlEncode(msg[i]['USERNAME']) + "'" +
						" table_name='" + htmlEncode(msg[i]['TABLE_NAME']) + "'" +
						"/>" + 
					"</td>" +
					"<td><input type='text' class='dis_writable none' name='alias' readonly value='" + msg[i]['ALIAS'] + "'/></td>" +
					"<td><input type='text' class='dis_writable none' readonly value='" + htmlEncode(msg[i]['EXPLAIN']) + "' title='" + htmlEncode(msg[i]['EXPLAIN']) + "'/></td>" +
				"</tr>";
			$("#custom_sql_ds_body").append(line);
		}
		
		var options = CustomSQLDo.options;
		if (options.quoteInvalidList && options.quoteInvalidList.length > 0) {
			var quoteList = $('#custom_sql_ds_body tr');
			var newList = [];
			var invalidList = [];
			var jj = 0;
			var kk = 0;
			for (var ii = 0; ii<quoteList.length; ++ii) {
				var quoteId = $(quoteList[ii]).attr("quote_id");
				if (options.quoteInvalidList[quoteId]) {
					invalidList[jj] = quoteList[ii];
					$(invalidList[jj]).find("input:radio").attr("disabled", "disabled");
					$(invalidList[jj]).find("input:radio").attr("title", options.quoteInvalidList[quoteId]);
					jj += 1;
				} else {
					newList[kk] = quoteList[ii];
					$(newList[kk]).removeAttr("disabled");
					$(newList[kk]).removeAttr("title");
					kk += 1;
				}
			}
			for (var ii = 0; ii<invalidList.length; ++ii) {
				newList[newList.length] = invalidList[ii];
			}
			$('#custom_sql_ds_body').empty();
			$('#custom_sql_ds_body').append(newList);
		}
		
	}, false);
	
	controller.addRequest('ds_column_list', '#custom_sql_column_body', function(gmsg) {
		var msg = [];
		if (gmsg != null) {
			msg = gmsg['ROWS'];
		}
		var dsHtml = "";
		$('#custom_sql_column_body').empty()
		for (var i = 0; i < msg.length; i++) {
			for ( var key in msg[i]) {
				if (msg[i][key] == null)
					msg[i][key] = "";
				msg[i][key] = msg[i][key].toString().replace(/'/g, "&apos;");
			}
			var line = 
				"<tr>" +
					"<td><input type='text' class='pointer dis_writable none' name='name_en' readonly onselectstart='return false;' " +
						"style='-moz-user-select: none;' " +
						"data_type='" + msg[i]['DATA_TYPE'] + "'" +
						" value='" + htmlEncode(msg[i]['NAME']) + "'/>" +
					"</td>" +
					"<td><input type='text' class='dis_writable none' name='name_cn' readonly value='" + msg[i]['NAME_CN'] + "'/></td>" +
					"<td><input type='text' class='dis_writable none' readonly value='" + htmlEncode(msg[i]['EXPLAIN']) + "'/></td>" +
				"</tr>";
			dsHtml = dsHtml + line;
		}
		$("#custom_sql_column_body").append(dsHtml);
	}, false);
});

CustomSQLDo.getDSList = function(serviceID, ssvcID, onlySSVC) {
	controller.request.call($('#custom_sql_ds_body').empty(), 'node_ds_list', 
		{service_id: serviceID,
		 sub_service_id: ssvcID,
		 only_ssvc: onlySSVC
		});
};

CustomSQLDo.getColumnList = function(dsID) {
	controller.request.call($('#custom_sql_column_body').empty(), 'ds_column_list', {ds_id: dsID});
};

CustomSQLDo.showDialog = function() {
	$("#custom_sql_main").dialog({
		autoOpen : true,
		width : 900,
		height : 600,
		modal : true,
		// draggable: false,
		// resizable:false,//禁止改变窗口大小
		title : "自定义语句",
		open : function(event, ui) {
			CustomSQLDo.customSQLParts = $("#custom_sql_main").data("customSQLParts");
			CustomSQLDo.options = $("#custom_sql_main").data("options");
			
			DSInfo.assistInputColumn("#custom_sql_input_textarea", 
				CustomSQLDo.options["serviceID"], CustomSQLDo.options["subServiceID"], CustomSQLDo.options["onlySSVC"]);	// 辅助输入字段名

			$("#custom_sql_stmt_part_ul").empty();
			for (var key = 0; key < CustomSQLDo.customSQLParts.length; ++key) {
				$("#custom_sql_stmt_part_ul").append("<li class='pointer normal'>" + CustomSQLDo.customSQLParts[key].name + "</li>");
			}
			
			$("#custom_sql_stmt_part_ul > li").first().addClass("selected").siblings().removeClass("selected");
			$("#custom_sql_input_textarea").val(CustomSQLDo.customSQLParts[0].content);
			$("#custom_sql_input_textarea").css("color", "#000000");

			showHint($("#custom_sql_stmt_part_ul > li")[0]);
			
			var $dsList = $("#custom_sql_ds_body > tr");
			
			//if ($dsList.length == 0) { 同一页面的弹出对话框可能要求不同，因此每次重新初始化数据源列表
				CustomSQLDo.getDSList(CustomSQLDo.options["serviceID"], CustomSQLDo.options["subServiceID"], CustomSQLDo.options["onlySSVC"]);
			//}

			$("#custom_sql_ds_list").FixedHead({
				tableLayout: 'fixed',
				searchBind: '1',
				searchIndexes: '1,2'
			}, true);
		},
		close: function() {
			ColumnAlgorithm.closeIt();
		},
		buttons : {
			"取消" : function() {
				$("#custom_sql_main").dialog("close");
			},
			"确定" : function() {
				var $ul_li = $("#custom_sql_stmt_part_ul li");
				var oldIndex = $ul_li.index($("#custom_sql_stmt_part_ul li").filter(".selected"));
				CustomSQLDo.customSQLParts[oldIndex].content = $("#custom_sql_input_textarea").val();
				
				$("#custom_sql_main").data("customSQLParts", CustomSQLDo.customSQLParts);
				var returnAttach = CustomSQLDo.options["returnAttach"];
				if (returnAttach) {
					returnAttach.data("customSQLParts", CustomSQLDo.customSQLParts);
				}
				var returnDirectly = CustomSQLDo.options["returnDirectly"];
				if (returnDirectly) {
					for (var col in returnDirectly) {
						for (var i=0; i<CustomSQLDo.customSQLParts.length; ++i) {
							if (CustomSQLDo.customSQLParts[i].column == col) {
								$(returnDirectly[col]).val(CustomSQLDo.customSQLParts[i].content);
							}
						}						
					}
				}
				
				$("#custom_sql_main").dialog("close");
			}
		}
	})
};