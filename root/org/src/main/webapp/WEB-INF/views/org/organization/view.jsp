<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<html>
<head>
	<title><fmt:message key="common.form.view"/><fmt:message key="entity.organization" bundle="${org}"/></title>
	<script>
	function comfirmDelete(url){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  
				  window.location.href = url;
			  }
			});
	}
	</script>	
</head>

<body>
	<form id="inputForm" action="${ctx}/org/organization/delete/${model.id}" method="get" class="form-horizontal" onsubmit="return confirm('<fmt:message key="common.form.delete.confirm"/>');">
		<fieldset>
			<legend><small><fmt:message key="common.form.view"/><fmt:message key="entity.organization" bundle="${org}"/></small></legend>

			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.organization.name" bundle="${org}"/>:</label>
				<div class="controls">
					${model.name }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="virtual" class="control-label"><fmt:message key="entity.organization.virtual"  bundle="${org}"/>:</label>
				<label class="controls">
				    <input type="checkbox"  id="_virtual"  ${model.virtual?"checked":"" }> 
				    <input type="hidden"  id="virtual" name="virtual" value="${model.virtual}"/>
				    <script>$("#_virtual").change(function() {
							var isCheck = $(this).is(':checked');
							$("#virtual").val(isCheck);
						});
				    </script>
				    
				  </label>
			 </div>
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.organization.createTime" bundle="${org}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.createTime}"/>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.organization.lastModifyTime" bundle="${org}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.lastModifyTime}"/>
				</div>
			</div>	
		
		








			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.parent" bundle="${org}"/>:</label>
				<div class="controls">
				${model.parent.name }
				</div>
			</div>
	
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="entity.organization.enable"/>" onclick="enableSelected();"/>&nbsp;	
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.delete"/>"  onclick="comfirmDelete('${ctx}/org/organization/delete/${model.id}');"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
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
	var msgs = [<fmt:message key="common.form.dialog.messages"/>];
	msgs[0] = msgs[0] + '<fmt:message key="entity.employee.parent" bundle="${org}"/>';

		var callback = function(pids,names){
			window.location.href = '${ctx}/org/organization/enable/${model.id}/'+pids
		};
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
						function enableSelected(){
							parentDialog.showSelectDialog();
						}

			</script>	
</div>
</body>
</html>
