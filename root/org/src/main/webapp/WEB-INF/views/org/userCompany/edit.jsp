<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@page import="cc.landking.web.org.service.*,cc.landking.web.core.service.RoleService,cc.landking.web.org.entity.*,cc.landking.web.core.utils.UserUtils" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<fmt:setBundle basename="i18n.core_message" var="core"/>
<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.userCompany" bundle="${org}"/></title>
	
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


	<form id="inputForm" action="${ctx}/org/userCompany/${action}" method="post" class="form-horizontal">
	
			<legend><small><fmt:message key="common.form.create"/><fmt:message key="entity.userCompany" bundle="${org}"/></small></legend>
			<input type="hidden" name="id" value="${model.id }">
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">x</button>${message}</div>
	</c:if>

<% if(UserUtils.isAdmin()){ %>
			<div class="control-group">
				<label for="companyLabel" class="control-label"><fmt:message key="entity.userCompany.company" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="companyLabel" name="companyLabel" value="${model.company.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="company_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="companyId" name="companyId" value="${model.company.id}" >
                    
				</div>
				<div id="companyIdDialog"></div>
			</div>
			<script>
		
					 var companyDialog= $("#companyIdDialog").selectDialog({
				 name:"company",
			    	id: $("#companyId"),
					label: $("#companyLabel"),
					ajaxUrl: '${ctx}/org/userCompany/companylistjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, 
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.company.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.company.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#company_selector").click(function(){
				 companyDialog.showSelectDialog();
			 });
			</script>	
<%}else{ 
UserCompany usercom = (UserCompany)request.getAttribute("model");
if(usercom != null){
	CompanyService companyService = (CompanyService)request.getAttribute("companyService");
	usercom.setCompany(companyService.get(UserUtils.getUserCompanyId()));
}
%>
			<div class="control-group">
				<label for="companyLabel" class="control-label"><fmt:message key="entity.userCompany.company" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="companyLabel" name="companyLabel" value="${model.company.name}"  class="input-large"  disabled/>
                    <input type="hidden" id="companyId" name="companyId" value="${model.company.id}"   required>
                    
				</div>
				
			</div>

<%} %>
			<div class="control-group">
				<label for="roleLabel" class="control-label"><fmt:message key="entity.userCompany.role" bundle="${org}"/>:</label>
				
				<div class="controls">
				<%
					RoleService roleService = (RoleService)request.getAttribute("roleService");
						request.setAttribute("lkOrgRoles",roleService.findOrgRoles());
				%>
				<select name="roleId"   required>
					<c:forEach items="${lkOrgRoles}" var="role">
						<c:if test="${role.id eq model.role.id}">
						<option value="${role.id }" selected><fmt:message key="${role.name}"/></option>
						</c:if>
						<c:if test="${role.id ne model.role.id}">
						<option value="${role.id }"><fmt:message key="${role.name}"/></option>
						</c:if>
					</c:forEach>
				</select>

				</div>
				<div id="roleIdDialog"></div>
			</div>


			<div class="control-group">
				<label for="userLabel" class="control-label"><fmt:message key="entity.userCompany.user" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="userLabel" name="userLabel" value="${model.user.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="user_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="userId" name="userId" value="${model.user.id}"   required>
                    
				</div>
				<div id="userIdDialog"></div>
			</div>
			<script>
		
					 var userDialog= $("#userIdDialog").selectDialog({
				 name:"user",
			    	id: $("#userId"),
					label: $("#userLabel"),
					ajaxUrl: '${ctx}/core/user/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, 
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.user.name" bundle="${core}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.user.name" bundle="${core}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#user_selector").click(function(){
				 userDialog.showSelectDialog();
			 });
			</script>	

			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		
	</form>
	 
</body>
</html>
