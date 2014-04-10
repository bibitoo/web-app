<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.file_message" var="file"/>
<fmt:setBundle basename="i18n.file_message" var="file"/>
<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.attachment" bundle="${file}"/></title>
	
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


	<form id="inputForm" action="${ctx}/file/attachment/${action}" method="post" class="form-horizontal">
	
			<legend><small><fmt:message key="common.form.create"/><fmt:message key="entity.attachment" bundle="${file}"/></small></legend>
			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.attachment.name" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name"  value="<c:out value="${model.name }"/>" class="input-large"   maxlength="200"    required/>
<span class="icon-asterisk  icon-orange"></span>
					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="userid" class="control-label"><fmt:message key="entity.attachment.userid" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="userid" name="userid"  value="<c:out value="${model.userid }"/>" class="input-large"   maxlength="36"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="model_createTime" class="control-label"><fmt:message key="entity.attachment.createTime" bundle="${file}"/>:</label>
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
				<label for="model_lastModifyTime" class="control-label"><fmt:message key="entity.attachment.lastModifyTime" bundle="${file}"/>:</label>
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
				<label for="type" class="control-label"><fmt:message key="entity.attachment.type" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="type" name="type"  value="<c:out value="${model.type }"/>" class="input-large"   maxlength="200"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="systemCode" class="control-label"><fmt:message key="entity.attachment.systemCode" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="systemCode" name="systemCode"  value="<c:out value="${model.systemCode }"/>" class="input-large"   maxlength="200"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="size" class="control-label"><fmt:message key="entity.attachment.size" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="size" name="size" value="${model.size }"  class="input-large digits "   />

				</div>
			</div>
		
			<div class="control-group">
				<label for="objectId" class="control-label"><fmt:message key="entity.attachment.objectId" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="objectId" name="objectId"  value="<c:out value="${model.objectId }"/>" class="input-large"   maxlength="36"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="key" class="control-label"><fmt:message key="entity.attachment.key" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="key" name="key"  value="<c:out value="${model.key }"/>" class="input-large"   maxlength="50"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="param1" class="control-label"><fmt:message key="entity.attachment.param1" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="param1" name="param1"  value="<c:out value="${model.param1 }"/>" class="input-large"   maxlength="200"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="param2" class="control-label"><fmt:message key="entity.attachment.param2" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="param2" name="param2"  value="<c:out value="${model.param2 }"/>" class="input-large"   maxlength="200"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="attFileId" class="control-label"><fmt:message key="entity.attachment.attFileId" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="attFileId" name="attFileId"  value="<c:out value="${model.attFileId }"/>" class="input-large"   maxlength="36"    required/>
<span class="icon-asterisk  icon-orange"></span>
					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="companyId" class="control-label"><fmt:message key="entity.attachment.companyId" bundle="${file}"/>:</label>
				<div class="controls">
					<input type="text" id="companyId" name="companyId"  value="<c:out value="${model.companyId }"/>" class="input-large"   maxlength="36"    />

					
				</div>
			</div>
		
		
			<div class="control-group">
				<label for="deleted" class="control-label"><fmt:message key="entity.attachment.deleted"  bundle="${file}"/>:</label>
				<label class="controls">
				    <input type="checkbox"  id="_deleted"  ${model.deleted?"checked":"" }> 
				    <input type="hidden"  id="deleted" name="deleted" value="${model.deleted?"true":"false"}"/>
				    <script>$("#_deleted").change(function() {
							var isCheck = $(this).is(':checked');
							$("#deleted").val(isCheck);
						});
				    </script>
				    
				  </label>
			 </div>
		
		


			<div class="control-group">
				<label for="folderLabel" class="control-label"><fmt:message key="entity.attachment.folder" bundle="${file}"/>:</label>
				
				<div class="controls">
					<input type="text" id="folderLabel" name="folderLabel" value="${model.folder.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="folder_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="folderId" name="folderId" value="${model.folder.id}" >
                    
				</div>
				<div id="folderIdDialog"></div>
			</div>
			<script>
		
					 var folderDialog= $("#folderIdDialog").selectDialog({
				 name:"folder",
			    	id: $("#folderId"),
					label: $("#folderLabel"),
					ajaxUrl: '${ctx}/file/folder/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, 
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.folder.name" bundle="${file}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.folder.name" bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
					msgs: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#folder_selector").click(function(){
				 folderDialog.showSelectDialog();
			 });
			</script>	

			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		
	</form>
	 
</body>
</html>
