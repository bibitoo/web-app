<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.organization" bundle="${org}"/></title>
	<script>
	var columns = ["name","orgType","virtual","createTime","lastModifyTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	var orgTypes=new Array();
	orgTypes['Company'] = '<fmt:message key="entity.company" bundle="${org}"/>';
	orgTypes['Department'] = '<fmt:message key="entity.department" bundle="${org}"/>';
	orgTypes['Employee'] = '<fmt:message key="entity.employee" bundle="${org}"/>';
	orgTypes['Post'] = '<fmt:message key="entity.post" bundle="${org}"/>';
	orgTypes['Group'] = '<fmt:message key="entity.group" bundle="${org}"/>';
	
	var paginationList;
	$(document).ready(function() {
				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:true,
			useSelectedPanel:true,//isCheckSelect:false,
				ajaxUrl: '${ctx}/org/organization/listdeletedjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
						{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}
						,
						{name:"orgType",label:"<fmt:message key="entity.organization.orgType" bundle="${org}"/>"}
						,
						{name:"virtual",label:"<fmt:message key="entity.organization.virtual" bundle="${org}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.organization.createTime" bundle="${org}"/>"}
						,
						{name:"lastModifyTime",label:"<fmt:message key="entity.organization.lastModifyTime" bundle="${org}"/>"}
						
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
		
	});
	
	
	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				return '<a href="${ctx}/org/organization/view/'+row['id']+'">'+row[column]+'</a>';
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

  		if(column == 'orgType'){
			if(row[column]){
				return orgTypes[row[column]];
			}else{
				return " ";
			}
		}
		

		return row[column];
	}

	function deleteSelected(){
		if(paginationList){
			var ids = $.paginationList("#list").getSelectedIds();
			if(!ids){
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
				return;
			}
		}

		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/org/organization/deleteAll",{ids:ids},function (data, textStatus){
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
	function enableSelected(){
		if(paginationList){
			var ids = $.paginationList("#list").getSelectedIds();
			if(!ids){
				$().toastmessage('showNoticeToast', '<fmt:message key="entity.organization.error.noSelectDataForEnable" bundle="${org}"/>');
				return;
			}
		}
		parentDialog.showSelectDialog();

	}
		
	</script>
</head>

<body>
<fieldset>
<c:set var="menuKey" value="DeletedOrganization"/>
<%@ include file="../menu.jsp" %>

<div>

	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">x</button>${message}</div>
	</c:if>
		<div id="listContainer">
			<div id="list">
				<div class="conditionPanel pull-right">
					<input type="hidden" id="search_LLIKE_hierarchyId" name="search_LLIKE_hierarchyId" value="${param["search_LLIKE_hierarchyId"]}"/>
					<div id="operation-bar" class="span5.5">
				<shiro:hasAnyRoles name="orgadmin,admin">
					<button type="button" class="btn btn-primary" id="delete_btn" onclick="enableSelected();"><fmt:message key="entity.organization.enable" bundle="${org}"/></button>
					<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
					</shiro:hasAnyRoles>
					</div>
				</div>
			</div>
		</div>

</div>
</fieldset>
<div>
<input type="hidden" id="parentId" name="parentId" >
<input type="hidden" id="parentLabel" name="parentLabel" >
<div id="parentIdDialog"></div>
<script>
var parentIdSetting = {
		async: {
			enable: true,
			url:"${ctx}/org/department/treejson",
			autoParam:["id","name=name"],
			type:"get"
		},
		idPaths:'<c:out value="${model.hierarchyId }"/>'

	};

		var callback = function(pids,names){
			var ids = $.paginationList("#list").getSelectedIds();
			if(ids){
				$.get("${ctx}/org/organization/enableAll",{ids:ids,pid:pids},function (data, textStatus){
					if(data.status == 'error'){
						$().toastmessage('showNoticeToast', data.message);
					}else{
						$().toastmessage('showNoticeToast', '<fmt:message key="entity.organization.enable.success" bundle="${org}"/>');
						$.paginationList("#list").refreshData();
					}
				});
				return;
			}else{
				$().toastmessage('showNoticeToast', '<fmt:message key="entity.organization.error.noSelectDataForEnable" bundle="${org}"/>');
			}
		};
		var msgs = [<fmt:message key="common.form.dialog.messages"/>];
		msgs[0] = msgs[0] + '<fmt:message key="entity.employee.parent" bundle="${org}"/>';

					 var parentDialog= $("#parentIdDialog").selectDialog({
				 name:"parent",
			    	id: $("#parentId"),
					label: $("#parentLabel"),
					ajaxUrl: '${ctx}/org/department/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, callback:callback, treeOptions:parentIdSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: msgs
			    });

			</script>	
</div>
</body>
</html>

