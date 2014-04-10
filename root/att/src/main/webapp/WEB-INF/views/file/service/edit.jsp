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
	var titleSuggest = null;
	<c:if test="${not empty _service_file_titleSuggest}">
		titleSuggest=${_service_file_titleSuggest};
	</c:if>
	var remarkSuggest = null;
	<c:if test="${not empty _service_file_remarkSuggest}">
		remarkSuggest=${_service_file_remarkSuggest};
	</c:if>

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
  		if(column == 'title'){
  			var inhtml = "<div class='input-append'>";
			if(row[column]){
				inhtml= inhtml + '<input type="text" value="'+row[column]+'"  oid="'+row['id']+'" data-provide="typeahead" class="title-input input-small">';
			}else{
				inhtml= inhtml + '<input type="text" value=""  oid="'+row['id']+'" data-provide="typeahead"  class="title-input input-small">';
			}
			inhtml =  inhtml + '<button class="btn" type="button" title="<fmt:message key="common.form.save"/>" onclick="saveTitle($(this).prev("input:first"));" disabled><i class="icon-save"></i></button>';
			return inhtml + '</div>';
		}
  		if(column == 'remark'){
  			var inhtml = "<div class='input-append'>";
			if(row[column]){
				inhtml= inhtml + '<input type="text" value="'+row[column]+'"  oid="'+row['id']+'" data-provide="typeahead" class="remark-input input-small">';
			}else{
				inhtml= inhtml +  '<input type="text" value=""  oid="'+row['id']+'" data-provide="typeahead"  class="remark-input input-small">';
			}
			inhtml =  inhtml + '<button class="btn" type="button" title="<fmt:message key="common.form.save"/>" onclick="saveRemark($(this).prev("input:first"));" disabled><i class="icon-save"></i></button>';
			return inhtml + '</div>';
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
				$().toastmessage('showNoticeToast', '<fmt:message key="common.error.noSelectDataForDelete"/>');

	}
	function deleteSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/fileBase/disableAll",{ids:ids},function (data, textStatus){
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
	function removeSelected(){
		bootbox.confirm("<fmt:message key="common.form.delete.confirm"/>", function(result) {                
			  if (result) {  		
				if(paginationList){
					var ids = $.paginationList("#list").getSelectedIds();
					if(ids){
						$.get("${ctx}/file/fileBase/deleteAll",{ids:ids},function (data, textStatus){
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
		        	$().toastmessage('showNoticeToast', '<fmt:message key="core.update.error"/>');
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
		        	$().toastmessage('showNoticeToast', '<fmt:message key="core.update.error"/>');
		        }
		    });
	}
	function del(obj){
		var bar = $(obj).closest("span.lk-row-bar");
		var oid = bar.attr("oid");
		var oname = bar.attr("oname");
		url = '${ctx}/file/fileBase/disableAll?ids=' + oid ;
		
		    $.ajax( { 
		        url : url, 
		        type : 'get', 
		        dataType : 'json', 
		        success : function(data, textStatus, jqXHR) { 
		        	$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.success"/>');
		        	$.paginationList("#list").refreshData();
		        },
		        error:function(XmlHttpRequest,textStatus, errorThrown) { 
		        	$().toastmessage('showNoticeToast', '<fmt:message key="core.delete.error"/>');
		        }
		    });
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
				
				if(titleSuggest){
					$.paginationList("#list").getListTable().bind('pagerInitialized pagerChange', function(e, filter){
			    		$("#list input.title-input").each(function(index){
			    			var $this = $(this);
							$(this).typeahead({source: titleSuggest, items:5, updater:function(item) {
								
								 var id = $this.attr("oid"); 
								 $this.val(item);
								saveTitle($this);   
						        return item;
						    }});
						});
			      });;
					
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
				if(remarkSuggest){
					$.paginationList("#list").getListTable().bind('pagerInitialized pagerChange', function(e, filter){
			    		$("#list input.remark-input").each(function(index){
			    			var $this = $(this);
							$(this).typeahead({source: remarkSuggest, items:5, updater:function(item) {
								
								 var id = $this.attr("oid"); 
								 $this.val(item);
								saveRemark($this);   
						        return item;
						    }});
						});
			      });;
					
				};
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

				

				
					$("#list table.tablesorter").delegate("tr","mouseenter",function(){
						
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
				 
					var buttons = {};

					if(dialogMsg[3]){
						buttons[dialogMsg[3]] = function () {
				            $(this).dialog("close");
				        };
					    
					}else{
						buttons["Cancel"] = function () {
				            $(this).dialog("close");
				        };
					};
				    windowProxy = new Porthole.WindowProxy(
				    		proxyUrl+'/proxy.html');

				    // Register an event handler to receive messages;
				    windowProxy.addEventListener(function(event) { 
				        // handle event
				       
				    });

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
	<link href="${ctx}/static/fileupload/jquery.fileupload.css" rel="stylesheet">
	<style>
	#upload-container{
		background: url(${ctx}/static/styles/default/images/drapmsg.png) no-repeat center;
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

		<div id="list">
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
                    <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>
        </div>

    </form>	
</div>
			<div class="conditionPanel pull-right">
			<input type="hidden" id="conditionDeleted" name="search_EQ_deleted" value="false"/>
			<input type="hidden" id="conditionOwner" name="search_EQ_owner" value=""/>
			<span id="usedOperBar">
			
			<button type="button" class="btn btn-primary" id="delete_btn" onclick="deleteSelected();"><fmt:message key="common.form.delete"/></button>
			<button type="button" class="btn btn-primary" id="download_btn" onclick="downloadSelected();"><fmt:message key="file.form.download"  bundle="${file}"/></button>
			</span>

			</div>

			<div id="testbreadcrumb"></div>
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
    
    var alCities = ['Baltimore', 'Boston', 'New York', 'Tampa Bay', 'Toronto', 'Chicago', 'Cleveland', 'Detroit', 'Kansas City', 'Minnesota', 'Los Angeles', 'Oakland', 'Seattle', 'Texas'].sort();
    $('#city').typeahead({source: alCities, items:5});
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
    	$.paginationList("#list").refreshData();
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
	$('tbody.files tr').remove();
	$("span.fileupload-process").hide();
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


<script id="template-oper-bar" type="text/x-tmpl">
  <div class="btn-group">
    <a class="btn" href="javascript:void(0)" title="<fmt:message key="entity.fileBase.oper.move" bundle="${file}"/>" onclick="del(this);"><i class="icon-trash"></i></a>
  </div>
</script>

</body>
</html>

