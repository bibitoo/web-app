<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<fmt:setBundle basename="i18n.file_message" var="file"/>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title><fmt:message key="entity.attachment" bundle="${file}"/></title>
	<script>
	var columns = ["name","size","createTime"];
	var index = jQuery.inArray($.urlParam('sortType'), columns);
	if(index < 0 ){
		index = 0;
	}
	var sortOrder = $.urlParam('sortOrder');
	
	if(sortOrder == null || sortOrder === "null" || sortOrder === ""){
		sortOrder = 0;
	}
	var idPaths = '${param["search_EQ_parent.id"]}'.split('/');
	var setting = {
			async: {
				enable: true,
				url:"${ctx}/file/folder/treejson",
				autoParam:["id","name=name"],
				type:"get"
			},
			callback:{onClick:folderTreeOnClick, onAsyncSuccess: folderOnAsyncSuccess}

		};
	function folderOnAsyncSuccess(event, treeId, treeNode, msg) {
		var tree_folder = $.fn.zTree.getZTreeObj("tree_parent");
		lk_expandAjaxTreeNode(treeNode,idPaths,tree_folder);
	};
	

var parentId;
	function folderTreeOnClick(event, treeId, treeNode) {
			 $.paginationList("#list").addSelectedCondition("search_EQ_parent.id",treeNode.name,treeNode.id);
			 parentId = treeNode.id;
			 
		}

	var paginationList;
	var ztree ;
	$(document).ready(function() {
		ztree = $.fn.zTree.init($("#tree_parent"), setting);
		 $("#menu-collapse").togglepanels();


				paginationList = $("#list").paginationList({renderField:renderField,sort:[$.urlParam('sortType'),$.urlParam('sortOrder')],isShowSequence:true,
			useSelectedPanel:true,//isCheckSelect:false,
				ajaxUrl: '${ctx}/file/attachment/listjson?page={page+1}&pageSize={size}&{sortParam}&{condition}',
				columns: [{name:"id",label:"ID"},
						{name:"name",label:"<fmt:message key="entity.attachment.name" bundle="${file}"/>"}
						,
						{name:"size",label:"<fmt:message key="entity.attachment.size" bundle="${file}"/>"}
						,
						{name:"createTime",label:"<fmt:message key="entity.attachment.createTime" bundle="${file}"/>"}
					
						
				          ], //array of column;column{name:"name",label:"label"}
				conditions:[{name:"name",label:"<fmt:message key="entity.attachment.name" bundle="${file}"/>"}], //array of condition;condition{name:"name",label:"label"}
				messages: [<fmt:message key="common.form.dialog.messages"/>],
				pagerMessages: [<fmt:message key="common.form.list.pagerMessage"/>]
		    });
				paginationList.bind("removeSelected",function(event,propName,value,label){

				     ztree.cancelSelectedNode();
				     fileUploadReset(false,"s=file");
			});
				
		
	});
	

		
	
	function renderField(row,column,settings){
  		if(column == 'name'){
			if(row[column]){
				return '<a href="${ctx}/file/attachment/view/'+row['id']+'">'+row[column]+'</a>';
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

	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/attachment/deleteAll",{ids:ids},function (data, textStatus){
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
		
	</script>
	<link href="${ctx}/static/fileupload/jquery.fileupload.css" rel="stylesheet">
	
</head>

<body>
<fieldset>
<c:set var="menuKey" value="Attachment"/>
<%@ include file="../menu.jsp" %>


<div class="row">
	<div class="span3">
		<div id="menu-collapse">
			<div>
	             <h3><a href="#"><span class="lk-clear"><fmt:message key="entity.folder" bundle="${file}"/></span></a></h3>
	             <div><ul id="tree_parent" class="ztree"></ul></div>
	         </div>
	     </div>
	
	</div>
	<div class="span9">

	<c:if test="${not empty message}">
		<script>$().toastmessage('showNoticeToast', '${message}');</script>
	</c:if>

	  <div class="tab-content">
	    <div class="tab-pane active" id="tab1">
	         <!-- The file upload form used as target for the file upload widget -->
    <form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
        <!-- Redirect browsers with JavaScript disabled to the origin page -->
        <noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="fileupload-buttonbar">
            <div class="span2 ">
                <!-- The fileinput-button span is used to style the file input field as button -->
                <span class="btn btn-success fileinput-button">
                    <i class="icon-plus"></i>
                    <span><fmt:message key="entity.attachment.upload" bundle="${file}"/>...</span>
                    <input type="file" name="files[]" multiple>
                </span>
                <!-- The global file processing state -->
                <span class="fileupload-process"></span>
            </div>
            <!-- The global progress state -->
            <div class="span6 fileupload-progress fade">
                <!-- The global progress bar -->
                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                    <div class="bar bar-success" style="width:0%;"></div>
                </div>
                <!-- The extended global progress state -->
                <div class="progress-extended">&nbsp;</div>
            </div>
        </div>
        <!-- The table listing the files available for upload/download -->
        <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
    </form>	
	    </div>
	    <div class="tab-pane active" id="tab2">
		<div id="list">
			<div class="conditionPanel">
				<div id="operation-bar" class="span5.5">
				<button type="button" class="btn btn-primary" id="add_btn" onclick="window.location.href='${ctx}/file/folder/create?ref=a&parentId='+parentId;"><fmt:message key="common.form.create"/><fmt:message key="entity.parent" bundle="${file}"/></button>
				<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
				</div>
			</div>
		</div>
	    </div>
	  </div>

 
	</div>
</div>
		
</fieldset>

<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <span class="preview"></span>
        </td>
        <td>
            <p class="name">{%=file.name%}</p>
            <strong class="error text-danger"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
            <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="bar bar-success" style="width:0%;"></div></div>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="btn btn-primary start" disabled>
                    <i class="icon-upload"></i>
                    <span>Start</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">
                    <i class="icon-ban-circle"></i>
                    <span><fmt:message key="common.form.cancel"/></span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">

</script>
<script src="${ctx}/static/fileupload/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="${ctx}/static/fileupload/load-image.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="${ctx}/static/fileupload/canvas-to-blob.min.js"></script>
<!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<!-- <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script> -->
<!-- blueimp Gallery script -->
<script src="${ctx}/static/fileupload/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="${ctx}/static/fileupload/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="${ctx}/static/fileupload/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script>
$(function () {
    'use strict';
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: '/org/file/attachment/upload',
        autoUpload: true
    });

    fileUploadReset(false,"s=file");
    $('#fileupload').fileupload().on('fileuploadadd', function(e, data) {
   	 data.url = '/org/file/attachment/upload?s=file&parentId='+parentId;
   });;

});
function fileUploadReset(init,params){
	var url = '/org/file/attachment/upload';
	if(params){
		url = url + "?" + params;
	}
	$('#fileupload').fileupload('destroy');

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: url,
        autoUpload: true  
    }).bind('fileuploaddone', function (e, data) {
    	$.paginationList("#list").refreshData();
	});

    // Enable iframe cross-domain access via redirect option:
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );
    // Load existing files:
    
    $('#fileupload').addClass('fileupload-processing');
	$('tbody.files tr').remove();
	if(init){
	    $.ajax({
	        // Uncomment the following to send cross-domain cookies:
	        //xhrFields: {withCredentials: true},
	        url: $('#fileupload').fileupload('option', 'url'),
	        dataType: 'json',
	        context: $('#fileupload')[0]
	    }).always(function () {
	    	$('#fileupload').removeClass('fileupload-processing');
	    }).done(function (result) {
	    	$('#fileupload').fileupload('option', 'done')
	            .call(this, $.Event('done'), {result: result});
	    });
		
	}
}
</script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="${ctx}/static/fileupload/cors/jquery.xdr-transport.js"></script>
<![endif]-->
</body>
</html>

