<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="core.user.management"/></title>
	<script>
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate();
			$(':checkbox').change(function() {
				isCheck = $(this).is(':checked');
				var role = $(this).val();
				var roles = $("#roles").val().split(',');
				var index = roles.indexOf(role);

				if (index !== -1) {
				    roles.splice(index,1) ;
				}
				if(isCheck){
					roles.push(role);
				}
				
				$("#roles").val(roles);
			}); 
		});
	</script>
</head>
<body>
<c:if test="${action eq 'update' }">
	<form id="inputForm" action="${ctx}/core/user/update" method="post" class="form-horizontal">
		<input type="hidden" name="action" value="${action}"/>
		<input type="hidden" name="id" value="${user.id}"/>
		<fieldset>
			<legend><small><fmt:message key="core.user.management"/></small></legend>
			<div class="control-group">
				<label class="control-label"><fmt:message key="core.user.name"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name" value="${user.name}" class="input-large required"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><fmt:message key="core.user.loginName"/>:</label>
				<div class="controls">
					<input type="text" value="${user.loginName}" class="input-large" disabled="" />
				</div>
			</div>
			<div class="control-group">
				<label for="plainPassword" class="control-label"><fmt:message key="core.user.password"/>:</label>
				<div class="controls">
					<input type="password" id="plainPassword" name="plainPassword" class="input-large" placeholder="<fmt:message key="core.user.password.placeholder"/>"/>
				</div>
			</div>
			<div class="control-group">
				<label for="confirmPassword" class="control-label"><fmt:message key="core.user.confirmPassword"/>:</label>
				<div class="controls">
					<input type="password" id="confirmPassword" name="confirmPassword" class="input-large" equalTo="#plainPassword" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><fmt:message key="core.user.registerDate"/>:</label>
				<div class="controls">
					<span class="help-inline" style="padding:5px 0px"><fmt:formatDate value="${user.registerDate}" pattern="yyyy-MM-dd  HH:mm:ss" /></span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><fmt:message key="core.user.roles"/>:</label>&nbsp;&nbsp;
				<input type="hidden" id="roles" name="roles" value="${user.roles}"/>
				<span class="ui-buttonset" id="select_roles">
					<c:forEach items="${rolesList}" var="role">
						<input id="a_${role}" type="checkbox" name="a" value="${role}" <c:if test="${  fn:contains( user.roleList, role )}"> checked</c:if> <c:if test="${  role eq 'admin' && user.loginName eq 'admin' }"> disabled="true"</c:if>/> 
						<label for="a_${role}"><fmt:message key="core.user.role.${role}"/></label>
					</c:forEach>
				</span>
				<script>$("#select_roles").buttonset();</script>
			</div>
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</c:if>
<c:if test="${action eq 'save' }">
	<form id="inputForm" action="${ctx}/core/user/save" method="post" class="form-horizontal">
		<fieldset>
			<legend><small><fmt:message key="core.user.management"/></small></legend>
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="core.user.name"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name" class="input-large required"/>
				</div>
			</div>
			<div class="control-group">
				<label for="loginName" class="control-label"><fmt:message key="core.user.loginName"/>:</label>
				<div class="controls">
					<input type="text" id="loginName" name="loginName" class="input-large required" minlength="3"/>
				</div>
			</div>
			<div class="control-group">
				<label for="plainPassword" class="control-label"><fmt:message key="core.user.password"/>:</label>
				<div class="controls">
					<input type="password" id="plainPassword" name="plainPassword" class="input-large required"/>
				</div>
			</div>
			<div class="control-group">
				<label for="confirmPassword" class="control-label"><fmt:message key="core.user.confirmPassword"/>:</label>
				<div class="controls">
					<input type="password" id="confirmPassword" name="confirmPassword" class="input-large required" equalTo="#plainPassword"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><fmt:message key="core.user.roles"/>:</label>&nbsp;&nbsp;
				<input type="hidden" id="roles" name="roles" value="${user.roles}"/>
				<span class="ui-buttonset" id="select_roles">
					<c:forEach items="${rolesList}" var="role">
						<input id="a_${role}" type="checkbox" name="a" value="${role}" <c:if test="${  fn:contains( user.roleList, role ) }"> checked</c:if> <c:if test="${  role eq 'admin' && user.loginName eq 'admin' }"> disabled="true"</c:if>/> 
						<label for="a_${role}"><fmt:message key="core.user.role.${role}"/></label>
					</c:forEach>
				</span>
				<script>$("#select_roles").buttonset();</script>
			</div>
			
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</c:if>
</body>
</html>
