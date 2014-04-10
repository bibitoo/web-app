(function ($) {
  "use strict";
  $.fn.selectDialog = function (opts) {
	  
	  var $this = $(this); // The current object
	  var selectDialog;
	  var init = false;
	  var ztree;

	    var randomString = function (length) {
	        var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('');
	        
	        if (! length) {
	            length = Math.floor(Math.random() * chars.length);
	        }
	        
	        var str = '';
	        for (var i = 0; i < length; i++) {
	            str += chars[Math.floor(Math.random() * chars.length)];
	        }
	        return str;
	    };
    var settings = $.extend({
    	name:"lk_"+randomString(8),
    	id: "id",
		label: "label",
		ajaxUrl: "/",
		conditionListtype:"and" , //"and" or "or"
		isMultiSelect: false, 
		singleSelectedReturn: true,
		columns: [], //array of column;column{name:"name",label:"label"}
		conditions:[], //array of condition;condition{name:"name",label:"label"}
		messages: ['Please Select','Clear','OK','Cancel']
    }, opts);
    var containColumn = function (c) {
    	for (var i = 0; i < settings.columns.length; i++) {
    		if(settings.columns[i].name == c){
    			return true;
    		}
    	}
    	return false;
    },
    checkedAll = function (obj){
	    var isChecked = $(obj).prop('checked');
	    if(isChecked){
	    	$(obj).parents("table").find('input:checkbox').attr("checked",'true');
	    }else{
	    	$(obj).parents("table").find('input:checkbox').removeAttr("checked");
	    }
	    $(obj).parents("table").find('tbody input:checkbox').each(function(){
	    	selectedChange(this);
	    });
	},
	selectedChange = function (obj){
		var id = $(obj).val();
		var label = $(obj).parent().next().text();
		if(settings.isMultiSelect){
			deleteSelectedLabel(id);
		}else{
			clearAllSelected(obj);
		}
		
		var isChecked = $(obj).prop('checked');
		if(isChecked){
			createSelectedLabel(id,label);
		}
	},
	createSelectedLabel  = function (id,name){
		if(id == null || id == "") return;
			var html = '<span class="selected-result" oid="'+id+'"><button type="button" class="close">&times;</button>'+name+'</span>';
		$('.lk-selected',selectDialog).append(html);
	},
	deleteSelectedLabel = function (id){
		$('.lk-selected>span.selected-result',selectDialog).each(function(){
			var oid = $(this).attr("oid");
			if(oid === id){
				$(this).remove();
			}
		});
	},
	uncheckDeleted = function (id){
		$("#"+settings.name+"SelectTable>tbody .id-checkbox",selectDialog).each(function(){
			var oid = $(this).val();
			if(oid === id){
				$(this).removeAttr("checked");
			}
		});
		if(settings.treeOptions){
			var ztree = $.fn.zTree.getZTreeObj('lk-dialog-tree-'+settings.name);
			if(ztree == null){
				return;
			}
			var nodes = ztree.getCheckedNodes();
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].id == id){
					ztree.checkNode(nodes[i],false,false);
					return;
				}
			}
		}
	},
	clearAllSelected = function (obj){
		$(".lk-selected",selectDialog).find("span.selected-result").each(function(){
			var oid = $(this).attr("oid");
			uncheckDeleted(oid);
			$(this).remove();
		});
	},
	isExistSelected = function(sid){
		if(!sid){
			return false;
		}
		var existSelected = false;
		$(".lk-selected",selectDialog).find("span.selected-result").each(function(){
			var oid = $(this).attr("oid");
			if($.trim(oid) == $.trim(sid)){
				existSelected = true;
				
			}
		});
		return existSelected;
	},
	asynTree = function (){
       	var treeObj = $.fn.zTree.getZTreeObj('lk-dialog-tree-'+settings.name);
    	var nodes = treeObj.transformToArray(treeObj.getNodes());
    	for (var i = 0; i < nodes.length ; i++) {
            var node = nodes[i] ;
            if(isExistSelected(node.id)){
    			treeObj.checkNode(node,true,false);
    		}else{
    			treeObj.checkNode(node,false,false);
    			treeObj.cancelSelectedNode(node);
    			
    		}
        }

	}

	;
    
    if (this.length > 1){
        this.each(function() { $(this).selectDialog(settings) });
        return this;
    }
    

    this.initialize = function () {

		var dd = '<div id="'+settings.name+'-dialog_selector" title="'+settings.messages[0]+'">';
		dd += '</div>';
		$($this).append(dd);
		 selectDialog = $("div",$this);
		var cds = settings.conditions;
		if(cds.length >0){
			var conditionPanelStr = '<div class="conditionPanel pull-right">';
			
			if(cds.length == 1){
				conditionPanelStr += '<input  name="search_LIKE_'+cds[0].name+'" class="search-query" type="search"  placeholder="'+cds[0].label+'" > ';
			}else if(settings.conditionListtype == "and"){
				
				for (var condition=0; condition<cds.length; condition++) {
					if (typeof(cds[condition])=='undefined') {
				         continue;
				    };
					conditionPanelStr += '<input  name="search_LIKE_'+cds[condition].name+'" class="search-query" type="search"  placeholder="'+cds[condition].label+'" > ';
				}
			}else{
				conditionPanelStr += '<div class="input-prepend">';
				conditionPanelStr += '<div class="btn-group">';
				conditionPanelStr += '<button class="btn dropdown-toggle" data-toggle="dropdown">';
				conditionPanelStr += ' <span>'+cds[0].label+'</span>';
				conditionPanelStr += '<span class="caret"></span>';
				conditionPanelStr += '</button>';
				conditionPanelStr += '<ul class="dropdown-menu">';

				for(var condition=0; condition<cds.length; condition++){
					conditionPanelStr += '<li><a href="#" onclick=\'$(this).parents("div").next().attr("name","search_LIKE_'+cds[condition].name+'");$(this).parents("ul").prev().find(":first-child").text($(this).text());\'>'+cds[condition].label+'</a></li>';
					
				}
                conditionPanelStr += '</ul></div>';
                conditionPanelStr += '<input class="span2 search-query"  name="search_LIKE_'+cds[0].name+'" type="text"  placeholder="Search">';

			}
			conditionPanelStr += '</div>';
			$(selectDialog).append(conditionPanelStr);
		}
		
		//create content
		var tbl = '        <ul  class="nav nav-tabs">';
         if(settings.treeOptions){
        	 tbl += '<li><a href="#tree-tab-'+settings.name+'" data-toggle="tab"><i class="icon-folder-open"></i></a></li>';
         }
        	 
             tbl +=   '<li><a href="#table-tab-'+settings.name+'" data-toggle="tab"><i class="icon-th-list"></i></a></li>';
         
         tbl += '</ul>';
         tbl += '<div class="tab-content lk-dialog-container">';
         if(settings.treeOptions){
        	 tbl += '<div class="tab-pane" id="tree-tab-'+settings.name+'">';
        	//create tree
        	 tbl += '<ul id="lk-dialog-tree-'+settings.name+'" class="ztree"></ul>';
        	 tbl += '</div>';
         }
         tbl += '<div class="tab-pane" id="table-tab-'+settings.name+'">';
		//create sortable table
		 tbl += '  <table id="'+settings.name+'SelectTable" class="table table-striped table-bordered table-condensed ">';
		tbl += '<thead><tr><th   class="lk-sequence">';
		if(settings.isMultiSelect){
			tbl += '<input type="checkbox" class="lk-checkAll">';
		}
		tbl += '</th>';
		
		for( var column=1; column<settings.columns.length; column++){
			tbl += '<th>'+settings.columns[column].label+'</th>';
		}
		tbl += '</tr></thead>';
		tbl += '<tfoot><tr><td class="pager" colspan="2">';
		tbl += '<ul>'+
		'<li class="first"><a href="#" class=" icon-fast-backward"></a></li>'+
		'<li class="prev"><a href="#" class=" icon-backward"></a></li>'+
		'<li class="pagedisplay"></li>'+
		'<li class="next"><a href="#" class=" icon-forward"  style="float:none"></a></li>'+
		'<li class="last"><a href="#" class=" icon-fast-forward"></a></li>';
		tbl += '</ul>';
		tbl += '</td></tr></tfoot>';
		tbl += '<tbody></tbody>';
		tbl += '</table>';
		tbl += '</div></div>';
		$(selectDialog).append(tbl);
		

		//create result panel
		var res = '<div class="lk-selected">';
		res += '<button type="button" class="lk-clear btn btn-warning" >'+settings.messages[1]+'</button>';
		res += '</div>';
		$(selectDialog).append(res);
		//add already selected 

		var ids = $(settings.id).val().split(';');
		var labels = $(settings.label).val().split(';');
		for(var i = 0; i< ids.length;i++){
			createSelectedLabel($.trim(ids[i]),labels[i]);
		}
		
		var container=$(".pager",selectDialog)
		
		var tableheaders = {};
		for(var i=0;i<settings.columns.length;i++){
			tableheaders[i] = {sorter:(i==0?false:true), name:settings.columns[i].name};
		}
		var sorterOptions = {
				headers: tableheaders,
					widgets: [ "uitheme", "stickyHeaders", "zebra"] 
					
			    };
		var tableAjaxObject = {
				dataType: 'json'
		};
		if(settings.ajaxDataType){
			tableAjaxObject = {
					dataType: settings.ajaxDataType
			};
		}
		$('#'+settings.name+'SelectTable',selectDialog).tablesorter(sorterOptions).tablesorterPager({
		      container: container,
		      ajaxUrl : settings.ajaxUrl,

		      // modify the url after all processing has been applied
		      customAjaxUrl: function(table, url) {
		          // manipulate the url string as you desire
		          // url += '&cPage=' + window.location.pathname;
		    	  var sortParam = url.match(/\{sortParam\}/),
					condition = url.match(/\{condition\}/),
					sl = table.config.sortList,
					arry = [];
		    	  
					if(condition){
						$(selectDialog).find(".conditionPanel input[name^='search_']").each(function(i,v){
							if($(this).val())
							arry.push($(this).attr("name")+"="+$(this).val());
						});
						
						url = url.replace(/\{condition\}/g, arry.length ? arry.join('&') : "" );
						arry = [];
					}
					
					if(sortParam){
						$.each(sl, function(i,v){
							if(table.config.headers[ v[0] ] && table.config.headers[ v[0] ].name){
								arry.push("sortType="+table.config.headers[ v[0] ].name + "&sortOrder="+ v[1]);
							}
						});
						// if the arry is empty, just add the col parameter... "&{sortList:col}" becomes "&col"
						url = url.replace(/\{sortParam\}/g, arry.length ? arry.join('&') : "" );
						arry = [];
					}

		          // trigger my custom event
		          $(table).trigger('changingUrl', url);
		          // send the server the current page
		          return url;
		      },
		      ajaxObject: tableAjaxObject,

		      // process ajax so that the following information is returned:
		      // [ total_rows (number), rows (array of arrays), headers (array; optional) ]
		      // example:
		      // [
		      //   100,  // total rows
		      //   [
		      //     [ "row1cell1", "row1cell2", ... "row1cellN" ],
		      //     [ "row2cell1", "row2cell2", ... "row2cellN" ],
		      //     ...
		      //     [ "rowNcell1", "rowNcell2", ... "rowNcellN" ]
		      //   ],
		      //   [ "header1", "header2", ... "headerN" ] // optional
		      // ]
		      // OR
		      // return [ total_rows, $rows (jQuery object; optional), headers (array; optional) ]
		      ajaxProcessing: function(data, table){
		        if (data && data.hasOwnProperty('rows')) {
		          var r, row, c, d = data.rows,
		          // total number of rows (required)
		          total = data.total_rows,
		          // array of header names (optional)
		          headers = data.headers,
		          // all rows: array of arrays; each internal array has the table cell data for that row
		          rows = [],
		          // len should match pager set size (c.size)
		          len = d.length;
		          if(total == 0){
		        	  $().toastmessage('showNoticeToast', settings.messages[5]?settings.messages[5]:"No Data Found.");
		        	  var  tc = table.config;
		        	  tc.$tbodies.eq(0).empty();
		          }

		          // this will depend on how the json is set up - see City0.json
		          // rows
		          for ( r=0; r < len; r++ ) {
		            row = []; // new row array
		            // cells
		    		for (var i=0;i<=settings.columns.length-1;i++) {
		    			c = d[r][settings.columns[i].name];
		            
		            //for ( c in d[r] ) {
		              if (typeof(c) === "string") {
		            	  if(i==0){
	            			  var checked = '';
	            			  if(isExistSelected(c)){
	            				  checked = ' checked ';
	            			  }
		            		  if(settings.isMultiSelect){
		            			  row.push("<input type='checkbox' class='id-checkbox' name='id' value='"+c+"'"+checked+">");
		            		  }else{
		            			  row.push("<input type='radio' class='id-checkbox' name='id' value='"+c+"'"+checked+">");
		            		  }
		            		  
		            	  }else{
			                	row.push('<span  class="list-subject">'+c+'</span>'); // add each table cell data to row array
			              }
		              }
		            }
		            rows.push(row); // add new row array to rows array
		          }
		          // in version 2.10, you can optionally return $(rows) a set of table rows within a jQuery object
		          return [ total, rows, headers ];
		        }
		      },

		      // output string - default is '{page}/{totalPages}'; possible variables: {page}, {totalPages}, {startRow}, {endRow} and {totalRows}
		      output: '{startRow} - {endRow} ({totalRows})',

		      // apply disabled classname to the pager arrows when the rows at either extreme is visible - default is true
		      updateArrows: true,

		      // starting page of the pager (zero based index)
		      page: 0,

		      // Number of visible rows - default is 10
		      size: 8,

		      // if true, the table will remain the same height no matter how many records are displayed. The space is made up by an empty
		      // table row set to a height to compensate; default is false
		      fixedHeight: false,

		      // remove rows from the table to speed up the sort of large tables.
		      // setting this to false, only hides the non-visible rows; needed if you plan to add/remove rows with the pager enabled.
		      removeRows: false,

		      // css class names of pager arrows
		      cssNext        : '.next',  // next page arrow
		      cssPrev        : '.prev',  // previous page arrow
		      cssFirst       : '.first', // go to first page arrow
		      cssLast        : '.last',  // go to last page arrow
		      cssPageDisplay : '.pagedisplay', // location of where the "output" is displayed
		      cssPageSize    : '.pagesize', // page size selector - select dropdown that sets the "size" option
		      cssErrorRow    : 'tablesorter-errorRow', // error information row

		      // class added to arrows when at the extremes (i.e. prev/first arrows are "disabled" when on the first page)
		      cssDisabled    : 'disabled' // Note there is no period "." in front of this class name

		    });
		
		//dialog
		var okFunction =  function()  {
        	var ids = "";
        	var names = "";
        	$(".lk-selected>span.selected-result",selectDialog).each(function(){
				var oid = $(this).attr("oid");
				var text = $(this).clone().children().remove().end().text();;
				if(ids.length > 0){
					ids += ";";
				}
				ids += oid;
				
				if(names.length >0){
					names+= ";";
				}
				names += text;
			});
        	$(settings.id).val(ids);
        	$(settings.label).val(names);
        	
        	$(selectDialog).dialog("close");
        	if(settings.callback){
        		settings.callback(ids,names);
        	}
        };
		var buttons = {};
		if(settings.messages[2]){
			buttons[settings.messages[2]] = okFunction;
		    
		}else{
			buttons["OK"] = okFunction;
		}
		if(settings.messages[3]){
			buttons[settings.messages[3]] = function () {
                $(this).dialog("close");
            };
		    
		}else{
			buttons["Cancel"] = function () {
                $(this).dialog("close");
            };
		}
		

		$(selectDialog).dialog({
	        autoOpen: false,
	        width: 600,height:600,
	        modal: true,
	        buttons: buttons
	    });
		
	
		$('.lk-checkAll',selectDialog).click(function(){checkedAll(this)});
		
		$(".lk-selected",selectDialog).delegate("span.selected-result>button.close","click",function(){
			var oid = $(this).parent().attr("oid");
			uncheckDeleted(oid);
			$(this).parent().remove();
			
		});
		
		if(settings.treeOptions){
			var treeOptions = 	{
					view: {
						selectedMulti: settings.isMultiSelect
					},
					check: {
						enable: true,
						chkboxType : { "Y" : "", "N" : "" }
					},
					async: settings.treeOptions.async,
					callback:{
						onCheck:function(event, treeId, treeNode){
							var id = treeNode.id;
							var label = treeNode.name;
							if(settings.isMultiSelect){
								deleteSelectedLabel(id);
							}else{
								clearAllSelected(this);
							}
							
							var isChecked = treeNode.checked;
							if(isChecked){
								createSelectedLabel(id,label);
							}
							if(!settings.isMultiSelect && settings.singleSelectedReturn){
								okFunction();
								selectDialog.dialog("close");
							}

						},
						onClick:function(event, treeId, treeNode){
							var id = treeNode.id;
							var label = treeNode.name;
							if(settings.isMultiSelect){
								deleteSelectedLabel(id);
							}else{
								clearAllSelected(this);
							}
							var treeObj = $.fn.zTree.getZTreeObj(treeId);
							treeObj.checkNode(treeNode,true,false);
								createSelectedLabel(id,label);
							
							if(!settings.isMultiSelect && settings.singleSelectedReturn){
								okFunction();
								selectDialog.dialog("close");
							}

						},
						onAsyncSuccess:function (event, treeId, treeNode, msg) {
							asynTree();
							if(settings.treeOptions.idPaths){
								var paths = settings.treeOptions.idPaths.split("/");
								lk_expandAjaxTreeNode(treeNode,paths,$.fn.zTree.getZTreeObj(treeId));
							}
						}
					}
				};
			if(!settings.isMultiSelect){
				treeOptions.check.chkStyle="radio";
				treeOptions.check.radioType = "all";
			}

			ztree = $.fn.zTree.init($('#lk-dialog-tree-'+settings.name), treeOptions);
		}
		
		$(".table>tbody ",selectDialog).delegate(".id-checkbox","click",function(){
			selectedChange(this);
			if(!settings.isMultiSelect && settings.singleSelectedReturn){
				okFunction();
				selectDialog.dialog("close");
			}
		});
        $('a[data-toggle="tab"]',selectDialog).on('shown', function (e) {
           
            if($(e.target).attr('href') == '#tree-tab-'+settings.name){
            	asynTree();
             }else{
            	
            	$('#'+settings.name+'SelectTable',selectDialog).find('input.id-checkbox').each(function(){
            		if(isExistSelected($(this).val())){
            			$(this).prop("checked",true);
            		}
            	});
            }
        })

		$(".conditionPanel input[name^='search_']",selectDialog).bind('input keyup', function(){
			    var $this = $(this);
			    var delay = 300; // 2 seconds delay after last input

			    clearTimeout($this.data('timer'));
			    $this.data('timer', setTimeout(function(){
			        $this.removeData('timer');
			        $('.nav-tabs a:last').tab('show');
			        $('.table',selectDialog).trigger('refresh.pager');
			    }, delay));
			});
		$(".lk-clear ",selectDialog).bind("click",function(){
			clearAllSelected(this);
		});
		
		 $('.nav-tabs a:first',selectDialog).tab('show');

		return this;
    };
    
    this.showSelectDialog = function (ref){
    	if(ref){
    		clearAllSelected();
    		var ids = $(settings.id).val().split(';');
    		var labels = $(settings.label).val().split(';');
    		for(var i = 0; i< ids.length;i++){
    			createSelectedLabel($.trim(ids[i]),labels[i]);
    			$("#"+settings.name+"SelectTable>tbody .id-checkbox",selectDialog).each(function(){
    				var oid = $(this).val();
    				if(oid === $.trim(ids[i])){
    					$(this).prop("checked",true);
    				}
    			});
    		}

    	}
    	if(!init){
    		this.initialize();
    		init = true;
    	}
		if(ref && settings.treeOptions){
			var ztree = $.fn.zTree.getZTreeObj('lk-dialog-tree-'+settings.name);
			var ids = $(settings.id).val().split(';');
			if(ids && ztree){
				var nodes = ztree.transformToArray(ztree.getNodes());
				for(var i=0;i<nodes.length;i++){
					for(var k = 0; k< ids.length;k++){
						if(nodes[i].id == ids[k]){
							ztree.checkNode(nodes[i],true,false);
						}
					}
					
				}
			}
			
		}
    	selectDialog.dialog("open");
    	return;
    };


//    return this.initialize();
    return this;
  };
  
}(jQuery));
