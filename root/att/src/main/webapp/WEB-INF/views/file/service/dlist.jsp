<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
	<title><fmt:message key="entity.attachment" bundle="${file}"/></title>
	<meta name="decorator" content="http-service"/>

	<script>
	$.ajaxSetup({cache:false});
	var accessDeniedMsg = '<fmt:message key="common.error.401"/>';



	function getResult(param){
		var retval = new Object();
		var rows = new Array();
		$("tbody.files>tr").each(function(index){
			var attachment = new Object();
			attachment.id = $(".id-checkbox",this).val();
			rows.push(attachment);
		});
		retval.rows = rows;
		return JSON.stringify(retval);
		//console.log("call function getResult.param:"+param.message);
		//return "function ; getResult";
	};
	var download_file = new Object();
	function downloadSelected(){
					var ids = $.rowSelectableTable("#listTable").getSelectedIds();
					if(ids){
						if(typeof(download_file.iframe)== "undefined")
						{
							var iframe = document.createElement("iframe");
							download_file.iframe = iframe;
							document.body.appendChild(download_file.iframe); 
						}
						// alert(download_file.iframe);
						download_file.iframe.src = "${ctx}/file/attachment/download/"+ids;

						download_file.iframe.style.display = "none";

						return;
					}else{
						$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="file.error.noSelectDataForDownload"  bundle="${file}"/>');
					}
	}


	$(document).ready(function() {

		$("#listTable").rowSelectableTable();

				 createTableColumnPseudoClasses();
				 $("body").lkHttpService();

	});
	

	function createTableColumnPseudoClasses() {
		 
	    $("#list tr").each( function()  {
	        var counter = 1;
	        $(this).children("td,th").each( function()  {
	            $(this).addClass("list-column-" + counter);
	            counter++;
	        });
	    });
	}

	
	</script>
	<style>
	.accessDenied{
	background: url(${ctx }/static/images/401.jpg) no-repeat center !important
	}
	<c:if test="${not param['short'] }">
	#list table .list-column-1 {
        width: 50px; 
    }
 
    #list table .list-column-2 {
        width: 100px;
    }
 
    #list table .list-column-3 {
        width: auto;
    }
    #list table .list-column-4 {
        width: 100px;
    }
    #list table .list-column-5 {
        width: 100px;
    }
    #list table .list-column-6 {
        width: 100px;
    }
    </c:if>
    <c:if test="${param['short'] }">
	#list table .list-column-1 {
        width: 50px; 
    }
    #list table .list-column-2 {
        width: auto;
    }
    #list table .list-column-3 {
        width: 100px;
    }
    #list table .list-column-4 {
        width: 100px;
    }
    #list table .list-column-5 {
        width: 100px;
    }
    </c:if>
body {
    padding-top: 0px;
}
.progress{
	margin-bottom:0px;
}
#fileupload{
	margin-bottom:0px;
}
.table{
	margin-bottom:0px;
}
	</style>
</head>

<body>
<fieldset>


	  <div class="tab-content">

 <div id="list">
			<div class="conditionPanel pull-right">
			
			<button type="button" class="btn btn-primary" id="download_btn" onclick="downloadSelected();"><fmt:message key="file.form.download"  bundle="${file}"/></button>
			</div>

			<table id="listTable"  role="presentation" class="table table-striped table-bordered table-condensed ">
			
					<thead><tr><th><label class="checkbox"><input type="checkbox" class="lk-checkAll"></label></th>
		<c:if test="${not param['short'] }">
		<th><fmt:message key="entity.attachment.title" bundle="${file}"/></th>
		</c:if>
		<th><fmt:message key="entity.attachment.name" bundle="${file}"/></th>
		<th><fmt:message key="entity.attachment.size" bundle="${file}"/></th>
		<th><fmt:message key="entity.attachment.createTime" bundle="${file}"/></th>
		<c:if test="${not param['short'] }">
		<th><fmt:message key="entity.attachment.remark" bundle="${file}"/></th>
		</c:if>
		</tr></thead>
		<tbody  class="files">
		<c:forEach items="${page.content}" var="attachment">
		
			<tr><td><label class="checkbox"><input type="checkbox" class="lk-check id-checkbox"   value="${attachment.id }"></label></td>
		<c:if test="${not param['short'] }">
			<td><div class="input-append">
				<input type="text"  oid="${attachment.id }" data-provide="typeahead" class="title-input input-small" name="title" value="${attachment.title}"/>
			
				</div>
			</td>
			</c:if>
			<td><span class="lk-row-bar pull-right" oid="${attachment.id }"></span><span  class="list-subject"><a href="${ctx}/file/attachment/view/${attachment.id}">${attachment.name}</a></span></td>
			<td><tags:filesize size="${attachment.size}"/></td>
			<td><tags:date value="${attachment.createTime}"/></td>
		<c:if test="${not param['short'] }">
			<td><div class="input-append">
				<input type="text"  oid="${attachment.id }" data-provide="typeahead" class="remark-input input-small" name="remark" value="${attachment.remark}"/>
				
				</div></td>
		</c:if>				
			</tr>
		</c:forEach>
		
		</tbody>
			</table>
		</div>
	  </div>
		
</fieldset>

</body>
</html>

