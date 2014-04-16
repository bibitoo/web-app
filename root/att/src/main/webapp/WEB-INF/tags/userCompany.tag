<%@tag import="cc.landking.web.core.utils.UserUtils,cc.landking.web.org.entity.*,cc.landking.web.core.service.*,java.util.*,java.net.*"%>
<%@tag pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
String lkCureUserid = UserUtils.getCurrentUserId();
if(lkCureUserid != null){
	request.setAttribute("lkCureUserid", lkCureUserid);
	String lkCompanyId = UserUtils.getUserCompanyId();
	if(lkCureUserid != null){
		request.setAttribute("lkCompanyId", lkCompanyId);
	}
	UserService userService = (UserService)request.getAttribute("userService");
	if(userService != null){
		 Map<String,String>  companies = userService.findCurrentUserCompanies( );
		request.setAttribute("lkUserCompanies", companies);
	}
	String path = request.getContextPath()+"/";
	if(request.getMethod().equals("GET")){
		path =  request.getAttribute("javax.servlet.forward.request_uri").toString();
	}
	request.setAttribute("lkCurrentCallbackPath", URLEncoder.encode(path, "UTF-8"));
	
	String scheme = request.getScheme();             
	String serverName = request.getServerName(); 
	int serverPort = request.getServerPort();    
	String uri = (String) request.getAttribute("javax.servlet.forward.request_uri");
	String prmstr = (String) request.getAttribute("javax.servlet.forward.query_string");
	String url = scheme + "://" +serverName + ":" + serverPort + uri + "?" + (prmstr == null?"":prmstr);
	
	%>

	<c:if test="${fn:length(lkUserCompanies) gt 0}">
	
	<c:forEach items="${lkUserCompanies }" var="company" varStatus="idx">

	<c:if test="${lkCompanyId eq company.key }">
	<a class=" dropdown-toggle" data-toggle="dropdown" href="#">
	     <i class="icon-home"></i> <c:out value="${company.value }"/>
	     <c:if test="${fn:length(lkUserCompanies) gt 1}">
	      <span class="caret"></span>
	      </c:if>
	    </a>
	</c:if> 
	</c:forEach>
	<c:if test="${fn:length(lkUserCompanies) gt 1}">
	    <ul class="dropdown-menu">
	<c:forEach items="${lkUserCompanies}" var="company" varStatus="idx">
			<c:if test="${lkCompanyId eq company.key }">
	      <li class="active"><a href="#"><c:out value="${company.value }"/></a></li>
			</c:if> 
			<c:if test="${lkCompanyId ne company.key }">
	      <li><a href="${propertyConfigurer['core.reference.path.organizationModulePath']}/org/employee/switchCompany?companyId=${company.key }&r=<%=url %>"><c:out value="${company.value }"/></a></li>
			</c:if> 
	</c:forEach>
	    </ul>
	</c:if>
	</c:if>

<%}%>