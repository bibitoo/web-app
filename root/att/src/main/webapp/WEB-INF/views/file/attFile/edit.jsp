<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.file_message" var="file"/>
<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.attFile" bundle="${file}"/></title>
	
	<script>
	$(document).ready(function() {
		//if ckeditor required
		$('#inputForm').submit(function(){
	        $('textarea.ckeditor').each(function () {
	           var $textarea = $(this);
	           $textarea.val(CKEDITOR.instances[$textarea.attr('name')].getData());
	        });
	    });

		$("#inputForm").validate({
			submitHandler : function(form) { 
				$("input[type=submit]",form).prop('disabled', true);
				   form.submit();  
				 }  
		});
	});
		
	</script>
	<script src="${ctx}/static/javascript/ckeditor/ckeditor.js" type="text/javascript"></script>

</head>

<body>


	<form id="inputForm" action="${ctx}/file/attFile/${action}" method="post" class="form-horizontal">
	
			<legend><small><fmt:message key="common.form.create"/><fmt:message key="entity.attFile" bundle="${file}"/></small></legend>
			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.attFile.name" bundle="${file}"/>:</label>
				<div class="controls">
					<textarea id="name" name="name"  class="input-large"   maxlength="2,000"   required ><c:out value="${model.name }"/></textarea>
<span class="icon-asterisk  icon-orange"></span>
				</div>
			</div>
				
		
		
			<div class="control-group">
				<label for="model_createTime" class="control-label"><fmt:message key="entity.attFile.createTime" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="model_createTime" name="createTime"  value="<tags:dateTime value="${ model.createTime}" />" class="input date"   />

					<script language="javascript">
					$(document).ready(function() {  
					       //$('#expireDate').datepicker(datepicker_i18n);  
					       $('#model_createTime').datetimepicker(datepicker_i18n);
					   });  
					</script>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label for="model_lastModifyTime" class="control-label"><fmt:message key="entity.attFile.lastModifyTime" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="model_lastModifyTime" name="lastModifyTime"  value="<tags:dateTime value="${ model.lastModifyTime}" />" class="input date"   />

					<script language="javascript">
					$(document).ready(function() {  
					       //$('#expireDate').datepicker(datepicker_i18n);  
					       $('#model_lastModifyTime').datetimepicker(datepicker_i18n);
					   });  
					</script>
				</div>
			</div>	
		
		
			<div class="control-group">
				<label for="type" class="control-label"><fmt:message key="entity.attFile.type" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="type" name="type"  value="<c:out value="${model.type }"/>" class="input-large"   maxlength="50"    required/>
<span class="icon-asterisk  icon-orange"></span>
					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="size" class="control-label"><fmt:message key="entity.attFile.size" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="size" name="size" value="${model.size }"  class="input-large digits "   />

				</div>
			</div>
		
			<div class="control-group">
				<label for="hashCode" class="control-label"><fmt:message key="entity.attFile.hashCode" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="hashCode" name="hashCode"  value="<c:out value="${model.hashCode }"/>" class="input-large"   maxlength="200"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="path" class="control-label"><fmt:message key="entity.attFile.path" bundle="${file}"/>:</label>
				<div class="controls">
					<textarea id="path" name="path"  class="input-large"   maxlength="2,000"    ><c:out value="${model.path }"/></textarea>

				</div>
			</div>
				
		
		



			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		
	</form>
	 
</body>
</html>
