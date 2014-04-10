<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.attFile" bundle="${file}"/></title>
	<script>
	var columns = ["name","createTime","lastModifyTime","type","size","hashCode","path"];
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
				ajaxUrl: '${ctx}/file/attFile/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
						{name:"name",label:"<fmt:message key="entity.attFile.name" bundle="${file}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.attFile.createTime" bundle="${file}"/>"}
						,
						{name:"lastModifyTime",label:"<fmt:message key="entity.attFile.lastModifyTime" bundle="${file}"/>"}
						,
						{name:"type",label:"<fmt:message key="entity.attFile.type" bundle="${file}"/>"}
						,
						{name:"size",label:"<fmt:message key="entity.attFile.size" bundle="${file}"/>"}
						,
						{name:"hashCode",label:"<fmt:message key="entity.attFile.hashCode" bundle="${file}"/>"}
						,
						{name:"path",label:"<fmt:message key="entity.attFile.path" bundle="${file}"/>"}
						
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"name",label:"<fmt:message key="entity.attFile.name" bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
		
	});
	

		
	
	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				return '<a href="${ctx}/file/attFile/view/'+row['id']+'">'+row[column]+'</a>';
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

  		if(column == 'size'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'hashCode'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'path'){
			if(row[column]){
				return row[column];
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
					var ids = paginationList.getSelectedIds();
					if(ids){
						$.get("${ctx}/file/attFile/deleteAll",{ids:ids},function (data, textStatus){
							if(data.status == 'error'){
								$().toastmessage('showNoticeToast', data.message);
							}else{
								$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
								paginationList.refreshData();
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
	<legend><small><fmt:message key="entity.attFile" bundle="${file}"/></small></legend>

	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">??</button>${message}</div>
	</c:if>
	
		<div id="list">
			<div class="conditionPanel pull-right">
				<div id="operation-bar" class="span5.5">
				<button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/file/attFile/create';"><fmt:message key="common.form.create"/></button>
				<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
				</div>
			</div>
		</div>
</fieldset>
</body>
</html>

