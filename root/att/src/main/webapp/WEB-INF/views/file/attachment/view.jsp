<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<html>
<head>
	<title><fmt:message key="common.form.view"/><fmt:message key="entity.attachment" bundle="${file}"/></title>
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
	<form id="inputForm" action="${ctx}/file/attachment/delete/${model.id}" method="get" class="form-horizontal" onsubmit="return confirm('<fmt:message key="common.form.delete.confirm"/>');">
		<fieldset>
			<legend><small><fmt:message key="common.form.view"/><fmt:message key="entity.attachment" bundle="${file}"/></small></legend>

			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.attachment.name" bundle="${file}"/>:</label>
				<div class="controls">
					${model.name }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="userid" class="control-label"><fmt:message key="entity.attachment.userid" bundle="${file}"/>:</label>
				<div class="controls">
					${model.userid }
				</div>
			</div>
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.attachment.createTime" bundle="${file}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.createTime}"/>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.attachment.lastModifyTime" bundle="${file}"/>:</label>
				<div class="controls">
					<tags:dateTime value="${model.lastModifyTime}"/>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label for="type" class="control-label"><fmt:message key="entity.attachment.type" bundle="${file}"/>:</label>
				<div class="controls">
					${model.type }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="systemCode" class="control-label"><fmt:message key="entity.attachment.systemCode" bundle="${file}"/>:</label>
				<div class="controls">
					${model.systemCode }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="size" class="control-label"><fmt:message key="entity.attachment.size" bundle="${file}"/>:</label>
				<div class="controls">
					${model.size }
				</div>
			</div>
		
			<div class="control-group">
				<label for="objectId" class="control-label"><fmt:message key="entity.attachment.objectId" bundle="${file}"/>:</label>
				<div class="controls">
					${model.objectId }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="key" class="control-label"><fmt:message key="entity.attachment.key" bundle="${file}"/>:</label>
				<div class="controls">
					${model.key }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="param1" class="control-label"><fmt:message key="entity.attachment.param1" bundle="${file}"/>:</label>
				<div class="controls">
					${model.param1 }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="param2" class="control-label"><fmt:message key="entity.attachment.param2" bundle="${file}"/>:</label>
				<div class="controls">
					${model.param2 }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="attFileId" class="control-label"><fmt:message key="entity.attachment.attFileId" bundle="${file}"/>:</label>
				<div class="controls">
					${model.attFileId }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="companyId" class="control-label"><fmt:message key="entity.attachment.companyId" bundle="${file}"/>:</label>
				<div class="controls">
					${model.companyId }
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="deleted" class="control-label"><fmt:message key="entity.attachment.deleted"  bundle="${file}"/>:</label>
				<label class="controls">
				    <input type="checkbox"  id="_deleted"  ${model.deleted?"checked":"" }> 
				    <input type="hidden"  id="deleted" name="deleted" value="${model.deleted}"/>
				    <script>$("#_deleted").change(function() {
							var isCheck = $(this).is(':checked');
							$("#deleted").val(isCheck);
						});
				    </script>
				    
				  </label>
			 </div>
		
		

			<div class="control-group">
				<label  class="control-label"><fmt:message key="entity.attachment.folder" bundle="${file}"/>:</label>
				<div class="controls">
				<c:out value="${model.folder.name }"/>
				</div>
			</div>



	
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.edit"/>" onclick="window.location.href='${ctx}/file/attachment/update/${model.id}';"/>&nbsp;	
				<input id="submit_btn" class="btn btn-primary" type="button" value="<fmt:message key="common.form.delete"/>"  onclick="comfirmDelete('${ctx}/file/attachment/delete/${model.id}');"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		</fieldset>
	</form>
</body>
</html>
