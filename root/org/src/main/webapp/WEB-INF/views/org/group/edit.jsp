<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.group" bundle="${org}"/></title>
	
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


	<form id="inputForm" action="${ctx}/org/group/${action}" method="post" class="form-horizontal">
	
			<legend><small><fmt:message key="common.form.create"/><fmt:message key="entity.group" bundle="${org}"/></small></legend>



			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.organization.name" bundle="${org}"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name"  value="<c:out value="${model.name }"/>" class="input-large"   maxlength="200"    required/>
<span class="icon-asterisk  icon-orange"></span>
					
				</div>
			</div>
		
						<div class="control-group">
				<label for="parentLabel" class="control-label"><fmt:message key="entity.group.parent" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="parentLabel" name="parentLabel" value="${model.parent.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="parent_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="parentId" name="parentId" value="${model.parent.id}" >
                    
				</div>
				<div id="parentIdDialog"></div>
			</div>
			<script>
			var parentIdSetting = {
					async: {
						enable: true,
						url:"${ctx}/org/group/treejson",
						autoParam:["id","name=name"],
						type:"get"
					},
					idPaths:'<c:out value="${model.hierarchyId }"/>'

				};
		
					 var parentDialog= $("#parentIdDialog").selectDialog({
				 name:"parent",
			    	id: $("#parentId"),
					label: $("#parentLabel"),
					ajaxUrl: '${ctx}/org/group/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false,  treeOptions:parentIdSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.group.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.group.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#parent_selector").click(function(){
				 parentDialog.showSelectDialog();
			 });
			</script>	
			
			<div class="control-group">
				<label for="organizationsLabel" class="control-label"><fmt:message key="entity.group.organizations" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="organizationsLabel" name="organizationsLabel" value="<tags:listToString list="${model.organizations}" property ="name"/>"  class="input-large"   disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="organizations_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="organizationsId" name="organizationsId" value="<tags:listToString list="${model.organizations}" property ="id"/>" >
                    
				</div>
				<div id="organizationsIdDialog"></div>
			</div>
			<script>
			var organizationsSetting = {
					async: {
						enable: true,
						url:"${ctx}/org/organization/treejson",
						autoParam:["id","name=name"],
						type:"get"
					}

				};

					 var organizationsDialog= $("#organizationsIdDialog").selectDialog({
				 name:"organizations",
			    	id: $("#organizationsId"),
					label: $("#organizationsLabel"),
					ajaxUrl: '${ctx}/org/organization/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: true, treeOptions:organizationsSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#organizations_selector").click(function(){
				 organizationsDialog.showSelectDialog();
			 });
			</script>
					
			<div class="control-group">
				<label for="virtual" class="control-label"><fmt:message key="entity.group.virtual"  bundle="${org}"/>:</label>
				<label class="controls">
				    <input type="checkbox"  id="_virtual"  ${model.virtual?"checked":"" }> 
				    <input type="hidden"  id="virtual" name="virtual" value="${model.virtual?"true":"false"}"/>
				    <script>$("#_virtual").change(function() {
							var isCheck = $(this).is(':checked');
							$("#virtual").val(isCheck);
						});
				    </script>
				    
				  </label>
			 </div>
		
			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		
	</form>
	 
</body>
</html>
