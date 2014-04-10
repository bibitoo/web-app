<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.org_message" var="org"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="common.form.create"/><fmt:message key="entity.authorization" bundle="${org}"/></title>
	<script>

	
	var setting = {
			check: {
				enable: true, chkboxType : { "Y" : "", "N" : "" }
			},
			async: {
				enable: true,
				url:"${organizationModulePath}/org/organization/treejsonp",
				autoParam:["id","name=name"],
				type:"get",
				dataType:"jsonp"
			},
			callback:{onCheck: zTreeOnCheck, onAsyncSuccess: departmentOnAsyncSuccess}

		};
	var idPaths = '${param["hierarchyId"]}'.split('/');

	var firstAsyncSuccessFlag = 0;
	function departmentOnAsyncSuccess(event, treeId, treeNode, msg) {
		var tree_organization = $.fn.zTree.getZTreeObj("tree_organization");
		if(treeNode){
			treeNode.iconSkin = treeNode.orgType;
			tree_organization.updateNode(treeNode);
			for(var i in treeNode.children){
				var node = treeNode.children[i];
				node.iconSkin = node.orgType;
				tree_organization.updateNode(node);
			}
		}else{
			var nodes = tree_organization.getNodes();
			for(var i = 0; i < nodes.length; i++){
				var node = nodes[i];
				if(node){
					node.iconSkin = node.orgType;
					tree_organization.updateNode(node);
				}		
			}
		}
		
		if(idPaths[0] == ""){
			if (firstAsyncSuccessFlag == 0) {
				firstAsyncSuccessFlag = 1;
				var nodes = tree_organization.getNodes();
				tree_organization.expandNode(nodes[0], true);
			}
		}
		lk_expandAjaxTreeNode(treeNode,idPaths,tree_organization);
	};
	


	$(document).ready(function() {
		$("#sub_menu").menu();
		ztree = $.fn.zTree.init($("#tree_organization"), setting);
		$("#menu-collapse").togglepanels();
	});
	
	function zTreeOnCheck(event, treeId, treeNode) {
	    if(treeNode.checked){
	    	addCol(treeNode.id,treeNode.name);
	    }else{
	    	delCol(treeNode.id,treeNode.name);
	    }
	};
	function delCol(orgId,name){
		$('#contentTable th').each(function(){
			if($(this).attr("orgid") == orgId){
				$(this).remove();
			}
		});
		$('#contentTable input[type=checkbox]').each(function(){
			if($(this).attr("orgid") == orgId){
				$(this).parent("td").remove();
			}
		});
	}
	function addCol(orgId,name){
		var $head = $("<th>", {orgid: orgId}).append(name);

		$("#contentTable tr:first").append($head);
    	$.ajax({
            cache: false,
            type: "GET",
            url:"${ctx}/core/authorization/listjson",
            data:"search_EQ_organizationId="+orgId,
            async: true,
            error: function(request) {
               
                $().toastmessage('showNoticeToast', '<fmt:message key="common.error.unknown"/>');
            },
            success: function(data) {
        			$('#contentTable tr:not(:first)').each(function(index){
        				var role = $(this).attr("roleid");
        				
        				var row = getRow(data.rows,role);
        				var $chk;
        				if(row){
       					 $chk = $("<input>", {id: role+"_"+orgId,type:"checkbox",checked:"true",orgid:orgId,roleid:role});
        				}else{
        					 $chk = $("<input>", {id: role+"_"+orgId,type:"checkbox",orgid:orgId,roleid:role});
        				}
        				$chk.click(function(){ 
        					if($(this).attr("checked")){
        						//alert("add "+$(this).attr("orgid")+" "+$(this).attr("roleid"))
        						authorizationOper($(this).attr("orgid"), $(this).attr("roleid"),"add");
        					}else{
        						authorizationOper($(this).attr("orgid"), $(this).attr("roleid"),"delete");
        					}
        				});
        				var $chktd = $("<td>").append($chk);
        		       $(this).append($chktd);
        		
        		 });
            	
            }
        });

	}
	function authorizationOper(orgid, roleid,oper){
		$.post("${ctx}/core/authorization/authorize/"+oper, { Action: "post", Name: "form", organizationId: orgid, roleId: roleid },
				function (data, textStatus){
					//alert(data.result);
				}, "json");
	}
	function getRow(responseRows,roleid){
		for(var i=0;i<responseRows.length;i++){
			if(responseRows[i].roleId == roleid){
				return responseRows[i];
			}
		}
	}
	
	</script>
</head>

<body>
<fieldset>
	<legend><small><fmt:message key="entity.authorization" bundle="${org}"/></small></legend>

	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success"><button data-dismiss="alert" class="close">x</button>${message}</div>
	</c:if>
	<div class="row">	<div class="span3">
		<div id="menu-collapse">
			<div>
	             <h3><a href="#"><fmt:message key="entity.organization" bundle="${org}"/></a></h3>
	             <div><ul id="tree_organization" class="ztree"></ul></div>
	         </div>
     	</div>
	
	</div>
	<div class="span9">
	
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th><fmt:message key="entity.role" bundle="${org}"/> \ <fmt:message key="entity.organization" bundle="${org}"/></th>
		</tr></thead>
		<tbody>
		
		<c:forEach items="${roles}" var="role">
		<tr roleid="${role.id}"><td><fmt:message key="${role.name}"/></td></tr>
		</c:forEach>
		</tbody>
	</table>
	    </div>
	    
	</div>
	
</fieldset>
</body>
</html>

