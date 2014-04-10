<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.attachment" bundle="${file}"/></title>
	<script>
	$.ajaxSetup({cache:false});
	var accessDeniedMsg = '<fmt:message key="common.error.401"/>';
	var columns = ["name","size","createTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	var idPaths = '${param["search_EQ_folder.id"]}'.split('/');
	var setting = {
			async: {
				enable: true,
				url:"${ctx}/file/folder/treejson",
				autoParam:["id","name=name"],
				type:"get"
			},
			callback:{onClick:folderTreeOnClick, onAsyncSuccess: folderOnAsyncSuccess}

		};
	function folderOnAsyncSuccess(event, treeId, treeNode, msg) {
		var tree_folder = $.fn.zTree.getZTreeObj("tree_folder");
		lk_expandAjaxTreeNode(treeNode,idPaths,tree_folder);
	};
	

	var parentId;
	

	var paginationList;
	var ztree ;

	
	function appendFolder(id,name){
		$.treebreadcrumb("#testbreadcrumb").linkNode(id,name);
	};
		
	
	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				if(row["fileBaseType"] == "Folder"){
					var str = '<i class="lk-filetype lk-file-folder"></i>';
					str += '<span class="lk-row-bar pull-right" oid="'+row['id']+'" oname="'+row[column]+'"></span>'+'<span  class="list-subject"><a href="#" onclick="appendFolder(\''+row['id']+'\',\''+row[column]+'\')" title="'+row[column]+'">'+row[column]+'</a></span>';
					return str;
				}else{
					var filtype = lkFileType[row['type']];
					if(!filtype){
						filtype = "lk-file-file";
					}
					var str = '<i class="lk-filetype '+filtype+'"></i>';
					str += '<span class="lk-row-bar pull-right" oid="'+row['id']+'" oname="'+row[column]+'"></span>'+'<span  class="list-subject"><a href="${ctx}/file/attachment/download/'+row['id']+'" title="'+row[column]+'">'+row[column]+'</a></span>';
					return str;
				}
				
			}else{
				return " ";
			}
		}

  		if(column == 'userid'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'createTime'){
			if(row[column]){
				return $.format.longDate(new Date(row[column]));
			}else{
				return " ";
			}
		}

  		if(column == 'lastModifyTime'){
			if(row[column]){
				return $.format.longDate(new Date(row[column]));
			}else{
				return " ";
			}
		}

  		if(column == 'type'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'systemCode'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'size'){
			if(row[column]){
				return readablizeBytes(row[column]);
			}else{
				return " ";
			}
		}

  		if(column == 'objectId'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'key'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'param1'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'param2'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'attFileId'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'companyId'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'deleted'){
			if(row[column]){
				return '<fmt:message key="common.form.boolean.yes"/>';
			}else{
				return "<fmt:message key="common.form.boolean.no"/>";
			}
		}

		

		return row[column];
	}
	
	var download_file = new Object();
	function downloadSelected(){
  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						if(typeof(download_file.iframe)== "undefined")
						{
						var iframe = document.createElement("iframe");
						download_file.iframe = iframe;
						document.body.appendChild(download_file.iframe); 
						}
						// alert(download_file.iframe);
						download_file.iframe.src = "${ctx}/file/attachment/download/"+ids;

						download_file.iframe.style.display = "none";

						return;
					}
				}
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');

	}
	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/fileBase/disableAll",{ids:ids},function (data, textStatus){
							if(data.status == 'error'){
								$().toastmessage('showNoticeToast', data.message);
							}else{
								$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
								$.paginationList("#list").refreshData();
							}
						});
						return;
					}
				}
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
			  }
			});
	}
	function removeSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/fileBase/deleteAll",{ids:ids},function (data, textStatus){
							if(data.status == 'error'){
								$().toastmessage('showNoticeToast', data.message);
							}else{
								$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
								$.paginationList("#list").refreshData();
							}
						});
						return;
					}
				}
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
			  }
			});
	}
	function clearTrash(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				  var parentid = $("div.conditionPanel input[name='search_EQ_parent.id']:first").val();
				  var owner = $("div.conditionPanel").find("input[name='search_EQ_owner']:first").val();
				  
				  var url = "${ctx}/file/fileBase/clear?";
				  if(owner){
					  url += "o="+owner+"&";
				  }
				  if(parentid){
					  url += "p="+parentid;
				  }
				  $.get(url,{},function (data, textStatus){
						if(data.status == 'error'){
							$().toastmessage('showNoticeToast', data.message);
						}else{
							$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
							$.paginationList("#list").refreshData();
						}
					});
			  }
			});		
	}

	$(document).ready(function() {

			var pagerSelector = '<select class="pagesize input-small"> <option selected="selected" value="500">500</option> <option value="1000">1000</option> <option value="3000">3000</option> <option value="5000">5000</option> </select>';			

				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:false,
			useSelectedPanel:true,pagerSelector:pagerSelector,//isCheckSelect:false,
				ajaxUrl: '${ctx}/file/fileBase/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
						{name:"name",label:"<fmt:message key="entity.attachment.name" bundle="${file}"/>"}
						,
						{name:"size",label:"<fmt:message key="entity.attachment.size" bundle="${file}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.attachment.createTime" bundle="${file}"/>"}
					
						
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
				paginationList.bind("removeSelected",function(event,propName,value,label){

				     ztree.cancelSelectedNode();
				    
			});
				
				 $("#testbreadcrumb").treebreadcrumb().bind("nodeclick.treebreadcrumb",function(e,oid,oname,heararchyid,index){
					 $.paginationList("#list").addSelectedCondition("search_EQ_parent.id",oname,oid);
					 parentId =oid;
					 waitForAuthCheck();
					 if(isNeedAuth()){
					    	$.ajax({
					            cache: false,
					            type: "GET",
					            url:"${ctx}/file/filePermission/permit",
					            data:"id="+parentId,
					            async: true,
					            error: function(request) {
					               
					                $().toastmessage('showNoticeToast', '<fmt:message key="common.error.unknown"/>');
					            },
					            success: function(data) {
					            	if(data.status == "success" && data.result == true){
					            		authCheckOk();
					            	}else{
					            		 //$().toastmessage('showNoticeToast', accessDeniedMsg);
					            	}
					            }
					        });
						}else{
							authCheckOk();
						}
				 });
				 $.treebreadcrumb("#testbreadcrumb").changeRoot("<fmt:message key="entity.fileBase.oper.myfile" bundle="${file}"/>");
				 $("#upload-container").dialog({title:"<fmt:message key="entity.attachment.upload" bundle="${file}"/>...",
				        autoOpen: false,
				        width: 620,height:600,
				        modal: true,
				        buttons: buttons
				    });
				 $("#createFolder").dialog({title:"<fmt:message key="common.form.edit"/>...",
				        autoOpen: false,
				        width: 550,height:300,
				        modal: true,
				        buttons: createFolderButtons
				    });
					$("#folderInputForm").validate({
						submitHandler : function(form) { 
							saveFolder();
							 }  
					});
					$("#list table.tablesorter").delegate("tr","mouseenter",function(){
						
						var bar = $(this).find("span.lk-row-bar");
						if(!bar.attr("init")){
							var oid = bar.attr("oid");
							var oname = bar.attr("oname");
							var data = {"id":oid,"name":oname};
							var content = tmpl("template-oper-bar",data);
							bar.html(content);
							bar.attr("init","true");
						}
						bar.show();
					}).delegate("tr","mouseleave",function(){
						var bar = $(this).find("span.lk-row-bar");
						bar.hide();
					});
					ztree = $.fn.zTree.init($("#movetree"), setting);
				$("#move").dialog({title:"<fmt:message key="entity.fileBase.oper.move" bundle="${file}"/>...",
			        autoOpen: false,
			        width: 550,height:300,
			        modal: true,
			        buttons: moveButtons
			    });
				$("#deletedOperBaar").hide();
				$('#search_LIKE_name').on('input propertychange', function() {
					if(inputTimeOut){
						clearTimeout(inputTimeOut);
					}
					inputTimeOut = setTimeout(refreshTableData,500);
					}); 
				 $("#search_LIKE_name").inputClear();
				 createTableColumnPseudoClasses();
	});
	function createTableColumnPseudoClasses() {
		 
	    $("#list tr").each( function()  {
	        var counter = 1;
	        $(this).children("td,th").each( function()  {
	            $(this).addClass("list-column-" + counter);
	            counter++;
	        });
	    });
	}
	var inputTimeOut;
	function refreshTableData(){
		$.paginationList("#list").refreshData();
	}
	var setting = {
			view: {
				selectedMulti: false
			},
			check: {
				enable: true,
				chkboxType : { "Y" : "", "N" : "" },
				chkStyle:"radio"
			},

			async: {
				enable: true,
				url:"${ctx}/file/folder/treejson",
				autoParam:["id","name=name"],
				type:"get"
			},
			callback:{onClick:folderTreeOnClick, onCheck:folderTreeOnClick,onAsyncSuccess: folderOnAsyncSuccess}

		};
	function folderOnAsyncSuccess(event, treeId, treeNode, msg) {
		var tree_folder = $.fn.zTree.getZTreeObj("movetree");
		lk_expandAjaxTreeNode(treeNode,idPaths,tree_folder);
	};
	var tobeMoveId;
	var tobeMoveName;
	var dialogMsg = [<fmt:message key="common.form.dialog.messages"/>];
	var moveButtons = {};
	moveButtons['<fmt:message key="entity.fileBase.oper.movetoroot" bundle="${file}"/>'] = function () {
		folderTreeOnClick(null,null,{id:"",name:""});
    };
    moveButtons[dialogMsg[3]] = function () {
        $(this).dialog("close");
    };
	
	var buttons = {};

	if(dialogMsg[3]){
		buttons[dialogMsg[3]] = function () {
            $(this).dialog("close");
        };
	    
	}else{
		buttons["Cancel"] = function () {
            $(this).dialog("close");
        };
	}
	var createFolderButtons = {};
	if(dialogMsg[2]){
		createFolderButtons[dialogMsg[2]] = createFolderOkFunction;
	    
	}else{
		createFolderButtons["OK"] = createFolderOkFunction;
	}
	if(dialogMsg[3]){
		createFolderButtons[dialogMsg[3]] = function () {
            $(this).dialog("close");
        };
	    
	}else{
		createFolderButtons["Cancel"] = function () {
            $(this).dialog("close");
        };
	}

	function createFolderOkFunction() {
    	if(!$("#folderInputForm").valid()){
    		return;
    	}
    	saveFolder();
     
    }

	function folderTreeOnClick(event, treeId, treeNode) {
    	$.ajax({
            cache: false,
            type: "GET",
            url:"${ctx}/file/fileBase/move",
            data:"id="+tobeMoveId+"&toid="+treeNode.id,
            async: true,
            error: function(request) {
               
                $().toastmessage('showNoticeToast', '<fmt:message key="common.error.unknown"/>');
            },
            success: function(data) {
            	$().toastmessage('showNoticeToast', '<fmt:message key="core.update.success"/>');
            	$.paginationList("#list").refreshData();
            	$("#move").dialog( "close" );
            }
        });

	}
	function inArray(source, target){
		for(var i=0; i<   source.length;i++){
			var obj = source[i];
			if(target.contains(obj)){
				return true;
			}
		}
		return false;
	}

	function saveFolder(){
		var userOrgs = <tags:userOrgs/>;
		var editors = $("#editorsId").val().split(";");
		var execute = false;
		if(isNeedAuth() && !inArray(userOrgs, editors)){
			$("#createFolder").dialog( "close" );
			bootbox.confirm("<fmt:message key="entity.fileBase.authmessage" bundle="${file}"/>", 
				function(data){
				if(data){
					executeSaveFolder();
				}else{
					$("#createFolder").dialog( "open" );
				}
			});

		}else{
			executeSaveFolder();
		}
	}
	function executeSaveFolder(){
    	$.ajax({
            cache: false,
            type: "GET",
            url:$("#folderInputForm").attr("action"),
            data:$('#folderInputForm').serialize(),
            async: true,
            error: function(request) {
               
                $().toastmessage('showNoticeToast', '<fmt:message key="common.error.unknown"/>');
            },
            success: function(data) {
            	$().toastmessage('showNoticeToast', '<fmt:message key="core.update.success"/>');
            	$.paginationList("#list").refreshData();
            	$("#createFolder").dialog( "close" );
            }
        });
		
	}
	function createFolder(){
		$("#folderInputForm").attr("action","${ctx}/file/folder/save");
		$("#createFolderParentId").val(parentId);
		$("#createFolderOwner").val($("#conditionOwner").val());
		if(isNeedAuth()){
			$("#folderAuthArea").show();
			if(parentId && parentId != ''){
		    	$.ajax({
		            cache: false,
		            type: "GET",
		            url:"${ctx}/file/filePermission/perms",
		            data:"id="+parentId,
		            async: true,
		            error: function(request) {
		               
		                $().toastmessage('showNoticeToast', '<fmt:message key="common.error.unknown"/>');
		            },
		            success: function(data) {
		            	$("#editorsId").val(data.editor.ids);
		            	$("#editorsLabel").val(data.editor.names);
		            	$("#readersId").val(data.reader.ids);
		            	$("#readersLabel").val(data.reader.names);
		            	$("#createFolder").dialog( "open" );
		            }
		        });
			}else{
				$("#createFolder").dialog("open");
			}
		}else{
			$("#folderAuthArea").hide();
			$("#createFolder").dialog("open");
		}
		
	}
	function rename(obj){
		var bar = $(obj).closest("span.lk-row-bar");
		var oid = bar.attr("oid");
		var oname = bar.attr("oname");
		$("#folderInputForm").attr("action","${ctx}/file/fileBase/rename");
		$("#editFolderId").val(oid);
		$("#editFolderName").val(oname);
		$("#createFolderParentId").val("");
		if(isNeedAuth()){
			$("#folderAuthArea").show();
	    	$.ajax({
	            cache: false,
	            type: "GET",
	            url:"${ctx}/file/filePermission/perms",
	            data:"id="+oid,
	            async: true,
	            error: function(request) {
	               
	                $().toastmessage('showNoticeToast', '<fmt:message key="common.error.unknown"/>');
	            },
	            success: function(data) {
	            	$("#editorsId").val(data.editor.ids);
	            	$("#editorsLabel").val(data.editor.names);
	            	$("#readersId").val(data.reader.ids);
	            	$("#readersLabel").val(data.reader.names);
	            	$("#createFolder").dialog( "open" );
	            }
	        });

		}else{
			$("#folderAuthArea").hide();
			$("#createFolder").dialog("open");
		}
		
	}
	function move(obj){
    	var zTree = $.fn.zTree.getZTreeObj("movetree");
    	zTree.setting.async.url="${ctx}/file/folder/treejson?o="+$("#conditionOwner").val();
        zTree.reAsyncChildNodes(null, "refresh");

		var bar = $(obj).closest("span.lk-row-bar");
		tobeMoveId = bar.attr("oid");
		$("#move").dialog("open");
	}
	function switchMyFile(obj){
		
		if(!($(obj).closest("li").hasClass("active"))){
			$("#side-nav-bar>li").each(function(index){
				if(index == 1){
					$(this).addClass("active");										
				}else{
					$(this).removeClass("active");					
				}
			});
			$("#conditionDeleted").val("false");
			$("#deletedOperBaar").hide();
			$.treebreadcrumb("#testbreadcrumb").changeRoot("<fmt:message key="entity.fileBase.oper.myfile" bundle="${file}"/>");
			$.treebreadcrumb("#testbreadcrumb").activeRoot();
			$("#conditionOwner").val("");
			$("#usedOperBar").show();
		}
	}
	function switchMyTrash(obj){
		if(!($(obj).closest("li").hasClass("active"))){
			$("#side-nav-bar>li").each(function(index){
				if(index == 2){
					$(this).addClass("active");										
				}else{
					$(this).removeClass("active");					
				}
			});
			$("#conditionDeleted").val("true");
			$("#conditionOwner").val("");
			$.treebreadcrumb("#testbreadcrumb").changeRoot("<fmt:message key="entity.fileBase.oper.mytrash" bundle="${file}"/>");
			$.treebreadcrumb("#testbreadcrumb").activeRoot();
			$("#usedOperBar").hide();
			$("#deletedOperBaar").show();
		}
		
	}
	function switchComFile(obj){
		
		if(!($(obj).closest("li").hasClass("active"))){
			$("#side-nav-bar>li").each(function(index){
				if(index == 3){
					$(this).addClass("active");										
				}else{
					$(this).removeClass("active");					
				}
			});
			$("#conditionDeleted").val("false");
			$("#conditionOwner").val("<tags:userCompanyId />");
			$("#deletedOperBaar").hide();
			$.treebreadcrumb("#testbreadcrumb").changeRoot("<fmt:message key="entity.fileBase.oper.companyfile" bundle="${file}"/>");
			$.treebreadcrumb("#testbreadcrumb").activeRoot();
			waitForAuthCheck();
			<shiro:hasAnyRoles name="admin,fileadmin">
			 authCheckOk();
			</shiro:hasAnyRoles>
		}
		
	}
	function switchComTrash(obj){
		if(!($(obj).closest("li").hasClass("active"))){
			$("#side-nav-bar>li").each(function(index){
				if(index == 4){
					$(this).addClass("active");										
				}else{
					$(this).removeClass("active");					
				}
			});
			$("#conditionDeleted").val("true");
			$("#conditionOwner").val("<tags:userCompanyId />");
			$("#usedOperBar").hide();
			<shiro:hasAnyRoles name="admin,fileadmin">
			$("#deletedOperBaar").show();
			</shiro:hasAnyRoles>
			$.treebreadcrumb("#testbreadcrumb").changeRoot("<fmt:message key="entity.fileBase.oper.companytrash" bundle="${file}"/>");
			$.treebreadcrumb("#testbreadcrumb").activeRoot();
		}
		
	}
	function isNeedAuth(){
		return $("#conditionOwner").val() != '' && $("#conditionOwner").val() == '<tags:userCompanyId />';
	}
	function waitForAuthCheck(){
		$("#usedOperBar").hide();
		 $('#fileupload').fileupload('disable');
		 $("#upload-container").addClass("accessDenied");
	}
	function authCheckOk(){
		$("#usedOperBar").show();
		 $('#fileupload').fileupload('enable');
		 $("#upload-container").removeClass("accessDenied");
	}

	</script>
	<link href="${ctx}/static/fileupload/jquery.fileupload.css" rel="stylesheet">
	<style>
	#upload-container{
		background: url(${ctx}/static/styles/default/images/drapmsg.png) no-repeat center;
	}
	.accessDenied{
	background: url(${ctx }/static/images/401.jpg) no-repeat center !important
	}
	#list table .list-column-1 {
        width: 50px; 
    }
 
    #list table .list-column-2 {
        width: auto;
    }
 
    #list table .list-column-3 {
        width: 100px;
    }
    #list table .list-column-4 {
        width: 150px;
    }
	</style>
</head>

<body>
<fieldset>
	<legend><small>	<fmt:message key="entity.attachment" bundle="${file}"/>
</small></legend>

<div class="row">
	<div class="span2">
		<div >
			<ul class="nav nav-pills nav-stacked" id="side-nav-bar">
			<li><a href="#" onclick="$('#upload-container').dialog('open');"><i class="icon-upload"></i>
			<fmt:message key="entity.attachment.upload" bundle="${file}"/>...</a> </li>
			<li class="active" ><a href="#" onclick="switchMyFile(this);"><i class="icon-user"></i>
			<fmt:message key="entity.fileBase.oper.myfile" bundle="${file}"/></a> </li>
			<li><a href="#" onclick="switchMyTrash(this);"><i class="icon-trash"></i>
			<fmt:message key="entity.fileBase.oper.mytrash" bundle="${file}"/></a> </li>
			<shiro:hasAnyRoles name="orgadmin,orguser">
				<li><a href="#" onclick="switchComFile(this);"><i class="icon-folder-close"></i>
				<fmt:message key="entity.fileBase.oper.companyfile" bundle="${file}"/></a> </li>
				<li><a href="#" onclick="switchComTrash(this);"><i class="icon-trash"></i>
				<fmt:message key="entity.fileBase.oper.companytrash" bundle="${file}"/></a> </li>
				
			</shiro:hasAnyRoles>
			</ul>
	       
	     </div>
	
	</div>
	<div class="span10">

	<c:if test="${not empty message}">
		<script>$().toastmessage('showNoticeToast', '${message}');</script>
	</c:if>

	  <div class="tab-content">
	    <div class="tab-pane active" id="tab1">
	         <!-- The file upload form used as target for the file upload widget -->
	    </div>
	    <div class="tab-pane active" id="tab2">
		<div id="list">
			<div class="conditionPanel pull-right">
			<input type="hidden" id="conditionDeleted" name="search_EQ_deleted" value="false"/>
			<input type="hidden" id="conditionOwner" name="search_EQ_owner" value=""/>
			<span id="usedOperBar">
			
			<button type="button" class="btn btn-primary" id="create_btn" onclick="createFolder();"><fmt:message key="common.form.create"/><fmt:message key="entity.folder" bundle="${file}"/></button>
			<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
			<button type="button" class="btn btn-primary" id="download_btn" onclick="downloadSelected();"><fmt:message key="file.form.download"  bundle="${file}"/></button>
			</span>
			<span id="deletedOperBaar">
			<button type="button" class="btn btn-primary" id="create_btn" onclick="clearTrash();"><fmt:message key="entity.fileBase.oper.clear"  bundle="${file}"/></button>
			<button type="button" class="btn btn-primary" id="delete_btn" onclick="removeSelected();"><fmt:message key="common.form.delete"/></button>
			</span>
			
			<td><span><input name="search_LIKE_name" class="lk-input" id="search_LIKE_name" type="text" placeholder="<fmt:message key="file.form.search.name" bundle="${file}"/>">
			</span>
			</div>

			<div id="testbreadcrumb"></div>
		</div>
	    </div>
	  </div>

 
	</div>
</div>
		
</fieldset>

<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <span class="preview"></span>
        </td>
        <td>
            <p class="name">{%=file.name%}</p>
            <strong class="error text-danger"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
            <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar bar-success" style="width:0%;"></div></div>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start" disabled>
                    <i class="icon-upload"></i>
                    <span>Start</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">
                    <i class="icon-ban-circle"></i>
                    <span><fmt:message key="common.form.cancel"/></span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
{% } %}
</script>
<script src="${ctx}/static/javascript/filetype.js"></script>

<script src="${ctx}/static/fileupload/tmpl.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="${ctx}/static/fileupload/load-image.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="${ctx}/static/fileupload/canvas-to-blob.min.js"></script>
<!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<!-- <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script> -->
<!-- blueimp Gallery script -->
<script src="${ctx}/static/fileupload/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="${ctx}/static/fileupload/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script>
$(function () {
    'use strict';

    fileUploadReset(false,"s=file");
    $('#fileupload').fileupload().on('fileuploadadd', function(e, data) {
    	var o = $("#conditionOwner").val();
    	if(o){
    		data.url = '${ctx}/file/attachment/upload?o='+o+'&s=file&parentId='+parentId;
    		$('#upload-container').dialog('open');
    		
    	}else{
    		data.url = '${ctx}/file/attachment/upload?s=file&parentId='+parentId;
    		 $('#upload-container').dialog('open');
    	}
    	 
    	
    });;
});
function fileUploadReset(init,params){
	var url = '${ctx}/file/attachment/upload';
	if(params){
		url = url + "?" + params;
	}

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
    	sequentialUploads : true,
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: url,
        autoUpload: true  
    }).bind('fileuploaddone', function (e, data) {
    	$.paginationList("#list").refreshData();
	}).bind('fileuploadsubmit', function (e, data) {
        $.each(data.files, function (index, file) {
            console.log('Added file: ' + file.name+ ', Path :'+file.relativePath);
            if(file.relativePath){
            	data.formData = {relativePath: file.relativePath};
            }
          });
        });;

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );
    // Load existing files:
    
    $('#fileupload').addClass('fileupload-processing');
	$('tbody.files tr').remove();
	if(init){
	    $.ajax({
	        // Uncomment the following to send cross-domain cookies:
	        //xhrFields: {withCredentials: true},
	        url: $('#fileupload').fileupload('option', 'url'),
	        dataType: 'json',
	        context: $('#fileupload')[0]
	    }).always(function () {
	    	$('#fileupload').removeClass('fileupload-processing');
	    }).done(function (result) {
	    	$('#fileupload').fileupload('option', 'done')
	            .call(this, $.Event('done'), {result: result});
	    });
		
	}
}
</script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="${ctx}/static/fileupload/cors/jquery.xdr-transport.js"></script>
<![endif]-->
<div id="upload-container" class="upload-container">
	<form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
        <!-- Redirect browsers with JavaScript disabled to the origin page -->
        <noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="fileupload-buttonbar">
                       <span class="btn btn-success fileinput-button">
                    <i class="icon-plus"></i>
                    <span><fmt:message key="entity.attachment.upload" bundle="${file}"/>...</span>
                    <input type="file" name="files[]" multiple >
                    <input type="hidden" name="relativePath">
                </span>
        
            <div class="span2 ">
                <!-- The fileinput-button span is used to style the file input field as button -->
                 <!-- The global file processing state -->
                <span class="fileupload-process"></span>
            </div>
            <!-- The global progress state -->
            <div class="span6 fileupload-progress fade">
                <!-- The global progress bar -->
                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                    <div class="bar bar-success" style="width:0%;"></div>
                </div>
                <!-- The extended global progress state -->
                <div class="progress-extended">&nbsp;</div>
            </div>
        </div>
        <!-- The table listing the files available for upload/download -->
        <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
    </form>	
</div>
<div id="createFolder">
	<form id="folderInputForm" action="${ctx}/file/folder/save" method="get" class="form-horizontal">
	
			<input type="hidden" id="editFolderId" name="id" value="">
			<div class="control-group">
				<label for="editFolderName" class="control-label"><fmt:message key="entity.folder.name" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="editFolderName" name="name"  value="" class="input-large"   maxlength="200"    required/>
<span class="icon-asterisk  icon-orange"></span>
				</div>
			</div>
            <input type="hidden" id="createFolderParentId" name="parentId" value="" >
            <input type="hidden" id="createFolderOwner" name="o" value="" >
            <div id="folderAuthArea">
 

			<div class="control-group">
				<label for="editorsLabel" class="control-label"><fmt:message key="entity.fileBase.permission.editor" bundle="${file}"/>:</label>
				
				<div class="controls">
					<input type="text" id="editorsLabel" name="editorsLabel" value=""  class="input-large"  />
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="editors_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="editorsId" name="editorsId" value="" >
                   
				</div>
				<div id="editorsIdDialog"></div>
			</div>
			<script>
			var organizationTreeSetting = {
					async: {
						enable: true,
						url:"${propertyConfigurer['core.reference.path.organizationModulePath']}/org/organization/treejsonp"+"?"+_lkc_ctx_url,
						autoParam:["id","name=name"],
						dataType:"jsonp",
						type:"get"
					},
					idPaths:''

				};

					 var editorsDialog= $("#editorsIdDialog").selectDialog({
				 name:"editors",
			    	id: $("#editorsId"),
					label: $("#editorsLabel"),
					ajaxUrl: '${propertyConfigurer['core.reference.path.organizationModulePath']}/org/organization/listjsonp?page={page+1}&pageSize={size}&{sortParam}&{condition}'+"&"+_lkc_ctx_url,
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: true, treeOptions:organizationTreeSetting,ajaxDataType:'jsonp',
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.folder.name"  bundle="${file}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.folder.name"  bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#editors_selector").click(function(){
				 editorsDialog.showSelectDialog(true);
			 });
			</script>	
			
			<div class="control-group">
				<label for="readersLabel" class="control-label"><fmt:message key="entity.fileBase.permission.reader" bundle="${file}"/>:</label>
				
				<div class="controls">
					<input type="text" id="readersLabel" name="readersLabel" value=""  class="input-large"  />
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="readers_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="readersId" name="readersId" value="" >
                   
				</div>
				<div id="readersIdDialog"></div>
			</div>
			<script>

			var organizationReaderTreeSetting = {
					async: {
						enable: true,
						url:"${propertyConfigurer['core.reference.path.organizationModulePath']}/org/organization/treejsonp"+"?"+_lkc_ctx_url,
						autoParam:["id","name=name"],
						dataType:"jsonp",
						type:"get"
					},
					idPaths:''

				};

					 var readersDialog= $("#readersIdDialog").selectDialog({
				 name:"readers",
			    	id: $("#readersId"),
					label: $("#readersLabel"),
					ajaxUrl: '${propertyConfigurer['core.reference.path.organizationModulePath']}/org/organization/listjsonp?page={page+1}&pageSize={size}&{sortParam}&{condition}'+"&"+_lkc_ctx_url,
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: true, treeOptions:organizationReaderTreeSetting,ajaxDataType:'jsonp',
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.folder.name"  bundle="${file}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.folder.name"  bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#readers_selector").click(function(){
				 readersDialog.showSelectDialog(true);
			 });
			</script>		           
				           
            </div>
                     
	</form>
</div>
<div id="move">
	<ul id="movetree" class="ztree"></ul>
</div>
<script id="template-oper-bar" type="text/x-tmpl">
  <div class="btn-group">
    <a class="btn" href="javascript:void(0)" title="<fmt:message key="entity.fileBase.oper.rename" bundle="${file}"/>" onclick="rename(this);"><i class="icon-edit"></i></a>
    <a class="btn" href="javascript:void(0)" title="<fmt:message key="entity.fileBase.oper.move" bundle="${file}"/>" onclick="move(this);"><i class="icon-move"></i></a>
  </div>
</script>
</body>
</html>

