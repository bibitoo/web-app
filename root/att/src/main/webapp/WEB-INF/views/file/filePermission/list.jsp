<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.filePermission" bundle="${file}"/></title>
	<script>
	var columns = ["objectId","role","creator","createTime","permission"];
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
				ajaxUrl: '${ctx}/file/filePermission/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
				
					{name:"objectId",label:"<fmt:message key="entity.filePermission.objectId" bundle="${file}"/>"}
				,
					{name:"role",label:"<fmt:message key="entity.filePermission.role" bundle="${file}"/>"}
				,
					{name:"creator",label:"<fmt:message key="entity.filePermission.creator" bundle="${file}"/>"}
				,
					{name:"createTime",label:"<fmt:message key="entity.filePermission.createTime" bundle="${file}"/>"}
				,
					{name:"permission",label:"<fmt:message key="entity.filePermission.permission" bundle="${file}"/>"}
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"objectId",label:"<fmt:message key="entity.filePermission.objectId" bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
		
	});
	

		
	
	function renderField(row,column,settings){
  		if(column == 'objectId'){
			if(row[column]){
				return '<span class="list-subject">'+'<a href="${ctx}/file/filePermission/view/'+row['id']+'">'+row[column]+'</a>'+'</span>';
			}else{
				return " ";
			}
		}

  		if(column == 'role'){
			if(row[column]){
				return '<span class="list-subject">'+row[column]+'</span>';
			}else{
				return " ";
			}
		}

  		if(column == 'creator'){
			if(row[column]){
				return '<span class="list-subject">'+row[column]+'</span>';
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

  		if(column == 'permission'){
			if(row[column]){
				return '<span class="list-subject">'+row[column]+'</span>';
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
						$.get("${ctx}/file/filePermission/deleteAll",{ids:ids},function (data, textStatus){
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
	<legend><small><fmt:message key="entity.filePermission" bundle="${file}"/></small></legend>

	<c:if test="${not empty message}">
		<script>$().toastmessage('showNoticeToast', '${message}');</script>
	</c:if>
		
	
		<div id="list">
			<div class="conditionPanel">
				<div id="operation-bar" class="span5.5">
				<button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/file/filePermission/create';"><fmt:message key="common.form.create"/></button>
				<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
				</div>
			</div>
		</div>
</fieldset>
</body>
</html>

