<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.authorization" bundle="${org}"/></title>
	
	<script>
	$(document).ready(function() {
		//if ckeditor required
		$('#inputForm').submit(function(){
	        $('textarea.ckeditor').each(function () {
	           var $textarea = $(this);
	           $textarea.val(CKEDITOR.instances[$textarea.attr('name')].getData());
	        });
	    });

		$("#inputForm").validate({
			submitHandler : function(form) { 
				$("input[type=submit]",form).prop('disabled', true);
				   form.submit();  
				 }  
		});
	});
		
	</script>
	<script src="${ctx}/static/javascript/ckeditor/ckeditor.js" type="text/javascript"></script>

</head>

<body>


	<form id="inputForm" action="${ctx}/org/authorization/${action}" method="post" class="form-horizontal">
	
			<legend><small><fmt:message key="common.form.create"/><fmt:message key="entity.authorization" bundle="${org}"/></small></legend>
			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="model_createTime" class="control-label"><fmt:message key="entity.authorization.createTime" bundle="${org}"/>:</label>
				<div class="controls">
					<input type="text" id="model_createTime" name="createTime"  value="<tags:dateTime value="${ model.createTime}" />" class="input date"   />

					<script language="javascript">
					$(document).ready(function() {  
					       //$('#expireDate').datepicker(datepicker_i18n);  
					       $('#model_createTime').datetimepicker(datepicker_i18n);
					   });  
					</script>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label for="model_lastModifyTime" class="control-label"><fmt:message key="entity.authorization.lastModifyTime" bundle="${org}"/>:</label>
				<div class="controls">
					<input type="text" id="model_lastModifyTime" name="lastModifyTime"  value="<tags:dateTime value="${ model.lastModifyTime}" />" class="input date"   />

					<script language="javascript">
					$(document).ready(function() {  
					       //$('#expireDate').datepicker(datepicker_i18n);  
					       $('#model_lastModifyTime').datetimepicker(datepicker_i18n);
					   });  
					</script>
				</div>
			</div>	
		
		




			<div class="control-group">
				<label for="organizationLabel" class="control-label"><fmt:message key="entity.authorization.organization" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="organizationLabel" name="organizationLabel" value="${model.organization.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="organization_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="organizationId" name="organizationId" value="${model.organization.id}" >
                    
				</div>
				<div id="organizationIdDialog"></div>
			</div>
			<script>
		
					 var organizationDialog= $("#organizationIdDialog").selectDialog({
				 name:"organization",
			    	id: $("#organizationId"),
					label: $("#organizationLabel"),
					ajaxUrl: '${ctx}/org/organization/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, 
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					msgs: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#organization_selector").click(function(){
				 organizationDialog.showSelectDialog();
			 });
			</script>	


			<div class="control-group">
				<label for="roleLabel" class="control-label"><fmt:message key="entity.authorization.role" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="roleLabel" name="roleLabel" value="${model.role.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="role_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="roleId" name="roleId" value="${model.role.id}" >
                    
				</div>
				<div id="roleIdDialog"></div>
			</div>
			<script>
		
					 var roleDialog= $("#roleIdDialog").selectDialog({
				 name:"role",
			    	id: $("#roleId"),
					label: $("#roleLabel"),
					ajaxUrl: '${ctx}/org/role/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, 
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.role.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.role.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					msgs: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#role_selector").click(function(){
				 roleDialog.showSelectDialog();
			 });
			</script>	

			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		
	</form>
	 
</body>
</html>
