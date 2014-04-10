<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<html>
<head>
	<title><fmt:message key="common.form.view"/><fmt:message key="entity.filePermission" bundle="${file}"/></title>
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
	<form id="inputForm" action="${ctx}/file/filePermission/delete/${model.id}" method="get" class="form-horizontal" onsubmit="return confirm('<fmt:message key="common.form.delete.confirm"/>');">
		<fieldset>
			<legend><small><fmt:message key="common.form.view"/><fmt:message key="entity.filePermission" bundle="${file}"/></small></legend>

			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="objectId" class="control-label"><fmt:message key="entity.filePermission.objectId" bundle="${file}"/>:</label>
				<div class="controls">
					${model.objectId }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="role" class="control-label"><fmt:message key="entity.filePermission.role" bundle="${file}"/>:</label>
				<div class="controls">
					${model.role }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="creator" class="control-label"><fmt:message key="entity.filePermission.creator" bundle="${file}"/>:</label>
				<div class="controls">
					${model.creator }
				</div>
			</div>
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.filePermission.createTime" bundle="${file}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.createTime}"/>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label for="permission" class="control-label"><fmt:message key="entity.filePermission.permission" bundle="${file}"/>:</label>
				<div class="controls">
					${model.permission }
				</div>
			</div>
		
		


	
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.edit"/>" onclick="window.location.href='${ctx}/file/filePermission/update/${model.id}';"/>&nbsp;	
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.delete"/>"  onclick="comfirmDelete('${ctx}/file/filePermission/delete/${model.id}');"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</body>
</html>
