<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.group" bundle="${org}"/></title>
	<script>
	var ajaxMsg = '<fmt:message key="common.error.ajax"/>';
	$(document).ajaxError(function(event, jqxhr, settings, exception) {  
	    window.console && console.log(exception);  
  	  $().toastmessage('showErrorToast', ajaxMsg);
	});
	var columns = ["name","virtual","createTime","lastModifyTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	
	var idPaths = '${param["hierarchyId"]}'.split('/');
	var setting = {
			async: {
				enable: true,
				url:"${ctx}/org/group/treejson",
				autoParam:["id","name=name"],
				type:"get"
			},
			callback:{onClick:groupTreeOnClick, onAsyncSuccess: groupOnAsyncSuccess}

		};
	var firstAsyncSuccessFlag = 0;
	function groupOnAsyncSuccess(event, treeId, treeNode, msg) {
		var tree_group = $.fn.zTree.getZTreeObj("tree_group");

		if(idPaths[0] == ""){
			if (firstAsyncSuccessFlag == 0) {
				firstAsyncSuccessFlag = 1;
				var nodes = tree_group.getNodes();
				tree_group.expandNode(nodes[0], true);
			}
		}
		lk_expandAjaxTreeNode(treeNode,idPaths,tree_group);
	};
	


	function groupTreeOnClick(event, treeId, treeNode) {
		$.paginationList("#list").addSelectedCondition("search_EQ_parent.id",'<fmt:message key="entity.group" bundle="${org}"/>:'+treeNode.name,treeNode.id);
		}
	var paginationList;
	var ztree ;
	$(document).ready(function() {

		ztree = $.fn.zTree.init($("#tree_group"), setting);
		ztree.setting.treeObj.bind("expandToLeaf.zTree",function(){
			var treeNode = ztree.getSelectedNodes()[0];
			if(treeNode){
				$.paginationList("#list").addSelectedCondition("search_EQ_parent.id",'<fmt:message key="entity.group" bundle="${org}"/>:'+treeNode.name,treeNode.id);
				
			}
		});

		 $("#menu-collapse").togglepanels();
				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:true,
			useSelectedPanel:true,//isCheckSelect:false,
				ajaxUrl: '${ctx}/org/group/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
							{name:"name",label:"<fmt:message key="entity.group.name" bundle="${org}"/>"}
						,
						{name:"virtual",label:"<fmt:message key="entity.group.virtual" bundle="${org}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.group.createTime" bundle="${org}"/>"}
						,
						{name:"lastModifyTime",label:"<fmt:message key="entity.group.lastModifyTime" bundle="${org}"/>"}
						
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"name",label:"<fmt:message key="entity.group.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
				<c:if test="${not empty message}">$().toastmessage('showNoticeToast', '${message}');</c:if>

	});
	

		
	
	function renderField(row,column,settings){
	  		if(column == 'name'){
			if(row[column]){
				return '<a href="${ctx}/org/group/view/'+row['id']+'">'+row[column]+'</a>';
			}else{
				return " ";
			}
		}

  		if(column == 'virtual'){
			if(row[column]){
				return '<fmt:message key="common.form.boolean.yes"/>';
			}else{
				return "<fmt:message key="common.form.boolean.no"/>";
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

		

		return row[column];
	}

	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/org/group/disableAll",{ids:ids},function (data, textStatus){
							if(data.status == 'error'){
								$().toastmessage('showNoticeToast', data.message);
							}else{
								$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
								$.paginationList("#list").refreshData();
								refreshTree(ids, ztree);
							}
						});
						return;
					}
				}
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
			  }
			});
	}
	function getSelectedNodeId(){
		if(ztree && ztree.getSelectedNodes().length > 0){
			return ztree.getSelectedNodes()[0].id;
		}
		return "";
	}
		
	</script>
</head>

<body>
<fieldset>
<c:set var="menuKey" value="Group"/>
<%@ include file="../menu.jsp" %>


<div class="row">
	<div class="span3">
		<div id="menu-collapse">
		<div>
             <h3><a href="#">&nbsp;<fmt:message key="entity.group" bundle="${org}"/></a></h3>
             <div><ul id="tree_group" class="ztree"></ul></div>
         </div>
     </div>
	
	</div>
	<div class="span9">
	
		<div id="list">
			<div class="conditionPanel">
				<div id="operation-bar" class="span5.5">
				<shiro:hasAnyRoles name="orgadmin,admin">
				<button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/org/group/create?parentId='+getSelectedNodeId();"><fmt:message key="common.form.create"/></button>
				<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
				</shiro:hasAnyRoles>
				</div>
			</div>
		</div>
	</div>
</div>
</fieldset>
</body>
</html>

