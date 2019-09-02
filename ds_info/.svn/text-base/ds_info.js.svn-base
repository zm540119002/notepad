/** 数据源信息数据管理，注册controller取得数据源/字段的请求和回调函数，以填充dsList/dsColumnList等数据结构。提供相关的公共函数：
 * 	1、通过控制器[controller]请求数据源配置数据
 *  2、assistInputColumn提供字段名称辅助输入功能
 *  3、checkValidColumn提供来源字段名称校验功能，校验无误的返回对应的column_id
 *  4、若其他外部模块需用到dsList、dsColumnList等数据，需事先执行init函数初始化，注意这些数据结构都是通过异步方式取得
 *  
 *  实现方式：AJAX取数，并缓存到类变量中，外部调用时，先检查本地缓存是否已有数据，有责直接执行回调函数填充页面；
 *  	否则执行AJAX取数，并定义自定义事件，将事件绑定到调用接口时传入的”选择器“，AJAX成功后触发自定义事件填充页面数据
 *  
 *  典型用法：  
 */

include("/audit_config/js/comm_func.js", "/audit_config/js/controller.js");
include("/audit_config/js/comm_func.js", "/audit_config/js/text_cursor_position.js");

DSInfo = function() {
	
};

DSInfo.dsList = [];
DSInfo.dsColumnList = {};
DSInfo.alias2ds = {};
DSInfo.inited = false;
DSInfo.selector = 'body';

$(function() {
	controller.suplyAjax('node_ds_list', {
		url : baseUrl("/audit_config/js/comm_func.js") + "/audit_config/ds_info/action.php?action=get_node_ds_list",
		data: {page: -1, rows: -1, totalRows: -1}
	});
	
	controller.suplyAjax('ds_column_list', {
		url : baseUrl("/audit_config/js/comm_func.js") + "/audit_config/ds_info/action.php?action=get_column_list",
		data: {page: -1, rows: -1, totalRows: -1}
	});
	
	controller.suplyAjax('column_algorithm', {
		url : baseUrl("/audit_config/js/comm_func.js") + "/audit_config/ds_info/action.php?action=get_column_algorithm",
		data: {page: -1, rows: -1, totalRows: -1}
	});
});

/**
 * 初始化数据源管理数据，assistInputColumn和checkValidColumn会自动调用，其它外部模块如若用到dsList等数据时，应先调用init进行初始化
 * @param serviceID：稽核专题ID，用于初始化数据源列表
 * @param ssvcID：稽核点ID，用于初始化数据源列表
 * @param onlySSVC：是否仅取本稽核点的数据源，用于初始化数据源列表
 * @param selector：JQUERY选择器，用于指定数据源列表、数据源字段列表的挂载点，默认为body
 */
DSInfo.init = function(serviceID, ssvcID, onlySSVC, selector) {
	DSInfo.selector = selector || DSInfo.selector;
	if (! DSInfo.inited) {		
		controller.addRequest('node_ds_list', 'body', function(gmsg) {
			var msg = [];
			if (gmsg != null) {
				msg = gmsg['ROWS'];
				DSInfo.dsList = msg;
				for (var i=0; i<msg.length; ++i) {
					DSInfo.alias2ds[msg[i]['ALIAS']] = {quoteID: msg[i]['QUOTE_ID'], dsID: msg[i]['DS_ID']};
				}
			}
		}, true, {service_id: serviceID, sub_service_id: ssvcID, only_ssvc: onlySSVC});

		controller.addRequest('ds_column_list', 'body', function(gmsg, params) {
			if (gmsg != null) {
				var msg = gmsg['ROWS'];
				if (msg != null) {							
					DSInfo.dsColumnList[params['ds_id']] = msg;
				}
			}
		});
		
		DSInfo.inited = true;
	}
};

DSInfo.externalDS = function(ds, columnList) {
	if (DSInfo.dsList.length > 0) {
		DSInfo.dsList.unshift(ds);
		DSInfo.dsColumnList[ds['DS_ID']] = columnList;
	}
};

DSInfo.tableName = function(username, tableName) {
	if (tableName.search(/^\w+\.\w+/) >= 0) {
		return tableName;
	} else {
		return (username ? username + "." : "") + tableName;
	}
}

DSInfo.assistInputColumnFocused = function() {
	var focused = document.activeElement;
	return $(focused).is("div.column_name_assistant_input select");
}

DSInfo.assistInputColumnHide = function() {
	$("div.column_name_assistant_input").hide();
}

/** 
 * 编辑框中输入字符时，辅助输入字段名，典型应用场景，监听源字段/计算表达式输入框的keyup事件，发现用户输入了类似A5.CU的字段名时，自动搜索字段定义，并弹出可选项供用户选择
 * 限制：若判断用户要输入字段，但此时还未从后台取得字段定义，则通过AJAX从后台取得字段配置，为避免影响用户输入，此次按键时间不会弹出可选字段列表
 * @param selector：JQUERY选择器，用于指定需要辅助输入字段的页面元素，如："#report_head_item_list_tbodySort input[name='report_head_item_source_column_name']"
 * @param serviceID：稽核专题ID，用于初始化数据源列表
 * @param ssvcID：稽核点ID，用于初始化数据源列表
 * @param onlySSVC：是否仅取本稽核点的数据源，用于初始化数据源列表
 */
DSInfo.assistInputColumn = function(selector, serviceID, ssvcID, onlySSVC) {
	DSInfo.inited || DSInfo.init(serviceID, ssvcID, onlySSVC);
	_assistInputColumn = function(obj, event) {
		function closeWhenBlur() {
			setTimeout(function() {
				$assistSelect.parent().hide();
			}, 100);
		}
		var $assisParent = $("body"); //$(this).parents("div:first").parent();
		if ($assisParent.find("div.column_name_assistant_input").length == 0) {
			var assistOptions = '<div class="column_name_assistant_input" style="position: absolute; z-index:3003; margin:0px; padding:0px; width:100px; height:150px; display:none;"><select multiple="multiple" size="8"></select></div>';
			$assisParent.append(assistOptions);
		}
		var $assistSelect = $assisParent.find("div.column_name_assistant_input > select");
		
		var pos = cursorPosition(obj);
		var textEle = obj;
		var aStr = $(obj).val().substring(0,pos);
		if (aStr.search(/([a-zA-Z]+\d+\.[a-zA-Z]+[a-zA-Z0-9_#]+$)/) < 0) {
			$assistSelect.parent().hide();
			return true;
		}
		var lastWord = aStr.substring(aStr.search(/([a-zA-Z]+\d+\.[a-zA-Z]+[a-zA-Z0-9_#]+$)/));
		var alias = lastWord.replace(/([a-zA-Z0-9]+)\..*/, "$1");

		$assistSelect.empty();
		if (alias) {
			var colName = lastWord.replace(/(\w+)\.([a-zA-Z0-9_#]+)/, "$2");
			
			if (DSInfo.dsList.length > 0 && ! DSInfo.alias2ds[alias]) {
				return '字段名格式不对，不存在或无权访问此别名[' + alias + ']！';
			}
			if (! DSInfo.alias2ds[alias]) {
				//DSInfo.getDSList(null, serviceID, ssvcID, onlySSVC);
				controller.request.call(
					$(DSInfo.selector), 'node_ds_list', 
					{service_id: serviceID, sub_service_id: ssvcID, only_ssvc: onlySSVC});
			} else if (! DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID]) {
				//DSInfo.getColumnList(null, DSInfo.alias2ds[alias].dsID);
				controller.request.call($(DSInfo.selector), 'ds_column_list', {ds_id: DSInfo.alias2ds[alias].dsID});
			} else {			
				$(obj).unbind('change', closeWhenBlur);
				$(obj).bind('change', closeWhenBlur);			
				for (var i=0; i<DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID].length; ++i) {
					var colReg = new RegExp('^' + colName, 'i');
					var columnName = DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID][i]['NAME'];
					if (columnName.search(colReg) >= 0) {
						$assistSelect.append('<option value="' + alias + '.' + columnName + '">' + alias + '.' + columnName + '</option>');
					}
				}
				if ($assistSelect.find("option").length >= 1) {
					$assisParent.find("div.column_name_assistant_input > select").unbind('click keyup');
					$assisParent.find("div.column_name_assistant_input > select").bind('click keyup', function(event) {
	    				if (event && event.keyCode && event.keyCode != 13 && event.keyCode != 32) {  // 空格/回车键/鼠标单击选中，并将字段名加入编辑框
	        				return false;
	    				}
	    				var addText = $(this).find("option:selected").val().substring(lastWord.length);
	    				if (colName.search(/[a-z]+/) >= 0) {  // 用户已输入的字段名【前几位】如有小写字符，则加入的字符转为小写，否则转为大写
	    					addText = addText.toLowerCase();
	    				} else {
	    					addText = addText.toUpperCase();
	    				}
						insertText(textEle, addText);
	    				$(this).parent().hide();
						textEle.focus();
					});
					
			    	var coordinate = kingwolfofsky.getInputPositon(obj);
					$assistSelect.parent().css({top: coordinate.bottom, left: coordinate.left});
					$assistSelect.parent().show();
				} else {
					$assistSelect.parent().hide();
				}
			}
		} else {
			$assistSelect.parent().hide();
		}
	}

	if (typeof(DSInfo.assistInputColumn.selectorList[selector]) == 'undefined') {
		DSInfo.assistInputColumn.selectorList[selector] = selector;
		$(selector).live("keydown", function(event) {
			$assistDiv = $("body").find("div.column_name_assistant_input");
			if (event.keyCode == 40 && $assistDiv.filter("div:hidden").length == 0) {
				$assistDiv.find("option:first")[0].selected = 'selected';
				$assistDiv.find("select").focus();
				return false;
			} else if (event.keyCode == 27 && $assistDiv.filter("div:hidden").length == 0) {
				$assistDiv.hide();
			}
		});	
		$(selector).live("keyup", function(event) {
			_assistInputColumn(this, event);	// 辅助输入字段名
		});
	}
}
DSInfo.assistInputColumn.selectorList = DSInfo.assistInputColumn.selectorList || {};

/** 
 * 检查是否有效的字段名，合格的字段名应该为xx.yyyy格式，其中xx为别名,yyyy为字段名，且别名和字段名存在于字段配置中
 * @param serviceID：稽核专题ID，用于初始化数据源列表
 * @param ssvcID：稽核点ID，用于初始化数据源列表
 * @param onlySSVC：是否仅取本稽核点的数据源，用于初始化数据源列表
 * @param columnName：字段名称
 * @return -1：数据源列表未初始化；请等待初始化！-2：字段列表未初始化，请等待数据初始化！0：字段列表中不存在的字段名；{columID:..., dsID: ..., quoteID: ...}对象：正常的column_id；其它：错误信息
 */
DSInfo.checkValidColumn = function(serviceID, ssvcID, onlySSVC, columnName) {
	DSInfo.inited || DSInfo.init(serviceID, ssvcID, onlySSVC);
	var alias = columnName.replace(/([a-zA-Z0-9]+)\..*/, "$1");
	if (! alias) return '字段名格不对，没有别名！';

	var colName = columnName.replace(/(\w+)\.([a-zA-Z0-9_#]+)/, "$2");
	if (! colName) {
		return '字段名格式不对，没有输入字段名！';
	}
	
	if (DSInfo.dsList.length > 0 && ! DSInfo.alias2ds[alias]) {
		return '字段名格式不对，不存在或无权访问此别名[' + alias + ']！';
	}
	
	if (! DSInfo.alias2ds) {
		//DSInfo.getDSList(null, serviceID, ssvcID, onlySSVC);
		controller.request.call(
			$(DSInfo.selector), 'node_ds_list', 
			{service_id: serviceID, sub_service_id: ssvcID, only_ssvc: onlySSVC});
		return -1;
	} else if (! DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID]) {
		//DSInfo.getColumnList(null, DSInfo.alias2ds[alias].dsID);
		controller.request.call($(DSInfo.selector), 'ds_column_list', {ds_id: DSInfo.alias2ds[alias].dsID});
		return -2;
	} else {
		for (var i=0; i<DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID].length; ++i) {
			var columnName = DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID][i]['NAME'];
			if (columnName.toUpperCase() == colName.toUpperCase()) {
				return {columnID: DSInfo.dsColumnList[DSInfo.alias2ds[alias].dsID][i]['COLUMN_ID'], dsID: DSInfo.alias2ds[alias].dsID, quoteID: DSInfo.alias2ds[alias].quoteID};
			}
		}
	}
	
	return 0;
}