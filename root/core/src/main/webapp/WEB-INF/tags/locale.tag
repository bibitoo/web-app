<%@tag pageEncoding="UTF-8"%><%@ attribute name="standard" type="java.lang.Boolean" required="false"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><c:if test="${ pageContext.request.locale.language eq 'zh'  }"><c:if test="${not empty standard && standard }">${pageContext.request.locale.language}_${pageContext.request.locale.country}</c:if><c:if test="${ empty standard  }">${pageContext.request.locale.language}-${pageContext.request.locale.country}</c:if></c:if><c:if test="${ pageContext.request.locale.language ne 'zh'  }">${pageContext.request.locale.language}</c:if>