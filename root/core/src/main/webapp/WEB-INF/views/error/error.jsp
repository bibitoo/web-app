<%@page import="org.apache.commons.lang3.exception.ExceptionUtils"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="org.slf4j.Logger,org.slf4j.LoggerFactory" %>
<fmt:bundle basename="i18n.message">

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
Logger logger = LoggerFactory.getLogger("500.jsp");
	Throwable ex = null;
	if (exception != null){
		ex = exception;
	}
	if (request.getAttribute("javax.servlet.error.exception") != null)
		ex = (Throwable) request.getAttribute("javax.servlet.error.exception");
	if(ex == null){
		int statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
		String message = (String) request.getAttribute("javax.servlet.error.message");
		String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");
		String uri = (String) request.getAttribute("javax.servlet.error.request_uri");
		Throwable t = (Throwable) request.getAttribute("javax.servlet.error.exception");
		Class exceptionClass = (Class) request.getAttribute("javax.servlet.error.exception_type");
		
		logger.error(statusCode + "|" + message + "|" + servletName + "|" + uri + "|" + exceptionClass.getName(), t); 
		
	}

	//记录日志
	logger.error(ex.getMessage(), ex);
	String stacktrace = ExceptionUtils.getStackTrace(ex);
	String errMessage = ex.getMessage();

%>
<!DOCTYPE html>
<html>
<head>
	<title>Error-<fmt:message key="common.error.unknown" /></title>
	<script>
	function toggleDetailMsg(obj){
		$('#error').toggle();
		if($('#error').is(':visible')){
			$(obj).text('<fmt:message key="common.error.hideDetail" />');
		}else{
			$(obj).text('<fmt:message key="common.error.showDetail" />');
		}

	}
	</script>
</head>

<body>

<div class="container">
	<h2><fmt:message key="common.error.unknown" /></h2>
	<div class="alert alert-error">
	
		<fmt:message key="common.error.unknown" />
		
	</div>
	<p>
	<a href="${ctx }/logout" class="btn " ><fmt:message key="user.logout"/></a>
	<a href="<c:url value="/"/>" class="btn " ><fmt:message key="common.form.back" /><fmt:message key="nav.bar.home" /></a>
	<input id="back_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
	
	</p>
	
	<a href="#" onclick="javascript:toggleDetailMsg(this);">
	<fmt:message key="common.error.showDetail" /> 
	</a> <span  class="icon-list-alt"></span>
	<p>
	<pre class="prettyprint linenums" style="display:none" id="error">
	<%=stacktrace %>
	</pre>
	</p>
</div>

</body>
</html>
</fmt:bundle>