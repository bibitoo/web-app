<%@page import="org.apache.commons.lang.exception.ExceptionUtils"%>
<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="org.slf4j.Logger,org.slf4j.LoggerFactory" %>
<fmt:bundle basename="i18n.message">

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
	Throwable ex = null;
	if (exception != null)
		ex = exception;
	if (request.getAttribute("javax.servlet.error.exception") != null)
		ex = (Throwable) request.getAttribute("javax.servlet.error.exception");

	//记录日志
	Logger logger = LoggerFactory.getLogger("500.jsp");
	logger.error(ex.getMessage(), ex);
	String stacktrace = ExceptionUtils.getStackTrace(ex);
	String errMessage = ex.getMessage();

%>

<!DOCTYPE html>
<html>
<head>
	<title><fmt:message key="common.error.error" /></title>
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
	<h2><fmt:message key="common.error.error" /></h2>
	<div class="alert alert-error">
	<%	
	if(ex != null && ex instanceof org.springframework.dao.EmptyResultDataAccessException){
		%>
		<fmt:message key="common.error.datanotfound" />
		<%
	}else  if(errMessage != null && org.apache.commons.lang3.StringUtils.containsIgnoreCase(errMessage, "foreign key")){
		%>
		<fmt:message key="common.error.constrain" />
		<%
	}else{
		%>
		<fmt:message key="common.error.unknown" />:<%=ex.getMessage() %>
		<%
	}
	%>
	</div>
	<p>
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