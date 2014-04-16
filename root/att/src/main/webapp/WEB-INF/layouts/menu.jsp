<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:bundle basename="i18n.message"></fmt:bundle>
<fmt:setBundle basename="i18n.org_message" var="org"/>	
<fmt:setBundle basename="i18n.file_message" var="file"/>							
<ul class="dropdown-menu">
   <shiro:hasAnyRoles name="admin">
  <li><a href="${ctx }/core/user/list"><fmt:message key="core.user.management"/></a></li>
   </shiro:hasAnyRoles>
   <shiro:hasAnyRoles name="admin,authorize">
   <li><a href="${ctx }/core/authorization/authorize"><fmt:message key="entity.authorization" bundle="${org}"/></a></li>
   </shiro:hasAnyRoles>
   <li><a href="${ctx }/file/fileBase"><fmt:message key="entity.attachment" bundle="${file}"/></a></li>

</ul>