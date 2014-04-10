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
	var dialogMsg = [<fmt:message key="common.form.dialog.messages"/>];

	var columns = ${_service_file_columns};
	var columnLabels = ${_service_file_columnLabels};


	

	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	
	var paginationList;

	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				if(row["fileBaseType"] == "Folder"){
					var str = '<i class="lk-filetype lk-file-folder"></i>';
					str += '<span class="lk-row-bar pull-right" oid="'+row['id']+'" oname="'+row[column]+'"></span>'+'<span  class="list-subject"><a href="#" onclick="appendFolder(\''+row['id']+'\',\''+row[column]+'\')" title="'+row[column]+'">'+row[column]+'</a></span>';
					return str;
				}else{
					var filtype = lkFileType[row['type']];
					if(!filtype){
						filtype = "lk-file-file";
					}
					var str = '<i class="lk-filetype '+filtype+'"></i>';
					str += '<span class="lk-row-bar pull-right" oid="'+row['id']+'" oname="'+row[column]+'"></span>'+'<span  class="list-subject"><a href="${ctx}/file/attachment/download/'+row['id']+'" title="'+row[column]+'">'+row[column]+'</a></span>';
					return str;
				}
				
			}else{
				return " ";
			}
		}

  		if(column == 'userid'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'createTime'){
			if(row[column]){
				return $.format.shortDate(new Date(row[column]));
			}else{
				return " ";
			}
		}

  		if(column == 'lastModifyTime'){
			if(row[column]){
				return $.format.shortDate(new Date(row[column]));
			}else{
				return " ";
			}
		}

  		if(column == 'type'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'systemCode'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'size'){
			if(row[column]){
				return readablizeBytes(row[column]);
			}else{
				return " ";
			}
		}

  		if(column == 'objectId'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'key'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'param1'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'param2'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'attFileId'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'companyId'){
			if(row[column]){
				return row[column];
			}else{
				return " ";
			}
		}

  		if(column == 'deleted'){
			if(row[column]){
				return '<fmt:message key="common.form.boolean.yes"/>';
			}else{
				return "<fmt:message key="common.form.boolean.no"/>";
			}
		}

		return row[column];
	}
	
	var download_file = new Object();
	function downloadSelected(){
  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
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
					}
				}
				$().toastmessage('showNoticeToast', '<fmt:message key="file.error.noSelectDataForDownload"  bundle="${file}"/>');

	}
	
	var windowProxy;
	var purl = document.location.href;
	var proxyUrl = purl.replace( /([^:]+:\/\/[^\/]+\/[^\/]+).*/, '$1' );

	function setHeight() {
		windowProxy.post({ if_height: $('body').outerHeight( true ) });
	};
	


	$(document).ready(function() {

			//var pagerSelector = '<select class="pagesize input-small"> <option selected="selected" value="500">500</option> <option value="1000">1000</option> <option value="3000">3000</option> <option value="5000">5000</option> </select>';			

				paginationList = $("#list").paginationList({renderField:renderField,sort:["createTime",0],isShowSequence:false,
			useSelectedPanel:false,hidePager:true,//pagerSelector:pagerSelector,//isCheckSelect:false,
				ajaxUrl: '${ctx}/file/attachment/listjson/${_service_sys}/${_service_oid}/${_service_key}?page={page+1}&pageSize=5000&{sortParam}&{condition}',
				columns: columnLabels, //array of column;column{name:"name",label:"label"}
				conditions:[], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });

				 createTableColumnPseudoClasses();
				 
					var buttons = {};

					if(dialogMsg[3]){
						buttons[dialogMsg[3]] = function () {
				            $(this).dialog("close");
				        };
					    
					}else{
						buttons["Cancel"] = function () {
				            $(this).dialog("close");
				        };
					}
					 windowProxy = new Porthole.WindowProxy(
					    		proxyUrl+'/proxy.html');

					$(document).bind('DOMSubtreeModified', function(e) {
						setHeight();
						
					});
					if ($.browser.msie && (eval(parseInt($.browser.version))<9)) {
						$(document).bind("propertychange", function() {
							setHeight();
						});  
						window.setTimeout(function() {
							setHeight();
						},1500);
					};

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
	var inputTimeOut;
	function refreshTableData(){
		$.paginationList("#list").refreshData();
	}
	
	</script>
	<script src="${ctx}/static/javascript/filetype.js"></script>
	<style>

	.accessDenied{
	background: url(${ctx }/static/images/401.jpg) no-repeat center !important
	}
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

body {
    padding-top: 0px;
}

.table{
	margin-bottom:0px;
}
	</style>
</head>

<body>
<fieldset>


	  <div class="tab-content">

	    <div class="tab-pane active" id="tab2">
	            <!-- The table listing the files available for upload/download -->

		<div id="list">

			<div class="conditionPanel pull-right">
			<input type="hidden" id="conditionDeleted" name="search_EQ_deleted" value="false"/>
			<span id="usedOperBar">
			
			<button type="button" class="btn btn-primary" id="download_btn" onclick="downloadSelected();"><fmt:message key="file.form.download"  bundle="${file}"/></button>
			</span>

			</div>

		</div>
	    </div>
	  </div>

		
</fieldset>

</body>
</html>

