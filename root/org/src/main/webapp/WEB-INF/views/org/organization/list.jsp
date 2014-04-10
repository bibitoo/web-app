<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.organization" bundle="${org}"/></title>
	<script>
	var ajaxMsg = '<fmt:message key="common.error.ajax"/>';
	$(document).ajaxError(function(event, jqxhr, settings, exception) {  
	    window.console && console.log(exception);  
  	  $().toastmessage('showErrorToast', ajaxMsg);
	});
	var columns = ["name","virtual","createTime","lastModifyTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	
	var idPaths = '${param["hierarchyId"]}'.split('/');
	var setting = {
			async: {
				enable: true,
				url:"${ctx}/org/department/treejson",
				autoParam:["id","name=name"],
				type:"get"
			},
			callback:{onClick:organizationTreeOnClick, onAsyncSuccess: organizationOnAsyncSuccess}

		};
	function organizationOnAsyncSuccess(event, treeId, treeNode, msg) {
		var tree_organization = $.fn.zTree.getZTreeObj("tree_organization");
		lk_expandAjaxTreeNode(treeNode,idPaths,tree_organization);
	};
	


	function organizationTreeOnClick(event, treeId, treeNode) {
		$.paginationList("#list").addSelectedCondition("search_EQ_parent.id",'<fmt:message key="entity.department" bundle="${org}"/>:'+treeNode.name,treeNode.id);

	}
	
	var paginationList;
	var ztree ;
	$(document).ready(function() {
		$("#sub_menu").menu();
		ztree = $.fn.zTree.init($("#tree_organization"), setting);
		ztree.setting.treeObj.bind("expandToLeaf.zTree",function(){
			var treeNode = ztree.getSelectedNodes()[0];
			if(treeNode){
				$.paginationList("#list").addSelectedCondition("search_EQ_parent.id",'<fmt:message key="entity.department" bundle="${org}"/>:'+treeNode.name,treeNode.id);
				
			}
		});
		 $("#menu-collapse").togglepanels();
				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:true,
			useSelectedPanel:true,//isCheckSelect:false,
				ajaxUrl: '${ctx}/org/organization/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
						{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}
						,
						{name:"virtual",label:"<fmt:message key="entity.organization.virtual" bundle="${org}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.organization.createTime" bundle="${org}"/>"}
						,
						{name:"lastModifyTime",label:"<fmt:message key="entity.organization.lastModifyTime" bundle="${org}"/>"}
						
				    
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"name",label:"<fmt:message key="entity.organization.name" bundle="${org}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
				$('#radioset').buttonset();
				<c:if test="${not empty message}">$().toastmessage('showNoticeToast', '${message}');</c:if>

	});
	

		
	
	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				return '<a href="${ctx}/org/' + row['orgType'].toLowerCase() + '/view/'+row['id']+'">'+row[column]+'</a>';
			}else{
				return " ";
			}
		}

  		if(column == 'virtual'){
			if(row[column]){
				return '<fmt:message key="common.form.boolean.yes"/>';
			}else{
				return "<fmt:message key="common.form.boolean.no"/>";
			}
		}

  		if(column == 'createTime'){
			if(row[column]){
				return $.format.longDate(new Date(row[column]));
			}else{
				return " ";
			}
		}

  		if(column == 'lastModifyTime'){
			if(row[column]){
				return $.format.longDate(new Date(row[column]));
			}else{
				return " ";
			}
		}

		

		return row[column];
	}

	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/org/organization/disableAll",{ids:ids},function (data, textStatus){
							if(data.status == 'error'){
								$().toastmessage('showNoticeToast', data.message);
							}else{
								$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
								$.paginationList("#list").refreshData();
							}
						});
						return;
					}
				}
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
			  }
			});
	}
	function switchType(orgType,obj){
		$('#search_EQ_orgType').val(orgType);$.paginationList('#list').refreshData();
		$("#seq_nav>li").removeClass("active");
		$(obj).closest("li").addClass("active");
	}
	function createOrganization(){
		var orgType = $("#search_EQ_orgType").val();
		if(!orgType){
			$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
			return;
		}else{
			window.location.href="${ctx}/org/" + orgType.toLowerCase() + "/create?parentId=" + $("input[name='search_EQ_parent.id']").val();
		}
	}
		
	</script>
</head>

<body>
<fieldset>
<c:set var="menuKey" value="Organization"/>
<%@ include file="../menu.jsp" %>



<div class="row">
	<div class="span3">

		<div id="menu-collapse">
			<div>
	             <h3><a href="#">&nbsp;</a></h3>
	             <div><ul id="tree_organization" class="ztree"></ul></div>
	         </div>
     	</div>
	
	</div>
	<div class="span9">
		<div id="listContainer">
			<div id="list">
				<div class="conditionPanel">
				
					<input type="hidden" id="search_EQ_parentId" name="search_EQ_parent.id" value="${param["search_EQ_parent.id"]}"/>
					<input type="hidden" id="search_EQ_orgType" name="search_EQ_orgType" value="${param['orgType'] }"/>
					<div id="operation-bar" class="span5.5">
				<shiro:hasAnyRoles name="orgadmin,admin">
					<button type="button" class="btn btn-primary" id="add_btn" onclick="createOrganization();"><fmt:message key="common.form.create"/></button>
					<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
					</shiro:hasAnyRoles>
					</div>
				        <span id="radioset">
                            <input type="radio" id="radio1" name="orgType" value="Company"  <c:if test="${param['orgType'] == 'Company' }"> checked="checked"</c:if>  onclick="switchType('Company',this)"/><label for="radio1"><fmt:message key="entity.company" bundle="${org}"/></label>
                            <input type="radio" id="radio2" name="orgType"  value="Department"   <c:if test="${param['orgType'] == 'Department' }"> checked="checked"</c:if>  onclick="switchType('Department',this)"/><label for="radio2"><fmt:message key="entity.department" bundle="${org}"/></label>
                            <input type="radio" id="radio3" name="orgType"  value="Employee" <c:if test="${param['orgType'] == 'Employee' }"> checked="checked"</c:if>  onclick="switchType('Employee',this)"/><label for="radio3"><fmt:message key="entity.employee" bundle="${org}"/></label>
                            <input type="radio" id="radio4" name="orgType"  value="" <c:if test="${empty param['orgType'] || param['orgType'] == '' }"> checked="checked"</c:if>  onclick="switchType('',this)"/><label for="radio4"><fmt:message key="entity.all" bundle="${org}"/></label>
                        </span>
				</div>
				
			</div>
		</div>
	</div>
</div>
</fieldset>
</body>
</html>

