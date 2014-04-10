<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="core.user.registration"/></title>
	
	<script>
		$(document).ready(function() {
			$("#loginName").focus();
			$("#inputForm").validate({
				rules: {
					loginName: {
						remote: "${ctx}/register/checkLoginName"
					}
				},
				messages: {
					loginName: {
						remote: "<fmt:message key="core.user.loginName.exists"/>"
					}
				}
			});
		});
	</script>
</head>

<body>
	<form id="inputForm" action="${ctx}/register" method="post" class="form-horizontal">
		<fieldset>
			<legend><small><fmt:message key="core.user.registration"/></small></legend>
			<div class="control-group">
				<label for="loginName" class="control-label"><fmt:message key="core.user.loginName"/>:</label>
				<div class="controls">
					<input type="text" id="loginName" name="loginName" class="input-large required" minlength="3"/>
				</div>
			</div>
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="core.user.name"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name" class="input-large required"/>
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
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</body>
</html>
