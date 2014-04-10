(function ($) {
  "use strict";var pluginName = 'paginationList';
   function PaginationList($element,opts) {
	  
	  var $this = $(this); // The current object
	  this.$element = $element;
		if (this.hasInitialized === true) {
			return (this.options && this.options.debug) ? log('stopping initialization! No thead, tbody or tablesorter has already been initialized') : '';
		}

		var paginationList;
		var ajaxData;

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
	    var listTable;
	var renderField = function(rowData,c){
		return rowData[c];
	};
	var renderRow = function(rowData,rowNum,len){
		var row = [];var c;
		for (var i=0;i<=settings.columns.length-1;i++) {
			c = rowData[settings.columns[i].name];
		//for ( c in rowData ) {
            if (typeof(c) === "string") {
          	  //if((c === settings.columns[0].name) ){
          	  if(i == 0){
          		  if(settings.isCheckSelect){
          			  var checked = '';
          			  if(isExistSelected(c)){
          				  checked = ' checked ';
          			  }
	            		  if(settings.isMultiSelect){
	            			  row.push("<input type='checkbox' class='id-checkbox' name='id' value='"+c+"'"+checked+">");
	            		  }else{
	            			  row.push("<input type='radio' class='id-checkbox' name='id' value='"+c+"'"+checked+">");
	            		  }
          		  }
          		  if(settings.isShowSequence){
          			  row.push(rowNum+1);
          		  }
          		  
          	  }else {
          			  var field = settings.renderField(rowData,settings.columns[i].name,settings);
          			  row.push(field==null?"":field); 
          		 
	          }
            }else {
    			  var field = settings.renderField(rowData,settings.columns[i].name,settings);
      			  row.push(field==null?"":field); 
      		 
            }
          //}
		}
		return row;
	};
    var settings = $.extend({
    	name:"lk_"+randomString(8),
		ajaxUrl: "/",
		useSelectedPanel:false,
		isCheckSelect:true,
		isMultiSelect: true, 
		isShowSequence:false,
		renderField:renderField,
		renderRow:renderRow,
		conditionPanel:null,
		columns: [], //array of column;column{name:"name",label:"label"}
		sort:null,//sort:{columnName,0}
		conditions:[], //array of condition;condition{name:"name",label:"label"}
		tableheaders:null,
		messages: ['Please Select','Clear','OK','Cancel','Search','No Data Found.','Select All','No.'],
		pagerMessages:['First', 'Preview', 'Next', 'Last', 'Row Size', 'Page No'],
		sorterOptions:{},
		treeOptions:null
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
	    	$(obj).parents("table").find('input:checkbox.id-checkbox').attr("checked",'true');
	    }else{
	    	$(obj).parents("table").find('input:checkbox.id-checkbox').removeAttr("checked");
	    }
	    $(obj).parents("table").find('tbody input:checkbox.id-checkbox').each(function(){
	    	selectedChange(this);
	    });
	},
	selectedChange = function (obj){
		if(!settings.useSelectedPanel){
			
		}else{
			var id = $(obj).val();
			var label = $(obj).parent().next().text();
			if(settings.isShowSequence){
				label = $(obj).parent().next().next().text();
			}
			if(settings.isMultiSelect){
				deleteSelectedLabel(id);
			}else{
				clearAllSelected(obj);
			}
			
			var isChecked = $(obj).prop('checked');
			if(isChecked){
				createSelectedLabel(id,label);
			}
		}
		$this.trigger("SelectedChange",getSelected());
	},
	createSelectedLabel  = function (id,name){
		if(id == null || id == "") return;
			var html = '<span class="selected-result" oid="'+id+'"><button type="button" data-dismiss="alert"  class="close">×</button>'+name+'</span>';
		$('.lk-selected',paginationList).append(html);
		$this.trigger("SelectedChange",getSelected());
	},
	deleteSelectedLabel = function (id){
		$('.lk-selected>span.selected-result',paginationList).each(function(){
			var oid = $(this).attr("oid");
			if(oid === id){
				$(this).remove();
			}
		});
	},
	uncheckDeleted = function (id){
		$("#"+settings.name+"ListTable>tbody .id-checkbox",paginationList).each(function(){
			var oid = $(this).val();
			if(oid === id){
				$(this).removeAttr("checked");
			}
		});
	},
	getSelected = function(){
    	var ids = "";
    	var names = "";
    	if(settings.useSelectedPanel){
        	$(".lk-selected>span.selected-result",paginationList).each(function(){
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
   		
    	}else{
    		$("#"+settings.name+"ListTable>tbody .id-checkbox",paginationList).each(function(){
    			var oid = $(this).val();
    			var isChecked = $(this).prop('checked');
    		    if(isChecked){
    		    	if(ids.length > 0){
        				ids += ";";
        			}
        			ids += oid;
    		    }
    			
    		});
    	}
    	return [ids,names];
	},
	clearAllSelected = function (obj){
		var scount = false;
		$(".lk-selected",paginationList).find("span.selected-result").each(function(){
			scount =true;
			var oid = $(this).attr("oid");
			uncheckDeleted(oid);
			$(this).remove();
		});
		if(scount){			
			$this.trigger("SelectedChange",getSelected());
		}
	},
	isExistSelected = function(sid){
		if(!sid){
			return false;
		}
		var existSelected = false;
		$(".lk-selected",paginationList).find("span.selected-result").each(function(){
			var oid = $(this).attr("oid");
			if($.trim(oid) == $.trim(sid)){
				existSelected = true;
				
			}
		});
		return existSelected;
	},
	removeHiddenCondition = function(propName){
		$(".conditionPanel",paginationList).find("input:hidden").each(function(){
			var oid = $(this).attr("name");
			if($.trim(oid) == $.trim(propName)){
				$(this).remove();
			}
		});
	},
	addSelectedCondition = function(propName,label,value){
		removeHiddenCondition(propName);
		$(".conditionPanel>div.lk-conditionSelected",paginationList).find("span.selected-result").each(function(){
			var oid = $(this).attr("pname");
			if($.trim(oid) == $.trim(propName)){
				$(this).remove();
			}
		});
		$(".conditionPanel",paginationList).prepend("<input type='hidden' name='"+propName+"' value='"+value+"'>");
		$(".conditionPanel>div.lk-conditionSelected",paginationList).prepend('<span class="selected-result" pname="'+propName+'"><button type="button" data-dismiss="alert"  class="close">×</button>'+label+'</span>')
		.find(".close").click(function(event){
			removeHiddenCondition(propName);
			$(this).parents(".selected-result").remove();
			$('.table',paginationList).trigger('refresh.pager');
			paginationList.trigger("removeSelected",propName,value,label);
		});

	}

	;
    
    if (this.length > 1){
        return this;
    }
    

    this.initialize = function () {


		 paginationList = this.$element;
		var cds = settings.conditions;
		var conditionPanel = settings.conditionPanel;
		if(conditionPanel == null){
			conditionPanel = $(".conditionPanel",paginationList);
			if(conditionPanel.length == 0){
				conditionPanel = $('<div class="conditionPanel"></div>');
				$(paginationList).append(conditionPanel);
			}
		}
		var operationBar = $("#operation-bar",paginationList);
		var operationBarDiv = $('<div class="span4"></div>');
		operationBarDiv.append(operationBar);
		if(cds.length >0){
			var existSearchButton = false;
			var SearchButton = $("#search_btn",conditionPanel);
			if(SearchButton.length > 0){
				existSearchButton = true;
			}	
			var conditionPanelStr = '';
			
			if(cds.length == 1){
				if(existSearchButton){
					conditionPanelStr += '<label>'+cds[0].label+' <input  name="search_LIKE_'+cds[0].name+'" class="input-medium" type="search"  placeholder="'+cds[0].label+'" > </label>';
				}else{
					conditionPanelStr += '<div class="row pull-right"><div class="span2.5">'+
					'<label>'+cds[0].label+' <input  name="search_LIKE_'+cds[0].name+'" class="input-medium" type="search"  placeholder="'+cds[0].label+'" > </label>'+
					'</div><div class="span1"><button type="button" class="btn" id="search_btn"  >'+settings.messages[4]+'</button></div>'+operationBarDiv.html()+'</div>';
				}
			}else{
				
				for (var condition=0; condition<cds.length; condition++) {
					if (typeof(cds[condition])=='undefined') {
				         continue;
				    };
				    if(condition == 0 && !existSearchButton){
						conditionPanelStr += '<div class="row pull-right"><div class="span2.5">'+
							'<label>'+cds[condition].label+' <input  name="search_LIKE_'+cds[condition].name+'" class="input-medium" type="search"  placeholder="'+cds[condition].label+'" > </label>'+
							'</div><div class="span1"><button type="button" class="btn" id="search_btn"  >'+settings.messages[4]+'</button></div>'+operationBarDiv.html()+'</div>';
				    }else{
						conditionPanelStr += '<label>'+cds[condition].label+' <input  name="search_LIKE_'+cds[condition].name+'" class="input-medium" type="search"  placeholder="'+cds[condition].label+'" > </label>';
				    }
				}
			}
			conditionPanelStr += '';
			conditionPanel.append(conditionPanelStr);
			if(!existSearchButton){
				$('#search_btn',conditionPanel).click(function(){
					$('.table',paginationList).trigger('filterStart.pager');
					$('.table',paginationList).trigger('refresh.pager');
				});
			}
			conditionPanel.append("<div class='lk-conditionSelected'></div>");

		}
		//create result panel
		if(settings.useSelectedPanel){
			var res = '<div class="lk-selected" style="display:none">';
			res += '<button type="button" class="lk-clear btn btn-warning" >'+settings.messages[1]+'</button>';
			res += '</div>';
			$(paginationList).append(res);
		}

		//create sortable table
		var tbl = '  <table id="'+settings.name+'ListTable" class="table table-striped table-bordered table-condensed ">';
		tbl += '<thead><tr>';
		if(settings.isCheckSelect){
			tbl += '<th  class="lk-sequence">';
			if(settings.isMultiSelect){
				tbl += '<label class="checkbox"><input type="checkbox" class="lk-checkAll">'+ (settings.messages[6]?settings.messages[6]:'') + '</label>';
			}
			tbl += '</th>';
		}
		if(settings.isShowSequence){
			tbl += '<th  class="lk-sequence">';
			tbl +=  (settings.messages[7]?settings.messages[7]:'') ;
			tbl += '</th>';				
		}
		for( var column=1; column<settings.columns.length; column++){
			tbl += '<th>'+settings.columns[column].label+'</th>';
		}
		tbl += '</tr></thead>';
		if(settings.hidePager){
		}else{
			tbl += '<tfoot><tr><td class="pager" colspan="'+(settings.isShowSequence?settings.columns.length+1:settings.columns.length)+'">';
			tbl += '<ul class="pager">'+
				'<li class="first"><a href="#" class=" icon-fast-backward"></a></li>'+
				'<li class="prev"><a href="#" class=" icon-backward"></a></li>'+
				'<li class="pagedisplay"></li>'+
				'<li class="next"><a href="#" class=" icon-forward"  style="float:none"></a></li>'+
				'<li class="last"><a href="#" class=" icon-fast-forward"></a></li>';
			tbl += 	'<li >';
			tbl += ' <span>'+settings.pagerMessages[4]+'</span>';
			if(settings.pagerSelector){
				tbl += settings.pagerSelector;
			}else{
				tbl += '<select class="pagesize input-small"> <option selected="selected" value="15">15</option> <option value="30">30</option> <option value="100">100</option> <option value="500">500</option> </select>';			
			}
			tbl += ' <span>'+settings.pagerMessages[5]+'</span><input type="text" class="input-small gotoPage"/>';
			
			tbl += 	'</li>';
			tbl += '</ul>';
			tbl += '</td></tr></tfoot>';
		}
		tbl += '<tbody></tbody>';
		tbl += '</table>';
		$(paginationList).append(tbl);
		

		//add already selected 

		/*var ids = settings.id.split(';');
		var labels = settings.label.split(';');
		for(var i = 0; i< ids.length;i++){
			createSelectedLabel($.trim(ids[i]),labels[i]);
		}*/
		
		var container=$(".pager",paginationList);
		
		var tableheaders = settings.tableheaders;
		if(tableheaders == null){
			tableheaders = {};
			var appendIndex = 0;
			if(settings.isCheckSelect){
				tableheaders[appendIndex] = {sorter:false, name:''};
				appendIndex ++;
			}
			if(settings.isShowSequence){
				tableheaders[appendIndex] = {sorter:false, name:''};
				appendIndex ++;
			}
			for(var i=1;i<settings.columns.length;i++){
				
					tableheaders[i+appendIndex-1] = {sorter:true, name:settings.columns[i].name};
			}
	    }
		var sortList = [];
		if(settings.sort != null){
			var ci = this.getColumnIndex(settings.sort[0]);
			if(ci >=0){
				
				if(!settings.isCheckSelect){
					ci = ci-1;
				}
				if(settings.isShowSequence){
					ci = ci+1;
				}
				sortList.push([ci,parseInt(settings.sort[1])]);
			}
		}
		var sorterOptions = {
				headers: tableheaders,		     
				sortList: sortList,
					widgets: [ "uitheme", "stickyHeaders", "zebra"] 
					
			    };
		$.extend(sorterOptions,settings.sorterOptions);
		listTable = $('#'+settings.name+'ListTable',paginationList).tablesorter(sorterOptions);
		listTable.tablesorterPager({
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
						$(table).parent().find(".conditionPanel input[name^='search_']").each(function(i,v){
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
		      ajaxObject: {
		        dataType: 'json'
		      },

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
		    	  ajaxData = data;
		    	var  tc = table.config;
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
		        	  tc.$tbodies.eq(0).empty();
		          }
		          // this will depend on how the json is set up - see City0.json
		          // rows
		          for ( r=0; r < len; r++ ) {
		            row = []; // new row array
		            // cells
		            row = settings.renderRow(d[r],r,len);
		            
		            rows.push(row); // add new row array to rows array
		          }
		          // in version 2.10, you can optionally return $(rows) a set of table rows within a jQuery object
		          return [ total, rows, headers ];
		        }else{
		        	alert("no message response");
		        }
		      },

		      // output string - default is '{page}/{totalPages}'; possible variables: {page}, {totalPages}, {startRow}, {endRow} and {totalRows}
		      output: '{startRow} - {endRow} ({totalRows})',

		      // apply disabled classname to the pager arrows when the rows at either extreme is visible - default is true
		      updateArrows: true,

		      // starting page of the pager (zero based index)
		      page: 0,

		      // Number of visible rows - default is 10
		      size: 10,

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
		
		$this.bind("SelectedChange",function(event,ids,names){  
			   if(ids == null || ids === "")  {
				   $(".lk-selected",paginationList).hide();
			   }else{
				   $(".lk-selected",paginationList).show();
			   }
		}) ;


	
		$('.lk-checkAll',paginationList).click(function(){checkedAll(this)});
		
		$(".lk-selected",paginationList).delegate("span.selected-result>button.close","click",function(){
			var oid = $(this).parent().attr("oid");
			uncheckDeleted(oid);
			$(this).parent().remove();	
			$this.trigger("SelectedChange",getSelected());
		});
		
		$(".table>tbody ",paginationList).delegate(".id-checkbox","click",function(){
			selectedChange(this);
		});

/*		$(".conditionPanel input[name^='search_']",paginationList).bind('input keyup', function(){
			    var $this = $(this);
			    var delay = 300; // 2 seconds delay after last input

			    clearTimeout($this.data('timer'));
			    $this.data('timer', setTimeout(function(){
			        $this.removeData('timer');
			        $('.table',paginationList).trigger('filterEnd.pager');
			    }, delay));
			});
			*/
		$(".conditionPanel input[name^='search_']",paginationList).keypress(function(event) {
			if (event.keyCode == 13) {
		        $('.table',paginationList).trigger('refresh.pager');
		    }
		});
		$(".lk-clear ",paginationList).bind("click",function(){
			clearAllSelected(this);
		});

		return this;
    };
    
    this.getSelectedIds = function (){
    	var selected = getSelected();
    	if(selected != null && selected.length > 0){
    		return selected[0];
    	}
    	return;
    };
    
    this.refreshData = function(){
    	$('.table',paginationList).trigger('refresh.pager');
    	clearAllSelected();
    };
    this.getColumn = function (c) {
    	for (var i = 0; i < settings.columns.length; i++) {
    		if(settings.columns[i].name == c){
    			return settings.columns[i];
    		}
    	}
    	return null;
    };
    this.getListTable = function(){
    	return listTable;
    };
    this.getColumnIndex = function (c) {
    	for (var i = 0; i < settings.columns.length; i++) {
    		if(settings.columns[i].name == c){
    			return i;
    		}
    	}
    	return -1;
    };
    this.addSelectedCondition = function(propertyName,label,value){
    	addSelectedCondition(propertyName,label,value);
    	$('.table',paginationList).trigger('refresh.pager');
    };
    this.getAjaxData = function(){
    	return ajaxData;
    }

    this.initialize();
    this.hasInitialized = true;
  };
  

	$.fn[pluginName] = function(options) {
		return this.each(function() {
			var obj;
			if (!(obj = $.data(this, pluginName))) {
				
				var $this = $(this)
					,data = $this.data()
					,opts = $.extend({}, $.fn[pluginName].defaults, options, data)
					;
				obj = new PaginationList($this, opts);
				$.data(this, pluginName, obj);
			}
		});
	};
	$[pluginName] = function(elem, options) {
		if (typeof elem === 'string') {
			elem = $(elem);
		}
		var obj;
		if (!(obj = elem.data()[ pluginName])) {
			var data = elem.data()
				,opts = $.extend({}, $.fn[pluginName].defaults, options, data)
				;
			obj = new PaginationList(elem, opts);
			$.data(elem, pluginName, obj);
		}
		return obj;
	};


	$.fn[pluginName].defaults = {
		expand: true
	};

	$(function() {
		$('[data-paginationList]')[pluginName]();
	});

}(jQuery));
