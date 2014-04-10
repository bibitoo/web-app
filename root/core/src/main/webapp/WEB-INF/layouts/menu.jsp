<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:bundle basename="i18n.message"></fmt:bundle>
								
								<ul class="dropdown-menu">
						          <li><a href="${ctx }/core/user/list"><fmt:message key="core.user.management"/></a></li>
						          
						        </ul>