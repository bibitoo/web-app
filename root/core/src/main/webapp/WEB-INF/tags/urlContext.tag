<%@tag pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
${pageContext.request.scheme}://${pageContext.request.serverName}<c:if test ="${pageContext.request.serverPort != 80}">:${pageContext.request.serverPort}</c:if>${pageContext.request.contextPath}