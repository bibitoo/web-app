<%@tag pageEncoding="UTF-8"%>
<%@ attribute name="list" type="java.util.Collection" required="true"%>
<%@ attribute name="property" type="java.lang.String" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach items="${list}" var="entry" varStatus="idx"><c:if test="${idx.index gt 0 }">;</c:if> <c:out value="${entry[property] }"/></c:forEach>

