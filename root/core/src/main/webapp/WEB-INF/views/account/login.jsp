<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ page import="org.apache.shiro.authc.ExcessiveAttemptsException"%>
<%@ page import="org.apache.shiro.authc.IncorrectCredentialsException"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="core.user.login"/></title>
	<script>
		$(document).ready(function() {
			$("#loginForm").validate();
			$("#username").focus();
		});
	</script>
</head>

<body>
	<form id="loginForm" action="${ctx}/login" method="post" class="form-horizontal">
	<%
	String error = (String) request.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
	if(error != null){
	%>
		<div class="alert alert-error input-medium controls">
			<button class="close" data-dismiss="alert">×</button><fmt:message key="core.user.loginFailue"/>
		</div>
	<%
	}
	%>
		<fieldset>
			<legend><small><fmt:message key="core.user.login"/></small></legend>
	
		<div class="control-group">
			<label for="username" class="control-label"><fmt:message key="core.user.loginName"/>:</label>
			<div class="controls">
				<input type="text" id="username" name="username"  value="${username}" class="input-medium required"/>
			</div>
		</div>
		<div class="control-group">
			<label for="password" class="control-label"><fmt:message key="core.user.password"/>:</label>
			<div class="controls">
				<input type="password" id="password" name="password" class="input-medium required"/>
			</div>
		</div>
				
		<div class="control-group">
			<div class="controls">
				<label class="checkbox" for="rememberMe"><input type="checkbox" id="rememberMe" name="rememberMe"/> <fmt:message key="core.user.remenberme"/></label>
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="core.user.login"/>"/> <a class="btn" href="${ctx}/register"><fmt:message key="core.user.registration"/></a>
			 	<span class="help-block">(<fmt:message key="core.user.role.admin"/>: <b>admin/admin</b>, <fmt:message key="core.user.role.user"/>: <b>user/user</b>)</span>
			</div>
		</div>
		</fieldset>
	</form>
</body>
</html>
