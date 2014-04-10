<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="core.user.management"/></title>
	<script>
	var columns = ["loginName","name","roles","registerDate"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	
	$(document).ready(function() {
		  $("#contentTable").tablesorter({
			  sortList: [[index,sortOrder]],
			  headers: {
			      4: {sorter: false}
			    }
		  }).bind("sortEnd",function(e, t){
		        var obj = t.config.sortList[0];
		        //alert(columns[obj[0]]);
		        window.location.href = jQuery.param.querystring(window.location.href, 'sortType='+columns[obj[0]]+'&sortOrder='+obj[1]);
		      });
	});
	function forbidUser(uid, forbid){
		window.location.href="${ctx}/core/user/forbid/"+uid+"/"+forbid+"?ref="+encodeURIComponent(window.location.href);
	}
	function comfirmDelete(url){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  
				  window.location.href = url;
			  }
			});
	}
	</script>
</head>

<body>

<fieldset>
	<legend><small><fmt:message key="core.user.management"/></small></legend>

<div class="conditionPanel pull-right">
			<form class="form-search" action="#">
				<label><fmt:message key="core.user.name"/> </label> <input type="text" name="search_LIKE_name" class="input-medium" value="${param.search_LIKE_name}"> 
				<button type="submit" class="btn" id="search_btn"><fmt:message key="common.form.search"/></button>
				 <button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/core/user/create';"><fmt:message key="common.form.create"/></button>
		    </form>
</div>
	
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th><fmt:message key="core.user.loginName"/></th><th><fmt:message key="core.user.name"/></th><th><fmt:message key="core.user.roles"/></th><th><fmt:message key="core.user.registerDate"/></th><th><fmt:message key="common.form.management"/></th></tr></thead>
		<tbody>
		<c:forEach items="${page.content}" var="user">
		
			<tr>
				<td><a href="${ctx}/core/user/update/${user.id}">${user.loginName}</a></td>
				<td>${user.name}</td>
				<td><c:if test="${!empty user.roles}">
					<c:forEach items="${user.roleList}" var="role">
					<fmt:message key="core.user.role.${role}"/>
					</c:forEach>
					</c:if>
				</td>
				<td>
					<fmt:formatDate value="${user.registerDate}" pattern="yyyy-MM-dd  HH:mm:ss" />
				</td>
				<td><a href="#" onclick="comfirmDelete('${ctx}/core/user/delete/${user.id}');"><fmt:message key="common.form.delete"/></a>
				<c:if test="${not user.forbidden}">
				<a href="#" onclick="forbidUser('${user.id}',true);"><fmt:message key="core.user.action.forbbiden"/></a>
				</c:if>
				<c:if test="${ user.forbidden}">
				<a href="#" onclick="forbidUser('${user.id}',false);"><fmt:message key="core.user.action.active"/></a>
				</c:if>
				</td>
			</tr>
		</c:forEach>
	
		</tbody>
	</table>
		<tags:pagination page="${page}" paginationSize="5"/>
</fieldset>	
</body>
</html>
