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

	var columns = ${_service_file_columns};
	var columnLabels = ${_service_file_columnLabels};
	var titleSuggest = null;
	<c:if test="${not empty _service_file_titleSuggest}">
		titleSuggest=${_service_file_titleSuggest};
	</c:if>
	var remarkSuggest = null;
	<c:if test="${not empty _service_file_remarkSuggest}">
		remarkSuggest=${_service_file_remarkSuggest};
	</c:if>


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

	function removeSelected(){
		 $.lkHttpService("body").confirm("<fmt:message key="common.form.delete.confirm"/>","removeSelectedTrue","message");
		//windowProxy.post({if_key: "_confirm", "func": "removeSelectedTrue","message":"<fmt:message key="common.form.delete.confirm"/>"});
		
	}
	function removeSelectedTrue(){	
					var ids = $.rowSelectableTable("#listTable").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/fileBase/disableAll",{ids:ids},function (data, textStatus){
							if(data.status == 'error'){
								$.lkHttpService("body").toastmessage('showNoticeToast', data.message);
							}else{
								$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
								$.rowSelectableTable("#listTable").removeSelected();
							}
						});
						return;
					}else{
						$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');
					}
	}
	function saveTitle($this){
		
		 var id = $this.attr("oid"); 
		 var url = '${ctx}/file/attachment/updateTitle/' + id + "/"+encodeURIComponent($this.val());
		 if($this.val()){
		 }else{
			 url = '${ctx}/file/attachment/updateTitle/' + id + "/null";
		 }
		    $.ajax( { 
		        url : url, 
		        type : 'get', 
		        dataType : 'json', 
		        success : function(data, textStatus, jqXHR) { 
		        	$this.next("input:first").prop('disabled', true); 
		        },
		        error:function(XmlHttpRequest,textStatus, errorThrown) { 
		        	$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="core.update.error"/>');
		        }
		    });
	}
	function saveRemark($this){
		
		 var id = $this.attr("oid"); 
		 var url = '${ctx}/file/attachment/updateRemark/' + id + "/"+encodeURIComponent($this.val());
		 if($this.val()){
		 }else{
			 url = '${ctx}/file/attachment/updateRemark/' + id + "/null";
		 }
		    $.ajax( { 
		        url : url, 
		        type : 'get', 
		        dataType : 'json', 
		        success : function(data, textStatus, jqXHR) { 
		        	$this.next("input:first").prop('disabled', true); 
		        },
		        error:function(XmlHttpRequest,textStatus, errorThrown) { 
		        	$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="core.update.error"/>');
		        }
		    });
	}
	function del(obj){
		var bar = $(obj).closest("span.lk-row-bar");
		var row = $(obj).closest("tr");
		var oid = bar.attr("oid");
		var oname = bar.attr("oname");
		url = '${ctx}/file/fileBase/disableAll?ids=' + oid ;
		
		    $.ajax( { 
		        url : url, 
		        type : 'get', 
		        dataType : 'json', 
		        success : function(data, textStatus, jqXHR) { 
		        	$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
		        	row.remove();
		        },
		        error:function(XmlHttpRequest,textStatus, errorThrown) { 
		        	$.lkHttpService("body").toastmessage('showNoticeToast', '<fmt:message key="core.delete.error"/>');
		        }
		    });
	}



	$(document).ready(function() {

		$("#listTable").rowSelectableTable();
				if(titleSuggest){

			    		$("#list input.title-input").each(function(index){
			    			var $this = $(this);
							$(this).typeahead({source: titleSuggest, items:5, updater:function(item) {
								
								 var id = $this.attr("oid"); 
								 $this.val(item);
								saveTitle($this);   							
						        return item;
						    }});
						});

				};
				if(remarkSuggest){
			    		$("#list input.remark-input").each(function(index){
			    			var $this = $(this);
							$(this).typeahead({source: remarkSuggest, items:5, updater:function(item) {
								
								 var id = $this.attr("oid"); 
								 $this.val(item);
								saveRemark($this);   
						        return item;
						    }});
						});
					
				};
				
				$("#list ").delegate("input.title-input", 'paste input keyup', function(){
				    var $this = $(this);
				    var delay = 300; // 300 ms delay after last input
				    $this.next("input:first").removeAttr("disabled");
				    clearTimeout($this.data('timer'));
				    $this.data('timer', setTimeout(function(){
				        $this.removeData('timer');
				        saveTitle($this);   
				    }, delay));
				});
				$("#list ").delegate("input.title-input", 'blur', function(){
				    var $this = $(this);
				    $this.next("input:first").removeAttr("disabled");
				    clearTimeout($this.data('timer'));
				        $this.removeData('timer');
				        saveTitle($this);   
				});
				$("#list ").delegate("input.remark-input", 'paste input keyup', function(){
				    var $this = $(this);
				    var delay = 300; // 300 ms delay after last input
				    $this.next("input:first").removeAttr("disabled");
				    clearTimeout($this.data('timer'));
				    $this.data('timer', setTimeout(function(){
				        $this.removeData('timer');
				        saveRemark($this);   
				    }, delay));
				});
				$("#list ").delegate("input.remark-input", 'blur', function(){
				    var $this = $(this);
				    $this.next("input:first").removeAttr("disabled");
				    clearTimeout($this.data('timer'));
				        $this.removeData('timer');
				        saveRemark($this);   
				});
				

				
					$("#list table").delegate("tr","mouseenter",function(){
						
						var bar = $(this).find("span.lk-row-bar");
						if(!bar.attr("init")){
							var oid = bar.attr("oid");
							var oname = bar.attr("oname");
							var data = {"id":oid,"name":oname};
							var content = tmpl("template-oper-bar",data);
							bar.html(content);
							bar.attr("init","true");
						}
						bar.show();
					}).delegate("tr","mouseleave",function(){
						var bar = $(this).find("span.lk-row-bar");
						bar.hide();
					});


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
	<link href="${ctx}/static/fileupload/jquery.fileupload.css" rel="stylesheet">
	<style>
	#upload-container{
		background: url(${ctx}/static/styles/default/images/drapmsg.png) no-repeat center;width:100%
	}
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

	    <div class="tab-pane active" id="tab2">
	            <!-- The table listing the files available for upload/download -->
		<div id="upload-container" class="upload-container"  style="background-position:top center;display:inline-block">
	<form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="row fileupload-buttonbar">
        	<div class="span3">
                 <span class="btn btn-success fileinput-button">
                    <i class="icon-plus"></i>
                    <span><fmt:message key="entity.attachment.upload" bundle="${file}"/>...</span>
                    <input type="file" name="files[]" multiple>
                    <input type="hidden" name="relativePath">
                </span>

            </div>
	            <div class="span2 ">
	                <!-- The fileinput-button span is used to style the file input field as button -->
	                 <!-- The global file processing state -->
	                <span class="fileupload-process"></span>
	            </div>
            <!-- The global progress state -->
            <div class="span5 fileupload-progress fade"  id="total-process">
                <!-- The global progress bar -->
                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                    <div class="bar bar-success" style="width:0%;"></div>
                </div>
                <!-- The extended global progress state -->
                <div class="progress-extended">&nbsp;</div>
            </div>
                   
        </div>
		<div id="list">

			<div class="conditionPanel pull-right">
			
			<button type="button" class="btn btn-primary" id="delete_btn" onclick="removeSelected();"><fmt:message key="common.form.delete"/></button>
			<button type="button" class="btn btn-primary" id="download_btn" onclick="downloadSelected();"><fmt:message key="file.form.download"  bundle="${file}"/></button>
			</div>

			<table id="listTable"  role="presentation" class="table table-striped table-bordered table-condensed ">
			
					<thead><tr><th><label class="checkbox"><input type="checkbox" class="lk-checkAll"></label></th>
		<th><fmt:message key="entity.attachment.title" bundle="${file}"/></th>
		<th><fmt:message key="entity.attachment.name" bundle="${file}"/></th>
		<th><fmt:message key="entity.attachment.size" bundle="${file}"/></th>
		<th><fmt:message key="entity.attachment.createTime" bundle="${file}"/></th>
		<th><fmt:message key="entity.attachment.remark" bundle="${file}"/></th>
		</tr></thead>
		<tbody  class="files">
		<c:forEach items="${page.content}" var="attachment">
		
			<tr><td><label class="checkbox"><input type="checkbox" class="lk-check id-checkbox"   value="${attachment.id }"></label></td>
			<td><div class="input-append">
				<input type="text"  oid="${attachment.id }" data-provide="typeahead" class="title-input input-small" value="${attachment.title}"/>
				<button class="btn" type="button" title="<fmt:message key="common.form.save"/>" onclick="saveTitle($(this).prev('input:first'));" disabled>
				<i class="icon-save"></i></button>
				</div>
			</td>
			<td><span class="lk-row-bar pull-right" oid="${attachment.id }"></span><span  class="list-subject"><a href="${ctx}/file/attachment/view/${attachment.id}">${attachment.name}</a></span></td>
			<td><tags:filesize size="${attachment.size}"/></td>
			<td><tags:date value="${attachment.createTime}"/></td>
			<td><div class="input-append">
				<input type="text"  oid="${attachment.id }" data-provide="typeahead" class="remark-input input-small" value="${attachment.remark}"/>
				<button class="btn" type="button" title="<fmt:message key="common.form.save"/>" onclick="saveRemark($(this).prev('input:first'));" disabled>
				<i class="icon-save"></i></button>
				</div></td>
				
			</tr>
		</c:forEach>
		
		</tbody>
			</table>
		</div>
    </form>	
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
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
		<td><label class="checkbox"><input type="checkbox" class="lk-check id-checkbox" oid="{%=file.id%}"></label></td>
			<td><div class="input-append">
				<input type="text"  oid="{%=file.id%}" data-provide="typeahead" class="title-input input-small" value="{%=file.title%}"/>
				<button class="btn" type="button" title="<fmt:message key="common.form.save"/>" onclick="saveTitle($(this).prev('input:first'));" disabled>
				<i class="icon-save"></i></button>
				</div></td>
			<td><span class="lk-row-bar pull-right" oid="{%=file.id%}"></span><span  class="list-subject"><a href="${ctx}/file/attachment/view/{%=file.id%}">{%=file.name%}</a></span></td>
			<td>{%=o.formatFileSize(file.size)%}</td>
			<td>{%=$.format.shortDate(file.createTime)%}</td>
			<td><div class="input-append">
				<input type="text"  oid="{%=file.id%}" data-provide="typeahead" class="remark-input input-small" value="{%=file.remark%}"/>
				<button class="btn" type="button" title="<fmt:message key="common.form.save"/>" onclick="saveRemark($(this).prev('input:first'));" disabled>
				<i class="icon-save"></i></button></td>
				
    </tr>
{% } %}
</script>
<script src="${ctx}/static/javascript/filetype.js"></script>

<script src="${ctx}/static/fileupload/tmpl.js"></script>
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
    var o = $("#conditionOwner").val();
    fileUploadReset(false,"oid=${_service_oid}&s=${_service_sys}&key=${_service_key}&o="+o);
    $('#fileupload').fileupload().on('fileuploadadd', function(e, data) {
    		data.url = '${ctx}/file/attachment/upload?oid=${_service_oid}&s=${_service_sys}&key=${_service_key}&o='+o;
     	
    });
    

});
function fileUploadReset(init,params){
	var url = '${ctx}/file/attachment/upload';
	if(params){
		url = url + "?" + params;
	}

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
    	sequentialUploads : true,
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: url,
        autoUpload: true  
    }).bind('fileuploaddone', function (e, data) {
    	$("#total-process").removeClass("lk-white");
	}).bind('fileuploadsubmit', function (e, data) {
		$("#total-process").addClass("lk-white");
        $.each(data.files, function (index, file) {
           
            if(file.relativePath){
            	data.formData = {relativePath: file.relativePath};
            }
          });
        });;

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
	$("span.fileupload-process").hide();

}
</script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="${ctx}/static/fileupload/cors/jquery.xdr-transport.js"></script>
<![endif]-->


<script id="template-oper-bar" type="text/x-tmpl">
  <div class="btn-group">
    <a class="btn" href="javascript:void(0)" title="<fmt:message key="entity.fileBase.oper.move" bundle="${file}"/>" onclick="del(this);"><i class="icon-trash"></i></a>
  </div>
</script>

</body>
</html>

