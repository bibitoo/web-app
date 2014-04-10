<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.userCompany" bundle="${org}"/></title>
	<script>
	var roleMessages = <c:out value="${roleMessages}" escapeXml="false"/>;
	var columns = ["user.name","role.name","company.name","createTime","lastModifyTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	
	var paginationList;
	var ztree ;
	$(document).ready(function() {

				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:true,
			useSelectedPanel:true,//isCheckSelect:false,
				ajaxUrl: '${ctx}/org/userCompany/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
				{name:"user.name",label:"<fmt:message key="entity.userCompany.user" bundle="${org}"/>"}
				,
				{name:"role.name",label:"<fmt:message key="entity.userCompany.role" bundle="${org}"/>"}
				,
				{name:"company.name",label:"<fmt:message key="entity.userCompany.company" bundle="${org}"/>"}
				,
						{name:"createTime",label:"<fmt:message key="entity.userCompany.createTime" bundle="${org}"/>"}
						,
						{name:"lastModifyTime",label:"<fmt:message key="entity.userCompany.lastModifyTime" bundle="${org}"/>"}
						
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"user.name",label:"<fmt:message key="entity.userCompany.user" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
				<c:if test="${not empty message}">$().toastmessage('showNoticeToast', '${message}');</c:if>

	});
	

		
	
	function renderField(row,column,settings){
  		if(column == 'company.name'){
			if(row.company.name){
				return '<span  class="list-subject">'+row.company.name+'</span>';
			}else{
				return " ";
			}
		}
  		if(column == 'user.name'){
			if(row.user.name){
				return '<span  class="list-subject"><a href="${ctx}/org/userCompany/view/'+row['id']+'">'+row.user.name+'</a></span>';
			}else{
				return " ";
			}
		}
  		if(column == 'role.name'){
			if(row.role.name){
				return roleMessages[row.role.name];
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

		

		return row[column];
	}

	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/org/userCompany/deleteAll",{ids:ids},function (data, textStatus){
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
<c:set var="menuKey" value="UserCompany"/>
<%@ include file="../menu.jsp" %>

	
		<div id="list">
			<div class="conditionPanel pull-right">
				<div id="operation-bar" class="span5.5">
				<button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/org/userCompany/create';"><fmt:message key="common.form.create"/></button>
				<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
				</div>
			</div>
		</div>
</fieldset>
</body>
</html>

