<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<fmt:setBundle basename="i18n.org_message" var="org"/>
<fmt:setBundle basename="i18n.core_message" var="core"/>
<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.employee" bundle="${org}"/></title>
	
	<script>
	$(document).ready(function() {
		$('#radioset').buttonset();
		//if ckeditor required
		$('#inputForm').submit(function(){
	        $('textarea.ckeditor').each(function () {
	           var $textarea = $(this);
	           $textarea.val(CKEDITOR.instances[$textarea.attr('name')].getData());
	        });
	        var createUser = $('input[type="radio"][name="createUser"]:checked').val();
	        if(createUser != null && createUser === "true"){
	        	//alert("createUser");
		        $("#userloginName").prop("disabled", false);
		        $("#plainPassword").prop("disabled", false);
		        $("#confirmPassword").prop("disabled", false);

	        }else {
	        	//alert("selectUser");
		        $("#userloginName").prop("disabled", true);
		        $("#plainPassword").prop("disabled", true);
		        $("#confirmPassword").prop("disabled", true);
	        }
	        
	    });

		$("#inputForm").validate({
			submitHandler : function(form) { 
				$("input[type=submit]",form).prop('disabled', true);
				   form.submit();  
				 }  
		});
		 $('#user_select_div').hide();
		$("#radioset input[name='createUser']").click(function () {
		    if ($(this).val() == "true" && $(this).is(":checked")) {
		        $('#user_select_div').hide();
		        $('#user_add_div').show();
		    }else{
		        $('#user_select_div').show();
		        $('#user_add_div').hide();
		    }
		});
	});
	function reValidate(){
		$("#inputForm").removeData("validator");
		$("#inputForm").validate({
			submitHandler : function(form) { 
				$("input[type=submit]",form).prop('disabled', true);
				   form.submit();  
				 }  
		});		
	}
		
	</script>
	<script src="${ctx}/static/javascript/ckeditor/ckeditor.js" type="text/javascript"></script>

</head>

<body>


	<form id="inputForm" action="${ctx}/org/employee/${action}" method="post" class="form-horizontal">
	
			<legend><small><fmt:message key="common.form.create"/><fmt:message key="entity.employee" bundle="${org}"/></small></legend>
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">x</button>${message}</div>
	</c:if>


			<input type="hidden" name="id" value="${model.id }">
			<div class="control-group">
				<label for="name" class="control-label"><fmt:message key="entity.organization.name" bundle="${org}"/>:</label>
				<div class="controls">
					<input type="text" id="name" name="name"  value="<c:out value="${model.name }"/>" class="input-large"   maxlength="200"    required/>
<span class="icon-asterisk  icon-orange"></span>
					
				</div>
			</div>
			<div class="control-group">
				<label for="parentLabel" class="control-label"><fmt:message key="entity.employee.parent" bundle="${org}"/>:</label>
				
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
						url:"${ctx}/org/department/treejson",
						autoParam:["id","name=name"],
						type:"get"
					},
					idPaths:'<c:out value="${model.hierarchyId }"/>'
				};

					 var parentDialog= $("#parentIdDialog").selectDialog({
				 name:"parent",
			    	id: $("#parentId"),
					label: $("#parentLabel"),
					ajaxUrl: '${ctx}/org/department/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, treeOptions:parentIdSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.employee.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.employee.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#parent_selector").click(function(){
				 parentDialog.showSelectDialog();
			 });
			</script>			
			<div class="control-group">
				<label for="manageDepartmentLabel" class="control-label"><fmt:message key="entity.employee.manageDepartment" bundle="${org}"/>:</label>
				
				<div class="controls">
				
					<input type="text" id="manageDepartmentLabel" name="manageDepartmentLabel" value="<tags:listToString list="${model.manageDepartment}" property ="name"/>"  class="input-large"    disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="manageDepartment_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="manageDepartmentId" name="manageDepartmentId" value="<tags:listToString list="${model.manageDepartment}" property ="id"/>" >
                   
				</div>
				<div id="manageDepartmentIdDialog"></div>
			</div>
			<script>
		
					 var manageDepartmentDialog= $("#manageDepartmentIdDialog").selectDialog({
				 name:"manageDepartment",
			    	id: $("#manageDepartmentId"),
					label: $("#manageDepartmentLabel"),
					ajaxUrl: '${ctx}/org/department/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: true, treeOptions:parentIdSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.department.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.department.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#manageDepartment_selector").click(function(){
				 manageDepartmentDialog.showSelectDialog();
			 });
			</script>

			<div class="control-group">
				<label for="postLabel" class="control-label"><fmt:message key="entity.employee.post" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="postLabel" name="postLabel" value="${model.post.name}"  class="input-large"  disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="post_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="postId" name="postId" value="${model.post.id}" >
                    
				</div>
				<div id="postIdDialog"></div>
			</div>
			<script>
			var postSetting = {
					async: {
						enable: true,
						url:"${ctx}/org/post/treejson",
						autoParam:["id","name=name"],
						type:"get"
					}
				};

					 var postDialog= $("#postIdDialog").selectDialog({
				 name:"post",
			    	id: $("#postId"),
					label: $("#postLabel"),
					ajaxUrl: '${ctx}/org/post/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: false, treeOptions:postSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.post.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.post.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#post_selector").click(function(){
				 postDialog.showSelectDialog();
			 });
			</script>	
			<div class="control-group">
				<label for="groupsLabel" class="control-label"><fmt:message key="entity.employee.groups" bundle="${org}"/>:</label>
				
				<div class="controls">
					<input type="text" id="groupsLabel" name="groupsLabel" value="<tags:listToString list="${model.groups}" property ="name"/>"  class="input-large"   disabled/>
					<span class="dialog-button">
					 <a href="javascript:void(0)" id="groups_selector" class="ui-state-default ui-corner-all anchor-button">
                        <span class="ui-icon ui-icon-newwin"></span>
                        <fmt:message key="common.form.dialog.select"/>
                    </a>
                    </span>
                    <input type="hidden" id="groupsId" name="groupsId" value="<tags:listToString list="${model.groups}" property ="id"/>" >
                   
				</div>
				<div id="groupsIdDialog"></div>
			</div>
			<script>
			var groupsSetting = {
					async: {
						enable: true,
						url:"${ctx}/org/group/treejson",
						autoParam:["id","name=name"],
						type:"get"
					}

				};

	
					 var groupsDialog= $("#groupsIdDialog").selectDialog({
				 name:"groups",
			    	id: $("#groupsId"),
					label: $("#groupsLabel"),
					ajaxUrl: '${ctx}/org/group/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
					conditionListtype:"or" , //"and" or "or"
					isMultiSelect: true, treeOptions:groupsSetting,
					singleSelectedReturn: true,
					columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.group.name"  bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
					conditions:[{name:"name",label:"<fmt:message key="entity.group.name"  bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
					messages: [<fmt:message key="common.form.dialog.messages"/>]
			    });
			 $("#groups_selector").click(function(){
				 groupsDialog.showSelectDialog();
			 });
			</script>			


		
		
			<div class="control-group">
				<label for="virtual" class="control-label"><fmt:message key="entity.employee.virtual"  bundle="${org}"/>:</label>
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
		

			<c:if test="${action eq 'save' }">
			<div class="control-group">
					<label for="user.loginName" class="control-label"></label>
					<div class="controls">
						 <span id="radioset">
                            <input type="radio" id="createUser" name="createUser"  checked="checked"  value="true"/><label for="createUser"><fmt:message key="entity.employee.createUser"  bundle="${org}"/></label>
                            <input type="radio" id="selectUser" name="createUser"  value="false"/><label for="selectUser"><fmt:message key="entity.employee.selectUser"  bundle="${org}"/></label>
                        </span>
					</div>
			</div>
			
			<div id="user_add_div">
				<div class="control-group">
					<label for="userloginName" class="control-label"><fmt:message key="core.user.loginName"/>:</label>
					<div class="controls">
						<input type="text" id="userloginName" name="user.loginName"  value="<c:out value="${model.user.loginName }"/>" class="input-large"   maxlength="200"    required/>
						<span class="icon-asterisk  icon-orange"></span>
					</div>
				</div>
				

				<div class="control-group">
					<label for="plainPassword" class="control-label"><fmt:message key="core.user.password"/>:</label>
					<div class="controls">
						<input type="password" id="plainPassword" name="user.plainPassword" class="input-large " required/>
						<span class="icon-asterisk  icon-orange"></span>
					</div>
				</div>
				<div class="control-group">
					<label for="confirmPassword" class="control-label"><fmt:message key="core.user.confirmPassword"/>:</label>
					<div class="controls">
						<input type="password" id="confirmPassword" name="user.confirmPassword" class="input-large " equalTo="#plainPassword" required/>
						<span class="icon-asterisk  icon-orange"></span>
					</div>
				</div>
				
			</div>
			</c:if>
			<c:if test="${action eq 'update' }">
			<div class="control-group">
					<label class="control-label"></label>
					<div class="controls">
						 <div id="radioset">
                            <input type="radio" id="createUser" name="createUser"  checked="checked"  value="true"/><label for="createUser"><fmt:message key="entity.employee.changeUserPassword"  bundle="${org}"/></label>
                            <input type="radio" id="selectUser" name="createUser"  value="false"/><label for="selectUser"><fmt:message key="entity.employee.selectUser"  bundle="${org}"/></label>
                        </div>
					</div>
			</div>
			
			<div id="user_add_div">
				<div class="control-group">
					<label for="userloginName" class="control-label"><fmt:message key="core.user.loginName"/>:</label>
					<div class="controls">
						<input type="text" id="userloginName" name="user.loginName"  value="<c:out value="${model.user.loginName }"/>" class="input-large"   maxlength="200"    required/>
						<span class="icon-asterisk  icon-orange"></span>
					</div>
				</div>
				

				<div class="control-group">
					<label for="plainPassword" class="control-label"><fmt:message key="core.user.password"/>:</label>
					<div class="controls">
						<input type="password" id="plainPassword" name="user.plainPassword" class="input-large " />
						<span class="icon-asterisk  icon-orange"></span>
					</div>
				</div>
				<div class="control-group">
					<label for="confirmPassword" class="control-label"><fmt:message key="core.user.confirmPassword"/>:</label>
					<div class="controls">
						<input type="password" id="confirmPassword" name="user.confirmPassword" class="input-large " equalTo="#plainPassword" />
						<span class="icon-asterisk  icon-orange"></span>
					</div>
				</div>
				
			</div>
			
			</c:if>

			<div id="user_select_div">
				<div class="control-group">
					<label for="userLabel" class="control-label"><fmt:message key="entity.employee.user" bundle="${org}"/>:</label>
					
					<div class="controls">
						<input type="text" id="userLabel" name="userLabel" value="${model.user.name}"  class="input-large"  disabled/>
						<span class="dialog-button">
						 <a href="javascript:void(0)" id="user_selector" class="ui-state-default ui-corner-all anchor-button">
	                        <span class="ui-icon ui-icon-newwin"></span>
	                        <fmt:message key="common.form.dialog.select"/>
	                    </a>
	                    </span>
	                    <input type="hidden" id="userId" name="userid" value="${model.userid}" >
	                    
					</div>
					<div id="userIdDialog"></div>
				</div>
				<script>
	
						 var userDialog= $("#userIdDialog").selectDialog({
					 name:"user",
				    	id: $("#userId"),
						label: $("#userLabel"),
						ajaxUrl: '${ctx}/core/user/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
						conditionListtype:"or" , //"and" or "or"
						isMultiSelect: false,
						singleSelectedReturn: true,
						columns: [{name:"id",label:"ID"},{name:"name",label:"<fmt:message key="entity.employee.name" bundle="${org}"/>"}], //array of column;column{name:"name",label:"label"}
						conditions:[{name:"name",label:"<fmt:message key="entity.employee.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
						messages: [<fmt:message key="common.form.dialog.messages"/>]
				    });
				 $("#user_selector").click(function(){
					 userDialog.showSelectDialog();
				 });
				</script>
			</div>


			<div class="form-actions">
				<input id="submit_btn" class="btn btn-primary" type="submit" value="<fmt:message key="common.form.submit"/>"/>&nbsp;	
				<input id="cancel_btn" class="btn" type="button" value="<fmt:message key="common.form.back"/>" onclick="history.back()"/>
			</div>
		
	</form>
	 
</body>
</html>
