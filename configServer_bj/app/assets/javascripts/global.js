String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, '');
};

Array.prototype.clone = function () { 
	return this.slice(0); 
} 

Array.prototype.unique = function() {
	
}

Array.prototype.remove = function(b) { 
	var a = this.indexOf(b); 
	if (a >= 0) { 
		
		this.splice(a, 1); 
		return true; 
	} 
	
	return false; 
};

Array.prototype.removeOnIndex = function (a) {
	if (a < this.length) {
		this.splice(a, 1); 
		return true;
	}
	
	return false;
}

Array.prototype.contains = function(a) {
	var b = this.indexOf(a);
	if (b >= 0) {
		return true;
	}
	else {
		return false;
	}
}

String.prototype.trim=function(){return this.replace(/^\s+|\s+$/g, '');};

String.prototype.ltrim=function(){return this.replace(/^\s+/,'');};

String.prototype.rtrim=function(){return this.replace(/\s+$/,'');};

String.prototype.fulltrim=function(){return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');};

String.prototype.equals=function(target) {return this == String(target);}

String.prototype.equalsIgnoreCase=function(target) {return this.toUpperCase() == String(target).toUpperCase();}

function getMegaFromBytes(bytes) {
	return Math.round(bytes / (1024*1024));
}

function getFunctionName(fun) {
  var ret = fun.toString();
  ret = ret.substr('function '.length);
  ret = ret.substr(0, ret.indexOf('('));
  return ret;
}

function isNotEmptyString(a) {
	if (a != null && a != undefined && a != "") {
		return true;
	}
	
	return false;
}

//////////////////////////////////////////////////////////
// pagination button enable / disable
function disableLnkBtn(btn) {
	if (btn.hasClass("pagination-btn-enable")) {
		btn.removeClass("pagination-btn-enable");
	}
	
	if (!btn.hasClass("pagination-btn-disable")) {
		btn.addClass("pagination-btn-disable");
	}
}

function enableLnkBtn(btn) {
	if (btn.hasClass("pagination-btn-disable")) {
		btn.removeClass("pagination-btn-disable");
	}
	
	if (!btn.hasClass("pagination-btn-enable")) {
		btn.addClass("pagination-btn-enable");
	}
}

/////////////////////////////////////////////////////////
//search with preload
/*
options_format = {
"listHtmlGeneratorCallBack":null,
"searchFailCallBack": null,
"searchErrorCallBack": null,
"listContainerId": null,
"lbPageNumberId":null,
"previousBtnId":null,
"nextBtnId":null,
"prev_page_ResultSet":null,
"next_page_ResultSet":null,
"curr_page_ResultSet":null,
"search_url": null,
"searchParameter":null //[{key :"", value: ""}]
}
*/

var searchUtil = function(para_listHtmlGeneratorCallBack, 
		para_searchFailCallBack, 
		para_searchErrorCallBack,
		para_preChangePage,
		para_postChangePage,
		para_listContainerId, 
		para_lbPageNumberId,
		para_previousBtnId,
		para_nextBtnId,
		para_searchUrl,
		para_refreshTab){
	var listHtmlGeneratorCallBack = para_listHtmlGeneratorCallBack;
	var searchFailCallBack = para_searchFailCallBack;
	var searchErrorCallBack = para_searchErrorCallBack;
	var preChangePage = para_preChangePage;
	var postChangePage = para_postChangePage;
	var listContainerId = para_listContainerId;
	var lbPageNumberId = para_lbPageNumberId;
	var previousBtnId = para_previousBtnId;
	var nextBtnId = para_nextBtnId;
	var searchUrl = para_searchUrl;
	var prev_page_ResultSet = {"pageNo": "", "records": ""};
	var next_page_ResultSet = {"pageNo": "", "records": ""};
    var curr_page_ResultSet = {"pageNo": "", "records": ""};
	
	var searchParameter = null;
	var isParameterChanged = false;
	
	var refreshTab = para_refreshTab;

	this.convertKeywordsSearchable = function (keywords) {
		if (!isNotEmptyString(keywords)) {
			return "";
		}
		
		var keyword_array = keywords.replace(/;/g, " ").replace(/；/g, " ").split(" ");
		for (var i = 0; i < keyword_array.length;i++){
			if (keyword_array[i].trim() == "")  {
				keyword_array.remove(keyword_array[i]);
			}
			else {
				i++;
			}
		}
		
		return keyword_array.join(" ");
	};
	
	this.setSearchParemeter = function (key, value) {
		if (searchParameter == null) {
			searchParameter = [];
		}
		
		var inParameter = false;
		for (var i = 0; i < searchParameter.length;i++) {
			if (searchParameter[i].key == key) {
				searchParameter[i].value = value;
				inParameter = true;
				break;
			}
		}
		
		if (!inParameter) {
			searchParameter.push({"key": key, "value": value});
		}
		
		isParameterChanged = true;
	};
	
	this.addSearchParameter = function(key, value) {
		if (searchParameter == null) {
			searchParameter = [];
		}
		searchParameter.push({"key": key, "value": value});
		isParameterChanged = true;
	};

	this.getCurrentPage = function() {
		if (curr_page_ResultSet != null) {
			return curr_page_ResultSet.pageNo;
		}
		return null;
	}
	
	function doRefreshCurrentPage() {
		if (curr_page_ResultSet != null && isNotEmptyString(curr_page_ResultSet.pageNo)) {
			doSearchWithPreload(curr_page_ResultSet.pageNo);
		}
		else {
			doSearchWithPreload(null);
		}
	}
	
	function doSearchWithPreload (pageNo) {
/*		if (pageNo == null || pageNo == "") {
			if (curr_page_ResultSet != null && isNotEmptyString(curr_page_ResultSet.pageNo)) {
				pageNo = curr_page_ResultSet.pageNo;
			} 
			else {
				pageNo = 1;
			}
		}*/

		if (pageNo == null || pageNo == "") {
			pageNo = 1;
		}

		if (searchParameter != null) {
			for (var i = 0; i < searchParameter.length; i++) {
				if (searchParameter[i].value == null) {
					searchParameter[i].value = "";
				}
			}
		}

		if (pageNo == prev_page_ResultSet.pageNo) {
			if (prev_page_ResultSet != null 
					&& prev_page_ResultSet.pageNo != null
					&& prev_page_ResultSet.records != null) {
				var a_pagination_prev = $("#" + previousBtnId);
				a_pagination_prev.unbind('click');
				disableLnkBtn(a_pagination_prev);
				
				if (preChangePage != null) preChangePage(prev_page_ResultSet, curr_page_ResultSet, next_page_ResultSet);
				
				next_page_ResultSet.pageNo = curr_page_ResultSet.pageNo;
				next_page_ResultSet.records = curr_page_ResultSet.records;
				curr_page_ResultSet.pageNo = prev_page_ResultSet.pageNo;
				curr_page_ResultSet.records = prev_page_ResultSet.records;
				prev_page_ResultSet.pageNo = null;
				prev_page_ResultSet.records = null;
				
				var a_pagination_next = $("#" + nextBtnId);
				a_pagination_next.unbind('click');
				a_pagination_next.click(function() {
					doSearchWithPreload(next_page_ResultSet.pageNo);
				});
				
				$("#" + listContainerId).html(listHtmlGeneratorCallBack(curr_page_ResultSet.records)); 
				$("#" + lbPageNumberId).text(curr_page_ResultSet.pageNo);
				
				if (pageNo-1 > 0) {
					enableLnkBtn(a_pagination_prev); //enable previous button
					doSearch(pageNo - 1, -1);
				}
				else {
					disableLnkBtn(a_pagination_prev); //disable previous button
					a_pagination_prev.unbind('click');
				}
				
				if (postChangePage != null) postChangePage(prev_page_ResultSet, curr_page_ResultSet, next_page_ResultSet);
			}
		}
		else if (pageNo == next_page_ResultSet.pageNo) {
			if (next_page_ResultSet != null 
					&& next_page_ResultSet.pageNo != null
					&& next_page_ResultSet.records != null) {
				var a_pagination_next = $("#" + nextBtnId);
				a_pagination_next.unbind('click');
				disableLnkBtn(a_pagination_next);
				
				if (preChangePage != null) preChangePage(prev_page_ResultSet, curr_page_ResultSet, next_page_ResultSet);
				
				prev_page_ResultSet.pageNo = curr_page_ResultSet.pageNo;
				prev_page_ResultSet.records = curr_page_ResultSet.records;
				curr_page_ResultSet.pageNo = next_page_ResultSet.pageNo;
				curr_page_ResultSet.records = next_page_ResultSet.records;
				next_page_ResultSet.pageNo = null;
				next_page_ResultSet.records = null;
				
				var a_pagination_previous = $("#" + previousBtnId);
				a_pagination_previous.unbind('click');
				a_pagination_previous.click(function() {
					doSearchWithPreload(prev_page_ResultSet.pageNo);
				});
				
				$("#" + listContainerId).html(listHtmlGeneratorCallBack(curr_page_ResultSet.records)); 
				$("#" + lbPageNumberId).text(curr_page_ResultSet.pageNo);
				
				if (pageNo -1 > 0) {
					enableLnkBtn(a_pagination_previous); //enable previous button
				}
				else {
					disableLnkBtn(a_pagination_previous); //disable previous button
				}
				
				doSearch(pageNo + 1, 1);
				
				if (postChangePage != null) {
					postChangePage(prev_page_ResultSet, curr_page_ResultSet, next_page_ResultSet);
				}
			}
		}
		else {
			if (preChangePage != null) {
				preChangePage(prev_page_ResultSet, curr_page_ResultSet, next_page_ResultSet);
			}
			
			if (pageNo - 1 > 0) {
				doSearch(pageNo -1, -1);
			}
			
			doSearch(pageNo, 0);

			if (pageNo - 1 > 0) {
				enableLnkBtn($("#" + previousBtnId)); //enable previous button
				doSearch(pageNo - 1, -1);
			} else {
				disableLnkBtn($("#" + previousBtnId)); //disable previous button
			}
			
			doSearch(pageNo + 1, 1);
		}
		
		isParameterChanged = false;
	};
	
	this.searchWithPreload = doSearchWithPreload;
	this.refreshCurrentPage = doRefreshCurrentPage;  

	function searchSuccessCallBack(data, preloadOffset, pageNo) {
		if (preloadOffset == null || preloadOffset == 0) {

			curr_page_ResultSet.pageNo = data.pageNo;
			curr_page_ResultSet.records = data.records;
			$("#" + listContainerId).html(listHtmlGeneratorCallBack(curr_page_ResultSet.records)); 
			$("#" + lbPageNumberId).text(pageNo);
			
			if (postChangePage != null) postChangePage(prev_page_ResultSet, curr_page_ResultSet, next_page_ResultSet);
		}
		else if (preloadOffset < 0) {
			prev_page_ResultSet.pageNo = data.pageNo;
			prev_page_ResultSet.records = data.records;
			
			var a_pagination_previous = $("#" + previousBtnId);
			a_pagination_previous.unbind('click');
			a_pagination_previous.click(function() {
				doSearchWithPreload(pageNo);
			});
			
			if (prev_page_ResultSet != null 
					&& prev_page_ResultSet.records != null
					&& prev_page_ResultSet.records.length > 0 ) {
				enableLnkBtn(a_pagination_previous); //enable previous button
			} else {
				disableLnkBtn(a_pagination_previous); //disable previous button
			}
		}
		else if (preloadOffset > 0) {
			next_page_ResultSet.pageNo = data.pageNo;
			next_page_ResultSet.records = data.records;
			
			var a_pagination_next = $("#" + nextBtnId);
			if (data.records != null && data.records.length > 0) {
				a_pagination_next.unbind('click');
				a_pagination_next.click(function() {
					doSearchWithPreload(pageNo);
				});
			}
			
			if (next_page_ResultSet != null 
					&& next_page_ResultSet.records != null
					&& next_page_ResultSet.records.length > 0) {
				enableLnkBtn(a_pagination_next); //enable previous button
			} else {
				disableLnkBtn(a_pagination_next); //disable previous button
			}
		}
	};

	function doSearch (pageNo, preloadOffset) {
		if (pageNo == null || pageNo == "") {
			pageNo = 1;
		}
		
		if (searchParameter != null) {
			for (var i = 0; i < searchParameter.length; i++) {
				if (searchParameter[i].value == null) {
					searchParameter[i].value = "";
				}
			}
		}
		
		var submitSearchParas = {'pageNo': pageNo};
		if (searchParameter != null) {
			for (var i = 0; i < searchParameter.length; i++) {
				submitSearchParas[searchParameter[i].key] = searchParameter[i].value;
			}
		}
		var el = $(".portlet-body");   
		if(refreshTab != null){
			el = $("#" + refreshTab);
		}
        App.blockUI({target: el, textOnly: true});
		$.ajax({
		    type: 'GET',
		    dataType: 'json',
		    url: searchUrl,
		    data: submitSearchParas,
		    contenttype: "application/json; charset=utf-8",
		    datatype: "json",
		    beforeSend :function(xmlHttp){ 
		    	xmlHttp.setRequestHeader("If-Modified-Since","0"); 
		    	xmlHttp.setRequestHeader("Cache-Control","no-cache"); 
		    }, 
		    success: function (data) {
		    	App.unblockUI(el);
		        if (data.result != 'FAIL') {
		        	searchSuccessCallBack(data, preloadOffset, pageNo);
		        } else {
		        	searchFailCallBack(data.result, data.message);
		            return false;
		        }
		    },
		    error: function (data) {
		    	App.unblockUI(el);
		    	searchErrorCallBack(data.result, data.message);
		        return false;
		    }
		});
	};
};

var MessageBundle = new function () {
	this.autoRefreshHintTimer = null;
	this.autoRefreshHintInterval = 10 * 1000;
	this.twinkleTimeOffSet = 10 * 1000;
	this.twinkleDuration = 60 * 1000;
	this.iconClass = "glyphicon glyphicon-envelope";
	this.hintContainerId = "showmsg";
	this.twinkleTimer = null;
	this.twinkleInterval = 1 * 1000;
	this.contextPath = null;
	this.isInited = false;
	
	this.showMessageHint = function (newMsgNum) {
		var hintContainer = $("#" + this.hintContainerId);
		
		if (hintContainer != null && hintContainer.length > 0) {
			hintContainer.children().remove();
			hintContainer.html('');
			hintContainer.html("<span id='span_icon' class='" + this.iconClass + "'></span> &nbsp;");
			if (newMsgNum != null && newMsgNum > 0) {
				hintContainer.append("新消息(" + newMsgNum + ")");
				this.twinkleIcon(this.twinkleTimeOffSet, this.twinkleDuration);
			}
			else {
				hintContainer.append("&nbsp;消息&nbsp;&nbsp;");
			}
		}
	}
	
	this.twinkleIcon = function (offSet, duration) {
		
		if (this.twinkleTimer != null || this.twinkleTimer != undefined){
			clearTimeout(this.twinkleTimer);
			this.twinkleTimer = null;
		}
		var spanIcon = $('#span_icon');
		if (duration <= 0) {
			if (!spanIcon.hasClass(this.iconClass)) {
				spanIcon.addClass(this.iconClass);
			}
			return false;
		}

		if (duration < this.twinkleDuration ) {
			spanIcon.hasClass(this.iconClass) ? spanIcon.removeClass(this.iconClass) : spanIcon.addClass(this.iconClass); 
		}
		
		var actionJs = "MessageBundle.twinkleIcon(MessageBundle.twinkleInterval, (" + duration + " - MessageBundle.twinkleInterval));";
		
		this.twinkleTimer = setTimeout(actionJs, offSet);
	}
	
	/////////////////////////////////////////////
	// refreshHint
	this.refreshHint = function() {
		this.SearchMessages(true, false, true, MessageBundle.refreshHintSuccessCallBack, MessageBundle.refreshHintErrorCallBack);
		
		//setTimeout("MessageBundle.refreshHint();", this.autoRefreshHintInterval);
	};
	this.refreshHintSuccessCallBack = function(data) {
    	var newMsgNumber = 0;
        if (data.result == 'OK') {
        	if (isNotEmptyString(data.totalRecord)) {
        		newMsgNumber = data.totalRecord;
        	}
        }
        MessageBundle.showMessageHint(newMsgNumber);
	};
	this.refreshHintErrorCallBack = function(data) {
		MessageBundle.showMessageHint(0);
	};
	
	///////////////////////////////////////
	// initial Message Dialog
	this.initMsgDlg = function(accountType) {
		if (!this.isInited) {
			$.ajax({
				url: this.contextPath + '/system/get_message.htm',
				type:'get',
				dataType:'html',
				async:false,
				success:function(data){
					MessageBundle.isInited = true;
					$('div#systemMessageDialog').html('');
					$('div#systemMessageDialog').html(data);
					
					MessageBundle.eventsBind();
				}
			});
			
			if (accountType == "MERCHANT") {
				$("#li_new_msg").hide();
			}
		}
	};
	this.eventsBind = function() {
 	    $('#btn_save_msg').on('click', function(event) {
 	    	event.preventDefault(); 
 	    	$("#form_new_message").submit();
	    }); 
		
		//1. bind save message form sumbit
        $('#form_new_message').validate({
            errorClass: "error-notification",
            errorElement: "div",
            rules: {
            	msg_title: {
                    required: true,
                    maxlength: 100
                },
                msg_receivers: {
                    required: true
                }
            },
            messages: {
            	msg_title: {
                    maxlength: "标题不得超过100个字符"
                },
                msg_receivers: {
                    required: "请输入收信人帐号"
                }
            },
            submitHandler: function (form) {
            	var title = $("#msg_title").val();
            	var receiverIds = $("#msg_receivers").select2("val");
            	var content = $("#msg_content").val();
            	
            	MessageBundle.saveMsg(receiverIds, title, content);
            	
            	return false;
            }
        });

        //2. receiver auto-complete
		$('#msg_receivers').select2({
			minimumInputLength: 2,
			multiple: true,
			allowClear: true,
			formatResult: MessageBundle.formatResult, // omitted for brevity, see the source of this page
			formatSelection: MessageBundle.formatSelection, // omitted for brevity, see the source of this page
			containerCssClass: "msg-receiver-input",
			dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
			escapeMarkup: function (m) { return m; },
			ajax: {
				type : 'GET',
				dataType : 'json',
				url: MessageBundle.contextPath + '/account/searchaccount.htm',
				quietMillis: 100,
				data: function (term, pageNo) { // page is the one-based page number tracked by Select2
					 return {
						 keywords: term, //search term
					 	 pageNo: pageNo
					 };
				},
				results: function (data, pageNo) {
					preload_data = [];
					if (data.records != null && data.records.length > 0) {	
						for ( var i = 0; i < data.records.length; i++) {
							var accountId = data.records[i].id;
						    var accountName = null;
							if (isNotEmptyString(data.records[i].fullname)) {
								accountName = data.records[i].fullname + "(" + data.records[i].username + ")";	
							}
					 		else {
					 			accountName = data.records[i].username;
					 		}
							preload_data.push({id: accountId, name: accountName});
						}
					}
					
					var more = true;
					if(data.records.length < 10){
						 more = false;
					}

					return {results: preload_data, more: more};
				 }
			 }
		}); 
	};
	
	///////////////////////////////////////////////////////
	// receiver auto complete
	this.formatResult = function(record) {
		var markup;
		if(record){
			markup = "<table class='movie-result'><tr><td class='movie-info'>";
		    markup += "<div class='movie-title'>" + record.name + "</div>";
		    markup += "</td></tr></table>";
		}
	    return markup;
	};
	this.formatSelection = function(records) {
	    return records.name;
	};
	
	//////////////////////////////////////////
	// show / close dialog
	this.closeMsgDlg = function() {
		$('div#systemMessageDialog').modal('hide');
	};
	this.showMsgDlg = function() {
		if (!this.isInited) {
			this.initMsgDlg();
		}
		this.SearchMessages(false, null, true, MessageBundle.showMsgSuccessCallBack, MessageBundle.showMsgErrorCallBack);
		this.SearchMessages(false, null, false, MessageBundle.showSentBoxMsgErrorCallBack, MessageBundle.showMsgErrorCallBack);
		$('div#systemMessageDialog').modal('show');
	};
	this.showMsgSuccessCallBack = function(data) {
		if (data.result == 'OK') {
			var msgLstHtml = MessageBundle.renderMsgLst(data.records, false);
			
			var divMsgLst = $("#inMsglist");
			divMsgLst.children().remove();
			divMsgLst.html(msgLstHtml);
			
			
		}
	};
	this.showSentBoxMsgErrorCallBack = function(data) {
		if (data.result == 'OK') {
			var msgLstHtml = MessageBundle.renderMsgLst(data.records, true);
			
			var divMsgLst = $("#sentMsglist");
			divMsgLst.children().remove();
			divMsgLst.html(msgLstHtml);
		}
	};
	this.showMsgErrorCallBack = function(data) {
		//do nothing
	};
	this.paginationProcess = function(isSentBox) {
		if (isSentBox != true && isSentBox != false) {
			isSentBox = false;
		}
		// hide pageNumn and pagination button if have only one page. for Both
		
	}
	this.renderMsgLst = function (messages, isSentbox) {
		var msgLstHtml = "";

		if (messages != null && messages.length > 0) {
			for (var i =0; i < messages.length; i++) {
				var message = messages[i];
				var id = message.id;
				var senderId = message.senderId;
				var receiverId = message.receiverId;
				var title = message.title;
				var briefTitle = title;
				if (briefTitle != null && briefTitle.length > 15) {
					briefTitle = briefTitle.substring(0, 20) + " ...";
				}
				var content = message.content;
				var briefContent = content;
				if (briefContent != null && briefContent.length > 20){
					briefContent = briefContent.substring(0, 20) + " ...";
				}
				var briefContent = content;
				if (briefContent != null && briefContent.length > 30) {
					briefContent = briefContent.substring(0, 30) + " ...";
				}
				var isRead = message.isRead;
				var isFlaged = message.isFlaged;
				var createDatetime = message.createDatetime;
				var parentMsgId = message.parentMsgId;
				
				var fontWeight = !isRead ? "bold" : "normal";
				
				var senderName = "来自：" + (isNotEmptyString(message.senderFullName) ? message.senderFullName : message.senderUserName);
				var receiverNames = "";
				var receiverFullNames = "";
				var isAbbreviation = false;
				if (message.receiverInfos != null && message.receiverInfos.length > 0) {
					receiverLst = [];
					for (var i = 0; i < message.receiverInfos.length;i++) {
						var receiverInfo = message.receiverInfos[i];
						var name = isNotEmptyString(receiverInfo.fullName) ? receiverInfo.fullName : receiverInfo.userName;
						receiverLst.push(name);
					}
					
					receiverNames = "发给：" + receiverLst.join(", ");
					receiverFullNames = receiverNames;
					if (receiverNames.length > 15) {
						isAbbreviation = true;
						receiverNames = receiverNames.substring(0, 12) + " ...";
					}
				}
				var oppositeAbbrName = isSentbox ? receiverNames : senderName;
				var oppositeFullName = isSentbox ? receiverFullNames : senderName;

				var msgItemHtml = "";

				msgItemHtml += 	"<div id='message_" + id + "' class='panel-group accordion'><div class='panel panel-default msgpanel'>";
				msgItemHtml += 		"<div>";
				msgItemHtml += 			"<a id='lnk_toggle_" + id + "' onclick='javascript:MessageBundle.setMsgRead(this);' style='font-weight:" + fontWeight +";' class='accordion-toggle accordion-toggle-styled collapsed list-group-item' href='#' data-target='#collapse_" + id + "' data-parent='#message_" + id + "' data-toggle='collapse'>";
				//msgItemHtml += 				"<div class='checkbox'> <label><input id='selector_" + id + "' type='checkbox'></label> </div>";
				msgItemHtml += 				"<span class='name' style='min-width: 120px; display: inline-block;'>" + oppositeAbbrName;
				if (isAbbreviation) {
					msgItemHtml += 				"<i style='margin-left:5px;' class='glyphicon glyphicon-comment' rel='tooltip' title='"+ oppositeFullName +"' id=''></i>";
				}
				msgItemHtml += 				"</span>";
				msgItemHtml += 				"<span class='' style='margin-left:20px;'>" + briefTitle + "</span>";
				msgItemHtml += 				"<span class='text-muted' style='font-size: 11px;'>&nbsp;&nbsp;-&nbsp;&nbsp;" + content + "</span>";
				msgItemHtml += 				"<span class='badge'>" + createDatetime + "</span>";
				msgItemHtml += 				"<span class='pull-right'><span id='delete_" + id + "' onclick='javascript:MessageBundle.deleteMsg(this);' class='glyphicon glyphicon-remove'> </span></span>";
				msgItemHtml += 			"</a>";
				msgItemHtml += 		"</div>";
				msgItemHtml += 		"<div id='collapse_" + id + "' class='panel-collapse collapse' style='height: 0px;'>";
				msgItemHtml += 			"<div class='panel-header'>";
				msgItemHtml += 				"<p>" + title + "</p>";
				msgItemHtml += 			"</div>";
				msgItemHtml += 			"<div class='panel-body'>";
				msgItemHtml += 				"<p>" + content + "</p>";
				msgItemHtml += 			"</div>";
				msgItemHtml += 		"</div>";
				msgItemHtml += 	"</div></div>";

				msgLstHtml += msgItemHtml;
			}
		}
		return msgLstHtml;
	};
	
	//////////////////////////////////////////////////////
	//save new message 
	this.saveMsg = function (receiverIds, title, content) {
		MessageBundle.SendMessage(receiverIds, title, content, MessageBundle.saveMsgSuccessCallBack, MessageBundle.saveMsgErrorCallBack);
		return false;
	};
	this.saveMsgSuccessCallBack = function(data) {
		$("#msg_title").val("");
		$("#msg_content").val("");
		$("#msg_receivers").select2("val", "");
		
        $.pnotify({
            title: "发送信息成功",
            type: 'success',
            delay: 1500
        });
        
        MessageBundle.SearchMessages(false, null, false, MessageBundle.showSentBoxMsgErrorCallBack, MessageBundle.showMsgErrorCallBack);
	};
	this.saveMsgErrorCallBack = function(data) {
        $.pnotify({
            title: "发送信息失败",
            type: 'error',
            delay: 1500
        });
	};
	
	//////////////////////////////////////////////////////
	//set message read
	this.setMsgRead = function(msgItemContainer) {
		var a_msgItemContainer = $(msgItemContainer);
		if (a_msgItemContainer.css("font-weight") == 700) { // bolded
			a_msgItemContainer.css("font-weight", "normal"); 
			//todo call action set from unread to read
			var msgId = msgItemContainer.id.substring("lnk_toggle_".length);
			this.SetMessageRead(true, msgId, MessageBundle.setMsgReadSuccessCallBack, MessageBundle.setMsgReadSuccessCallBack.setMsgReadErrorCallBack);
		}
	};
	this.setMsgReadSuccessCallBack = function(data) { /*MessageHint will be refreshed every "this.autoRefreshHintInterval"*/ };
	this.setMsgReadErrorCallBack = function(data) {};
	
	//////////////////////////////////////////////////////
	//delete message
	this.deleteMsg = function(removeIcon) {
		var msgId = removeIcon.id.substring("delete_".length);
		this.DeleteMessage(msgId, MessageBundle.deleteMsgSuccessCallBack, MessageBundle.deleteMsgErrorCallBack);
	};
	this.deleteMsgSuccessCallBack = function(data) {
		MessageBundle.SearchMessages(false, null, true, MessageBundle.showMsgSuccessCallBack, MessageBundle.showMsgErrorCallBack);
	};
	this.deleteMsgErrorCallBack = function(data) {};

	//////////////////////////////////////////////////////
	// interface
	this.SearchMessages = function(isGetCount, isRead, isInbox, successCallBack, errorCallBack) {
		$.ajax({
            type: 'GET',
            dataType: 'json',
            url: this.contextPath + "/system/getmessages.htm", 
            data: {
            	"mailbox" : isInbox ? "in" : "out",
            	"keywords" : "",
            	"startdate" : "",
            	"enddate" : "",
            	"isread" : isRead,
            	"isflaged" : "",
            	"isgetcount" : isGetCount
            },
            success: function (data) { successCallBack(data); },
            error: function (data) { errorCallBack(data); }
		});
	};
	
	this.SetMessageRead = function(isRead, msgId, successCallBack, errorCallBack) {
		$.ajax({
            type: 'POST',
            dataType: 'json',
            url: this.contextPath + "/system/setmessageread.htm", 
            data: {
            	"messageid" : msgId,
            	"read" : isRead
            },
            success: function (data) {
            	successCallBack(data);
            },
            error: function (data) {
            	errorCallBack(data);
            }
		});
	};
	
	this.DeleteMessage = function(msgId, successCallBack, errorCallBack) {
		$.ajax({
            type: 'POST',
            dataType: 'json',
            url: this.contextPath + "/system/deletemessage.htm", 
            data: {
            	"messageid" : msgId
            },
            success: function (data) {
            	successCallBack(data);
            },
            error: function (data) {
            	errorCallBack(data);
            }
		});
	};
	
	this.SendMessage = function(receiverids, title, content, successCallBack, errorCallBack) {
		if (isNotEmptyString(receiverids) && isNotEmptyString(title)) {
			$.ajax({
	            type: 'POST',
	            dataType: 'json',
	            url: this.contextPath + "/system/savemessage.htm", 
	            data: {
	            	"receiverids" : JSON.stringify(receiverids), //JSON
	            	"title": title,
	            	"content": content
	            },
	            success: function (data) {
	            	successCallBack(data);
	            },
	            error: function (data) {
	            	errorCallBack(data);
	            }
			});
			
		}

	};
}