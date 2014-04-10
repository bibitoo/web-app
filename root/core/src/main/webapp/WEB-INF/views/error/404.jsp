<%@page import="org.apache.commons.lang3.exception.ExceptionUtils"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="org.slf4j.Logger,org.slf4j.LoggerFactory" %>
<fmt:bundle basename="i18n.message">

<c:set var="ctx" value="${pageContext.request.contextPath}" />


<!DOCTYPE html>
<html>
<head>
	<title>404-<fmt:message key="common.error.404" /></title>

</head>

<body>

<div class="container">
	<h2><fmt:message key="common.error.404" /></h2>
	<div class="alert alert-error">
	
		<fmt:message key="common.error.404" />
		
	</div>
	<p>
	<a href="<c:url value="/"/>" class="btn " ><fmt:message key="common.form.back" /><fmt:message key="nav.bar.home" /></a>
	<input id="back_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
	
	</p>
	
	<p>
	<img src="${ctx }/static/images/404.jpg"/>
	</p>
</div>

</body>
</html>
</fmt:bundle>