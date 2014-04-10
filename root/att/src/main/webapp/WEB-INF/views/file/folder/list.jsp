<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.folder" bundle="${file}"/></title>
	<script>
	var columns = ["name","createTime","lastModifyTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	
	var idPaths = '${param["search_LLIKE_hierarchyId"]}'.split('/');
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
	


	function folderTreeOnClick(event, treeId, treeNode) {
		$.paginationList("#list").addSelectedCondition("search_LLIKE_hierarchyId",treeNode.name,treeNode.hierarchyId);
		}
	var paginationList;
	var ztree ;
	$(document).ready(function() {

		ztree = $.fn.zTree.init($("#tree_folder"), setting);
		 $("#menu-collapse").togglepanels();
				$("#menu-collapse").bind("removeSelected",function(event,index,id,name){
					$("#search_LLIKE_hierarchyId").val("");
				     $.paginationList("#list").refreshData();
				     ztree.cancelSelectedNode();
				});
				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:true,
			useSelectedPanel:true,//isCheckSelect:false,
				ajaxUrl: '${ctx}/file/folder/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
						{name:"name",label:"<fmt:message key="entity.folder.name" bundle="${file}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.folder.createTime" bundle="${file}"/>"}
						,
						{name:"lastModifyTime",label:"<fmt:message key="entity.folder.lastModifyTime" bundle="${file}"/>"}
						
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"name",label:"<fmt:message key="entity.folder.name" bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
		
	});
	

		
	
	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				return '<a href="${ctx}/file/folder/view/'+row['id']+'">'+row[column]+'</a>';
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

  		if(column == 'creator'){
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

	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/folder/disableAll",{ids:ids},function (data, textStatus){
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
		
	</script>
</head>

<body>
<fieldset>
<c:set var="menuKey" value="Folder"/>
<%@ include file="../menu.jsp" %>


<div class="row">
	<div class="span3">
		<div id="menu-collapse">
		<div>
             <h3><a href="#"><span class="lk-clear"><fmt:message key="entity.folder" bundle="${file}"/></span></a></h3>
             <div><ul id="tree_folder" class="ztree"></ul></div>
         </div>
     </div>
	
	</div>
	<div class="span9">
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">x</button>${message}</div>
	</c:if>
	
		<div id="list">
			<div class="conditionPanel">
				<input type="hidden" id="search_LLIKE_hierarchyId" name="search_LLIKE_hierarchyId" value="${param["search_LLIKE_hierarchyId"]}"/>
				<div id="operation-bar" class="span5.5">
				<button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/file/folder/create';"><fmt:message key="common.form.create"/></button>
				<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
				</div>
			</div>
		</div>
	</div>
</div>
</fieldset>
</body>
</html>

