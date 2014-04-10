<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<html>
<head>
	<title><fmt:message key="common.form.view"/><fmt:message key="entity.post" bundle="${org}"/></title>
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
	<form id="inputForm" action="${ctx}/org/post/disable/${model.id}" method="get" class="form-horizontal" onsubmit="return confirm('<fmt:message key="common.form.delete.confirm"/>');">
		<fieldset>
			<legend><small><fmt:message key="common.form.view"/><fmt:message key="entity.post" bundle="${org}"/></small></legend>

			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.post.name" bundle="${org}"/>:</label>
				<div class="controls">
					${model.name }
				</div>
			</div>
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.post.parent" bundle="${org}"/>:</label>
				<div class="controls">
				${model.parent.name }
				</div>
			</div>
	
		
			<div class="control-group">
				<label for="virtual" class="control-label"><fmt:message key="entity.post.virtual"  bundle="${org}"/>:</label>
				<label class="controls">
				 <c:if test="${model.virtual}"><fmt:message key="common.form.boolean.yes"/></c:if>
				 <c:if test="${not model.virtual}"><fmt:message key="common.form.boolean.no"/></c:if>
				  </label>
			 </div>
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.post.createTime" bundle="${org}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.createTime}"/>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.post.lastModifyTime" bundle="${org}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.lastModifyTime}"/>
				</div>
			</div>	
	
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.edit"/>" onclick="window.location.href='${ctx}/org/post/update/${model.id}';"/>&nbsp;	
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.delete"/>"  onclick="comfirmDelete('${ctx}/org/post/disable/${model.id}');"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</body>
</html>
