<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<html>
<head>
	<title><fmt:message key="common.form.view"/><fmt:message key="entity.employee" bundle="${org}"/></title>
	<script>
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
	<form id="inputForm" action="${ctx}/org/employee/disable/${model.id}" method="get" class="form-horizontal" onsubmit="return confirm('<fmt:message key="common.form.delete.confirm"/>');">
		<fieldset>
			<legend><small><fmt:message key="common.form.view"/><fmt:message key="entity.employee" bundle="${org}"/></small></legend>


			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.employee.name" bundle="${org}"/>:</label>
				<div class="controls">
					${model.name }
				</div>
			</div>
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.parent" bundle="${org}"/>:</label>
				<div class="controls">
				${model.parent.name }
				</div>
			</div>
	
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.manageDepartment" bundle="${org}"/>:</label>
				<div class="controls">
				<tags:listToString list="${model.manageDepartment}" property ="name"/>
				</div>
			</div>
		
		

			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.post" bundle="${org}"/>:</label>
				<div class="controls">
				<c:out value="${model.post.name }"/>
				</div>
			</div>




			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.user" bundle="${org}"/>:</label>
				<div class="controls">
				<c:out value="${model.user.loginName }"/>
				</div>
			</div>
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.groups" bundle="${org}"/>:</label>
				<div class="controls">
				<tags:listToString list="${model.groups}" property ="name"/>
				</div>
			</div>
					
		
			<div class="control-group">
				<label for="virtual" class="control-label"><fmt:message key="entity.employee.virtual"  bundle="${org}"/>:</label>
				<label class="controls">
				 <c:if test="${model.virtual}"><fmt:message key="common.form.boolean.yes"/></c:if>
				 <c:if test="${not model.virtual}"><fmt:message key="common.form.boolean.no"/></c:if>
				  </label>
			 </div>
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.createTime" bundle="${org}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.createTime}"/>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.employee.lastModifyTime" bundle="${org}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.lastModifyTime}"/>
				</div>
			</div>	
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.edit"/>" onclick="window.location.href='${ctx}/org/employee/update/${model.id}';"/>&nbsp;	
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.delete"/>"  onclick="comfirmDelete('${ctx}/org/employee/disable/${model.id}');"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</body>
</html>
