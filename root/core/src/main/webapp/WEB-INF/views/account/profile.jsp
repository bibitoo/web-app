<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="user.profile"/></title>
	
	<script>
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate();
		});
	</script>
</head>

<body>
	<form id="inputForm" action="${ctx}/profile" method="post" class="form-horizontal">
		<input type="hidden" name="id" value="${user.id}"/>
		<fieldset>
			<legend><small><fmt:message key="user.profile"/></small></legend>
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="core.user.name"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name" value="${user.name}" class="input-large required"/>
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
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</body>
</html>
