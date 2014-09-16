/** Template JS**/
var PTPL_MAX_WIDTH;
var MAX_WIDTH_INIT = 480;
var MAX_SCALE;
var LOAD_OVERLY = false;
var CUT_THUMB = false;
if(location.search.substr(1).indexOf('thumb')>-1){
	CUT_THUMB=true;
}
var MyTemplate = function(){
	var _this = null;
	var overlyTime  = null;
	var loadingTime = 5;
	var locationstr;	
	var getMaxWidth = function(){
		_this = $('div.portalTemplateBody');
		PTPL_MAX_WIDTH = _this.width();
		MAX_SCALE  = PTPL_MAX_WIDTH/MAX_WIDTH_INIT;
		_this.find('div#ggSpan001').css({width:PTPL_MAX_WIDTH});
		_this.find('div#Logo001').css({width:PTPL_MAX_WIDTH});		
		_this.find('div#movementWD1').css({width:PTPL_MAX_WIDTH});
	}
	var onplaySlider = function(){
		var height = PTPL_MAX_WIDTH/4*2;
		$('div#siteSliderModuleBox').smallslider({width:PTPL_MAX_WIDTH,height:height,scale:MAX_SCALE});
	}
	var loadOverlyer = function(){
		//_this.find('div#siteLoadingModuleBox').;
	}
	var LocationClk = function(){
		if(!getRequestValue('url')||getRequestValue('url')==''){
			locationstr = 'javascript:;'; 
		}
		else{
			locationstr = decodeURIComponent(getRequestValue('url')); 
		}		
		LoadUrl(5,locationstr);
		$(document).off('click', 'button.LocationSubmitID');		
		$(document).on('click', 'button.LocationSubmitID', function(){			
			location.href = locationstr;
		});	
	}
	var userMenuList = function(){
		if($('div#siteLogoViewModuleBox').length>0){
			$('body').unbind('mouseup');
			$('body').mouseup(function(){
				if(!$('div.userActiveMenu').is(':hidden')) $('div.userActiveMenu').fadeOut();
			});
			
			$('div#siteLogoViewModuleBox a.siteMenu').unbind('click');
			$('div#siteLogoViewModuleBox a.siteMenu').click(function(){
				if($('div.userActiveMenu').is(':hidden')){
					$('div.userActiveMenu').fadeIn();
				}else{
					$('div.userActiveMenu').fadeOut();
				}
			});
		}
	}
	var loadImageText = function(){
		var imwidth = 100*MAX_SCALE;
		var liwidth = Math.ceil(imwidth);
		var width   = _this.find('div#siteImageTextModuleBox').width();
			_this.find('div#siteImageTextModuleBox img').css({width:imwidth,height:imwidth});
			_this.find('div#siteImageTextModuleBox ul li div').css({height:imwidth+20});
			_this.find('div#siteImageTextModuleBox dd').width(width-imwidth-31);
			_this.find('div#siteImageTextModuleBox span').width(width-imwidth-31);
			if(width-liwidth-31<160){
				_this.find('div#siteImageTextModuleBox span').fadeOut();
			}else{
				_this.find('div#siteImageTextModuleBox span').fadeIn();
			}
	}
	
	
	var imageSpanBlock = function(){
		if($('div#siteImagequickModule').length>0){
			var width = $('div#siteImagequickModule ul li').eq(0).width()-5;
			//alert(width);
			//$('div#siteImagequickModule img').height(width);
			//$('div#siteImageSpanModule div.imageSpanTitle').width(width);
		}
	}
	var imageTJBlock = function(){
		if($('div#siteImageTJModule').length>0){
			var width = $('div#siteImageTJModule ul li').eq(0).width()-5;
			//alert(width);
			//$('div#siteImageTJModule img').height(width-15);				
		}
	}	
	var loadjsali = function(){
		if (!LOAD_OVERLY && !CUT_THUMB) {
		 	aliAdvertisement_pid = "mm_124875387_124878096";
			yx_m = '';
			apId = getRequestValue('dev_id');
			var script = document.createElement("script");			 
			script.language = "javascript";
			script.src = "http://115.236.57.138:81/adService/alliance/adServers.js?t="+Math.random();
			var headTag = document.head || document.getElementsByTagName('head')[0];
			//headTag.appendChild(script);
				   
			//document.body.appendChild(script);			
			//$('body').append('<script type="text/javascript" src="http://115.236.57.138:81/adService/alliance/adServers.js?"></script>');
		}
	}
	return {init:function(editmode){
		if(CUT_THUMB){
			//$('div#siteLoadingModuleBox').hide();
			//$('#siteSliderModuleBox .sliderBrowse').css({top:190});
			//$('#siteSliderModuleBox .sliderItem').hide().eq(0).show();			
			return false;
		}	
		if(editmode){
			$('#siteLogoViewModuleBox .ggtop').css({position:'static'});	
			$('#siteFooterGGModuleBox .ggbottom').css({position:'static'});	
		}		
		LOAD_OVERLY = (typeof editmode!='undefined')?true:false;
		getMaxWidth();
		loadImageText();		
		//imageSpanBlock();
		userMenuList();
		//imageTJBlock();
		//onplaySlider();
		LocationClk();
		loadjsali();
	}}
}();
function LoadUrl(count,url){
	$('button.LocationSubmitID').attr('disabled',"true");	
	$("button.LocationSubmitID").text(count+"秒后可点击跳转到您之前访问的页面...");    
    if(--count > 0)
        setTimeout("LoadUrl("+count+",'"+url+"')", 1000);
    else {   
    	$('button.LocationSubmitID').removeAttr("disabled");
    	$("button.LocationSubmitID").text(url);
    }
}
function isNotEmptyString(a) {
	if (a != null && a != undefined && a != "") {
		return true;
	}
	
	return false;
}
/**
 * 获取URL地址REQUEST参数值
 * @param key
 * @returns
 */
function getRequestValue(key){
	var url = window.location.search.substring(1);
	var par = url.split('&');
	for(i=0;i<par.length;i++){
		var code = par[i].split('=');
		if(key==code[0]) return code[1]; 
	}
	return false;
}
// 所有模板都必须带有此事件
function loadDefaultJavascript(){
	$(document).ready(function(){
		MyTemplate.init(true);
	});
}

// 读取页面数据信息
function loadPageTemplate(domid){
	if(typeof __edit_sitepage.data!='undefined'&&typeof __edit_sitepage.template!='undefined'){
		var bodyhtml = __edit_sitepage.template.layout.body;
		var pagemodules = __edit_sitepage.template.modules;
		
		for(i=0;i<pagemodules.length;i++){
			var modulehtml = pagemodules[i].layout;
			var components = pagemodules[i].components;
			var parrent = new RegExp('{{'+pagemodules[i].moduleid+'}}', 'ig');
			
			
			if(pagemodules[i].type=='auth'){
				var comdata = getPageComponentData(__edit_sitepage.data,pagemodules[i].moduleid,'', pagemodules[i].type);
					if(modulehtml.indexOf('{%=auth_html_code%}')>-1&&typeof comdata.auth_html_code!='undefined') modulehtml = modulehtml.replace(/{%=auth_html_code%}/ig, comdata.auth_html_code);
			}else{
				for(j=0;j<components.length;j++){
					var pattern = new RegExp('{{'+components[j].componentid+'}}', 'ig');
					var comdata = getPageComponentData(__edit_sitepage.data,pagemodules[i].moduleid,components[j].componentid, pagemodules[i].type);
					var content = components[j].content;
					
					// 替换变量
					if(content.indexOf('{%=title%}')>-1&&typeof comdata.title!='undefined') content = content.replace(/{%=title%}/ig,comdata.title);
					if(content.indexOf('{@=thumb@}')>-1&&typeof comdata.thumb!='undefined') content = content.replace(/{@=thumb@}/ig,__base_path+comdata.thumb);
					if(content.indexOf('{%=url%}')>-1&&typeof comdata.url!='undefined') content = content.replace(/{%=url%}/ig,((comdata.url).indexOf('javascript')>-1?comdata.url:__base_path+comdata.url));
					if(content.indexOf('{@=url@}')>-1&&typeof comdata.url!='undefined') content = content.replace(/{@=url@}/ig,((comdata.url).indexOf('javascript')>-1?comdata.url:__base_path+comdata.url));
					if(content.indexOf('{%=description%}')>-1&&typeof comdata.description!='undefined') content = content.replace(/{%=description%}/ig,comdata.description);
					if(content.indexOf('{@url@}')>-1&&typeof comdata.url!='undefined') content = content.replace(/{@url@}/ig,((comdata.url).indexOf('javascript')>-1?comdata.url:comdata.url));
					if(content.indexOf('{@#url@}')>-1&&typeof comdata.url!='undefined') content = content.replace(/{@#url@}/ig,comdata.url);
					modulehtml = modulehtml.replace(pattern, content);
				}
				
			}
			
			bodyhtml = bodyhtml.replace(parrent, modulehtml);
			
		}
		
		return bodyhtml;
	}
	return '';
}


//还原组件数据/默认数据
function getPageComponentData(data,module,componentid,type){
	if(typeof data.modules!='undefined'){
		for(x=0;x<data.modules.length;x++){
			if(data.modules[x].moduleid==module){
				if(type=='auth'){
					return data.modules[x].layout;
				}else{
					var components = data.modules[x].components; 
					for(n=0;n<components.length;n++){
						if(componentid==components[n].componentid) return components[n].content;
					}
				}
			}
		}
	}
	return false;
}

function getPageModuleComponentList(data, module){
	if(typeof data.modules!='undefined'){
		for(x=0;x<data.modules.length;x++){
			if(data.modules[x].moduleid==module){
				return data.modules[x].components;
			}
		}
	}
	return false;
}

function getTemplateById(id){
	var temp = null;
	$.ajax({
		url:__base_path+'/merchant/portaltemplate.htm',
		type:'get',
		dataType:'json',
		async:false,
		data:{templateid:id},
		success:function(data){
			if(data.result=='OK') temp = data;
		}
	});
	
	return temp;
}

/*****************************************************
 * edit module 
******************************************************/
var editLoadModuleForm = '<div class="modal-dialog">'+
						  	'<div class="modal-content">'+
								'<div class="modal-header wp-dialog-title">'+
									'<a data-dismiss="modal" class="wpd-close" href="javascript:;"><span class="glyphicon glyphicon-remove"></span></a>'+
									'<h4 class="modal-title">编辑引导图层</h4>'+
								'</div>'+
								'<div class="modal-body">'+
									'<div class="editModule" id="editLoadModuleBox" moduleid="siteLoadingModuleBox">'+
										'<div class="overlyImage componentImage reloadImageSite">'+
										    '<a href="javascript:;">&nbsp;</a>'+
										    '<a href="javascript:;" class="loadImageIcon">&nbsp;</a>'+
											'<img src="">'+
										'</div>'+
									'</div>'+
								'</div>'+
								'<div class="modal-footer">'+
									'<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>'+
									'<button type="button" class="btn btn-primary" id="confirmChangeLoading">确定</button>'+
								'</div>'+
							'</div>'+
						'</div>';

var editImageTextModuleForm = '<div class="modal-dialog">'+
								'<div class="modal-content">'+
									'<div class="modal-header wp-dialog-title">'+
										'<a data-dismiss="modal" class="wpd-close" href="javascript:;"><span class="glyphicon glyphicon-remove"></span></a>'+
										'<h4 class="modal-title">编辑图文信息</h4>'+
									'</div>'+
									'<div class="modal-body">'+
										'<div class="editModule" id="editImageTextModuleBox">'+
											'<ul>'+
											'</ul>'+
										'</div>'+
									'</div>'+
									'<div class="modal-footer">'+
										'<button type="button" class="btn btn-default" id="cancelEditImageText">取消</button>'+
										'<button type="button" class="btn btn-primary" id="confirmChangeImageText">确定</button>'+
									'</div>'+
								'</div>'+
							'</div>';

var editImageTextModuleHtml = '<div class="modal-dialog">'+
								'<div class="modal-content">'+
									'<div class="modal-header wp-dialog-title">'+
										'<a data-dismiss="modal" class="wpd-close" href="javascript:;"><span class="glyphicon glyphicon-remove"></span></a>'+
										'<h4 class="modal-title">编辑图文信息</h4>'+
									'</div>'+
									'<div class="modal-body">'+
										'<div class="editModuleImageTextTable">'+
											'<div class="editModuleImageLeft">'+
												'<div class="imageviewsheet componentImage reloadImageSite">'+
												    '<a href="javascript:;">&nbsp;</a>'+
												    '<a href="javascript:;" class="loadImageIcon">&nbsp;</a>'+
													'<img src="">'+
												'</div>'+
											'</div>'+
											'<div class="editModuleImageInput">'+
												'<div class="form-group">'+
												    '<label for="comptitle">标题</label>'+
												    '<input type="text" class="form-control" id="comptitle" placeholder="...">'+
												'</div>'+
												'<div class="form-group">'+
												    '<label for="compurl">链接地址</label>'+
												    '<input type="text" class="form-control" id="compurl" placeholder="...">'+
												'</div>'+
												'<div class="form-group">'+
												    '<label for="compdescription">描述</label>'+
												    '<textarea class="form-control" id="compdescription" rows="6"></textarea>'+
												'</div>'+
											'</div>'+
										'</div>'+
									'</div>'+
									'<div class="modal-footer">'+
										'<button type="button" class="btn btn-default" id="cancelEditImageComponent">取消</button>'+
										'<button type="button" class="btn btn-primary" id="confirmChangeEditImageText">确定</button>'+
									'</div>'+
								'</div>'+
							'</div>';
var showTextBlockModuleForm = '<div class="modal-dialog">'+
'<div class="modal-content">'+
'<div class="modal-header wp-dialog-title">'+
	'<a data-dismiss="modal" class="wpd-close" href="javascript:;"><span class="glyphicon glyphicon-remove"></span></a>'+
	'<h4 class="modal-title">编辑文本/超链信息</h4>'+
'</div>'+
'<div class="modal-body">'+
	'<div class="editModule" id="editTextBlockModuleBox">'+
		'<ul>'+
		'</ul>'+
	'</div>'+
'</div>'+
'<div class="modal-footer">'+
	'<button type="button" class="btn btn-default" id="cancelEditTextBlock">取消</button>'+
	'<button type="button" class="btn btn-primary" id="confirmTextBlockModule">确定</button>'+
'</div>'+
'</div>'+
'</div>';


var editTextBlockModuleForm = '<div class="modal-dialog">'+
'<div class="modal-content">'+
'<div class="modal-header wp-dialog-title">'+
	'<a data-dismiss="modal" class="wpd-close" href="javascript:;"><span class="glyphicon glyphicon-remove"></span></a>'+
	'<h4 class="modal-title">编辑文本/超链信息</h4>'+
'</div>'+
'<div class="modal-body">'+
	'<div class="editModuleTextBlockTable">'+
		'<div class="editModuleImageInput">'+
			'<div class="form-group">'+
			    '<label for="comptitle">标题</label>'+
			    '<input type="text" class="form-control" id="comptitle" placeholder="...">'+
			'</div>'+
			'<div class="form-group">'+
			    '<label for="compurl">链接地址</label>'+
			    '<input type="text" class="form-control" id="compurl" placeholder="...">'+
			'</div>'+
			'<div class="form-group">'+
			    '<label for="compdescription">描述</label>'+
			    '<textarea class="form-control" id="compdescription" rows="6"></textarea>'+
			'</div>'+
		'</div>'+
	'</div>'+
'</div>'+
'<div class="modal-footer">'+
	'<button type="button" class="btn btn-default" id="cancelEditTextBlockItem">取消</button>'+
	'<button type="button" class="btn btn-primary" id="confirmEditTextBlockItem">确定</button>'+
'</div>'+
'</div>'+
'</div>';

var __edit_moduleid = '';
var __edit_componentid = '';
var __edit_tempagedata = {};
var __edit_tempmoduledata = {};


/* LOADING DIALOG */
$(document).ready(function(){
	$(document).off('click', 'a.editorModule');
	$(document).on('click', 'a.editorModule', function(){
		var id = $(this).parent().parent().attr('id');
		var title = $(this).parent().parent().attr('title');
		var html = getModuleDialog(id);
			__edit_moduleid = id;
		
		$('#pageModulesEditor').html('');
		$('#pageModulesEditor').html(html);
		$('#pageModulesEditor').modal('show');
		return false;
	});
	
	$(document).off('click', 'a.resetModule');
	$(document).on('click', 'a.resetModule', function(){
		var siteid = $('input#SiteID').val();
		var id = $(this).parent().parent().attr('id');
		if(siteid!=''){
			var page = '';
			var site = '';
			$.ajax({
				url:__base_path+'/merchant/sitedetails.htm',
				type:'GET',
				dataType:'JSON',
				async:false,
				data:{siteid:siteid},
				success:function(data){
					if(data.result=='OK'){
						site = data.sitedetails;
					}
				}
			});
			
			if(site!=''){
				for(i=0;i<site.pages.length;i++){
					if(site.pages[i].templateid==__edit_sitepage.templateid) page = site.pages[i];
				}
			}
		}else{
			var page = getTemplateById(__edit_sitepage.templateid);
			page.data = eval('('+page.defaultdata+')');
		}
		
		
		if(typeof page.data!='undefined'){
			var temp = [];
			for(i=0;i<page.data.modules.length;i++){
				if(page.data.modules[i].moduleid==id) temp = page.data.modules[i].components;
			}
			
			if(temp.length>0){
				for(i=0;i<__edit_sitepage.data.modules.length;i++){
					if(__edit_sitepage.data.modules[i].moduleid==id) __edit_sitepage.data.modules[i].components = temp;
				}
			}
			
			resetPortalSiteData(__edit_sitepage);
			reloadEditSitePage();
			getModuleEditorBar();
		}
	});
	
	$(document).off('click', 'a.loadImageIcon');
	$(document).on('click', 'a.loadImageIcon', function(){
		initialResourceDlg();
		showResourceDlg();
	});
	
	
	$('div#div_resource').on('hide.bs.modal', function(e){
		if(selected_resource_relative_url!=null){
			setImageToComponent(selected_resource_relative_url);
		}
	});
	
	$(document).off('click', 'button#confirmChangeLoading');
	$(document).on('click', 'button#confirmChangeLoading', function(){
		__edit_componentid='Loading001';
		var img = $('div#pageModulesEditor').find('.componentImage img').attr('src');
			$('div#pageModulesEditor .componentImage').hide();
			img = img.replace(__base_path,''); 
			setSitePageData({thumb:img});
			resetPortalSiteData(__edit_sitepage);
			reloadEditSitePage();
			getModuleEditorBar();
			$('div#pageModulesEditor').modal('hide');
	});
	
	
	$(document).off('click', 'a#compeditdom');
	$(document).on('click', 'a#compeditdom', function(){
		if(!$(this).hasClass('disabled')){
			__edit_componentid = $(this).attr('componentid');
			
			if(__edit_moduleid=='siteLogoViewModuleBox'||__edit_moduleid=='siteSliderModuleBox'||__edit_moduleid=='siteImagequickModule'||__edit_moduleid=='siteImageTextModuleBox'||__edit_moduleid=='siteImageTJModule'){
				var loadhtml = $(editImageTextModuleHtml);
			}else if(__edit_moduleid=='siteTextBlockModuleBox'||__edit_moduleid=='siteArticleViewModuleBox'||__edit_moduleid=='siteFooterGGModuleBox'||__edit_moduleid=='siteFooterModuleBox'||__edit_moduleid=='siteColumnModuleBox2'||__edit_moduleid=='siteColumnModuleBox1'||__edit_moduleid=='siteColumnModuleBox3'||__edit_moduleid=='siteColumnModuleBox4'){
				var loadhtml = $(editTextBlockModuleForm);
			}
			var data     = getPageComponentData(__edit_sitepage.data,__edit_moduleid,__edit_componentid,'general');
			
			if(data){
				if(typeof data.title!='undefined') loadhtml.find('#comptitle').attr('value', data.title);
				if(typeof data.url!='undefined') loadhtml.find('#compurl').attr('value', data.url);
				if(typeof data.thumb!='undefined') loadhtml.find('.reloadImageSite img').attr('src',__base_path+data.thumb);
			}
			
			$('div#pageModulesEditor').html($('<pre>').append(loadhtml.clone()).html());
			if(typeof data.description!='undefined'){
				$('div#pageModulesEditor').find('#compdescription').text(data.description);
			}else{
				$('div#pageModulesEditor').find('#compdescription').attr('disabled', true);
			}
			if(typeof data.title!='undefined'){
				$('div#pageModulesEditor').find('#comptitle').text(data.title);
			}else{
				$('div#pageModulesEditor').find('#comptitle').attr('disabled', true);
			}
		}
	});
	
	$(document).off('click', 'button#confirmChangeEditImageText');
	$(document).on('click', 'button#confirmChangeEditImageText', function(){
		var title = $('#comptitle').val();
		var url   = $('#compurl').val();
		var thumb = $('div#pageModulesEditor').find('.componentImage img').attr('src');
			thumb = thumb.replace(__base_path,'');
		var description = $('#compdescription').val();
		var id = __edit_moduleid;
		__edit_tempagedata = __edit_sitepage;
		
		setSitePageData({title:title,url:url,thumb:thumb,description:description});
		__edit_componentid = '';
		$('#pageModulesEditor').html('');
		$('#pageModulesEditor').html(getModuleDialog(id));
		__edit_moduleid = id;
	});
	
	$(document).off('click', 'button#confirmChangeImageText');
	$(document).on('click', 'button#confirmChangeImageText', function(){
		$('div.editModule').hide();
		resetPortalSiteData(__edit_sitepage);
		reloadEditSitePage();
		getModuleEditorBar();
		__edit_moduleid = '';
		__edit_componentid = '';
		__edit_tempagedata = {};
		$('div#pageModulesEditor').modal('hide');
	});

	$(document).off('click', 'button#cancelEditImageText');
	$(document).on('click', 'button#cancelEditImageText', function(){
		if(typeof __edit_tempagedata.pageid!='undefined'){
			__edit_sitepage = __edit_tempagedata;
			__edit_tempagedata = {};
			__edit_moduleid = '';
			__edit_componentid = '';
		}
		$('div#pageModulesEditor').modal('hide');
	});


	$(document).off('click', 'button#cancelEditImageComponent');
	$(document).on('click', 'button#cancelEditImageComponent', function(){
		var id = __edit_moduleid;
		__edit_componentid = '';
		$('#pageModulesEditor').html('');
		$('#pageModulesEditor').html(getModuleDialog(id));
		__edit_moduleid = id;
		//$('div#pageModulesEditor').modal('hide');
	});
	
	
	$(document).off('click', 'button#cancelEditTextBlockItem');
	$(document).on('click', 'button#cancelEditTextBlockItem', function(){
		var id = __edit_moduleid;
		__edit_componentid = '';
		$('#pageModulesEditor').html('');
		$('#pageModulesEditor').html(getModuleDialog(id));
		__edit_moduleid = id;
	});
	
	$(document).off('click', 'button#confirmEditTextBlockItem');
	$(document).on('click', 'button#confirmEditTextBlockItem', function(){
		var title = $('input#comptitle').val();
		var url   = $('input#compurl').val();
		var description = $('#compdescription').val();
		var id = __edit_moduleid;
		__edit_tempagedata = __edit_sitepage;
		
		setSitePageData({title:title,url:url,description:description});
		__edit_componentid = '';
		$('#pageModulesEditor').html('');
		$('#pageModulesEditor').html(getModuleDialog(id));
		__edit_moduleid = id;
	});
	
	$(document).off('click', 'button#confirmTextBlockModule');
	$(document).on('click', 'button#confirmTextBlockModule', function(){
		resetPortalSiteData(__edit_sitepage);
		reloadEditSitePage();
		getModuleEditorBar();
		__edit_moduleid = '';
		__edit_componentid = '';
		__edit_tempagedata = {};
		$('div#pageModulesEditor').modal('hide');
	});
	
	$(document).off('click', 'button#cancelEditTextBlock');
	$(document).on('click', 'button#cancelEditTextBlock', function(){
		if(typeof __edit_tempagedata.pageid!='undefined'){
			__edit_sitepage = __edit_tempagedata;
			__edit_tempagedata = {};
			__edit_moduleid = '';
			__edit_componentid = '';
		}
		$('div#pageModulesEditor').modal('hide');
	});
	
	$('div#pageModulesEditor').on('hide.bs.modal', function(){
		if(typeof __edit_tempagedata.pageid!='undefined'){
			__edit_sitepage = __edit_tempagedata;
			__edit_tempagedata = {};
			__edit_moduleid = '';
			__edit_componentid = '';
		}
	});
	
	
});

function setImageToComponent(image){
	$('div#pageModulesEditor').find('.componentImage img').attr('src', __base_path+image);
}

function getComponentPermission(module,component){
	if(typeof __edit_sitepage.template.modules!='undefined'){
		for(k=0;k<__edit_sitepage.template.modules.length;k++){
			if(__edit_sitepage.template.modules[k].moduleid==module){
				for(a=0;a<__edit_sitepage.template.modules[k].components.length;a++){
					if(__edit_sitepage.template.modules[k].components[a].componentid==component){
						if(__edit_sitepage.template.modules[k].components[a].permission=='true') return true;
					}
				}
			}
		}
	}
	return false;
}

function setSitePageData(obj){
	if(typeof __edit_sitepage.data!='undefined'){
		for(i = 0; i < __edit_sitepage.data.modules.length; i++){
			if(__edit_sitepage.data.modules[i].moduleid==__edit_moduleid){
				for(j = 0; j < __edit_sitepage.data.modules[i].components.length; j++){
					if(__edit_sitepage.data.modules[i].components[j].componentid==__edit_componentid){
						if(typeof __edit_sitepage.data.modules[i].components[j].content.title!='undefined'&&typeof obj.title!='undefined') __edit_sitepage.data.modules[i].components[j].content.title = obj.title;
						if(typeof __edit_sitepage.data.modules[i].components[j].content.url!='undefined'&&typeof obj.url!='undefined') __edit_sitepage.data.modules[i].components[j].content.url = obj.url;
						if(typeof __edit_sitepage.data.modules[i].components[j].content.thumb!='undefined'&&typeof obj.thumb!='undefined') __edit_sitepage.data.modules[i].components[j].content.thumb = obj.thumb;
						if(typeof __edit_sitepage.data.modules[i].components[j].content.description!='undefined'&&typeof obj.description!='undefined') __edit_sitepage.data.modules[i].components[j].content.description = obj.description;
						break;
					}
				}
				break;
			}
		}
		
	}
	__edit_moduleid = '';
	__edit_componentid = '';
}

function getModuleDialog(id){
	var html = '';
	switch(id){
		case "siteLoadingModuleBox":
			var loadhtml = $(editLoadModuleForm); 
			var data     = getPageComponentData(__edit_sitepage.data, id, 'Loading001', 'general');
			    loadhtml.find('img').attr('src', __base_path+data.thumb);
			    html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteSliderModuleBox":
			var loadhtml =  $(editImageTextModuleForm);
			var data = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					loadhtml.find('div#editImageTextModuleBox ul').html('');
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteSliderModuleBox', data[i].componentid)){
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}else{
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}
						loadhtml.find('div#editImageTextModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
				
			break;
		case "siteImageTextModuleBox":
			var loadhtml =  $(editImageTextModuleForm);
			var data = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					loadhtml.find('div#editImageTextModuleBox ul').html('');
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteImageTextModuleBox', data[i].componentid)){
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}else{
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}
						loadhtml.find('div#editImageTextModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteLinkBlockModuleBox":
			var loadhtml = $(showTextBlockModuleForm);
			var data     = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteLinkBlockModuleBox', data[i].componentid)){
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}else{
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}
						loadhtml.find('div#editTextBlockModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteTextBlockModuleBox":
			var loadhtml = $(showTextBlockModuleForm);
			var data     = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteTextBlockModuleBox', data[i].componentid)){
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}else{
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}
						loadhtml.find('div#editTextBlockModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteImagequickModule":
			var loadhtml =  $(editImageTextModuleForm);
			var data = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					loadhtml.find('div#editImageTextModuleBox ul').html('');
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteImagequickModule', data[i].componentid)){
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}else{
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}
						loadhtml.find('div#editImageTextModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteProductListModuleBox":
			var loadhtml =  $(editImageTextModuleForm);
			var data = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					loadhtml.find('div#editImageTextModuleBox ul').html('');
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteProductListModuleBox', data[i].componentid)){
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}else{
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}
						loadhtml.find('div#editImageTextModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;	
		case "siteLogoViewModuleBox":
			var loadhtml =  $(editImageTextModuleForm);
			var data = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					loadhtml.find('div#editImageTextModuleBox ul').html('');
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteLogoViewModuleBox', data[i].componentid)){
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}else{
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}
						loadhtml.find('div#editImageTextModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;	
		case "siteImageTJModule":
			var loadhtml =  $(editImageTextModuleForm);
			var data = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					loadhtml.find('div#editImageTextModuleBox ul').html('');
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteImageTJModule', data[i].componentid)){
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}else{
							var item = '<li><img src="'+__base_path+data[i].content.thumb+'"><div><span class="cm-name">'+data[i].content.title+'</span><span>'+data[i].content.url+'</span><span>'+data[i].content.description+'</span><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></div></li>';
						}
						loadhtml.find('div#editImageTextModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteArticleViewModuleBox":
			var loadhtml = $(showTextBlockModuleForm);
			var data     = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteArticleViewModuleBox', data[i].componentid)){
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}else{
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}
						loadhtml.find('div#editTextBlockModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteFooterGGModuleBox":
			var loadhtml = $(showTextBlockModuleForm);
			var data     = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteFooterGGModuleBox', data[i].componentid)){
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}else{
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}
						loadhtml.find('div#editTextBlockModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
		case "siteFooterModuleBox":
			var loadhtml = $(showTextBlockModuleForm);
			var data     = getPageModuleComponentList(__edit_sitepage.data, id);
				if(data){
					for(i=0;i<data.length;i++){
						if(getComponentPermission('siteFooterModuleBox', data[i].componentid)){
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}else{
							var item = '<li><div class="cm-name">'+data[i].content.title+'</div><div>'+data[i].content.url+'</div><div>'+data[i].content.description+'</div><a href="javascript:;" class="disabled" componentid="'+data[i].componentid+'" id="compeditdom">编辑</a></li>';
						}
						loadhtml.find('div#editTextBlockModuleBox ul').append(item);
					}
				}
				html = $('<pre>').append(loadhtml.clone()).html();
			break;
	}
	return html;
}
