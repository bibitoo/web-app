(function ($) {
  "use strict";var pluginName = 'rowSelectableTable';
   function RowSelectableTable($element,opts) {
	  
	  var $this = $(this); // The current object
	  this.$element = $element;
		if (this.hasInitialized === true) {
			return (this.options && this.options.debug) ? log('stopping initialization! No thead, tbody or tablesorter has already been initialized') : '';
		}

		var rowSelectableTable;

	var renderRow = function(rowData,rowNum,len){
		
	};
    var settings = $.extend({
    	name:"lk_"
    }, opts);
    var 
    checkedAll = function (obj){
	    var isChecked = $(obj).prop('checked');

	    if(isChecked){
	    	rowSelectableTable.find('input:checkbox.id-checkbox').prop("checked",'true');
	    }else{
	    	rowSelectableTable.find('input:checkbox.id-checkbox').removeAttr("checked");
	    }
	    selectedChange(obj);
	},
	selectedChange = function (obj){
		
		$this.trigger("SelectedChange",getSelected());
	},
	removeSelected = function (){
		$(".id-checkbox",rowSelectableTable).each(function(){
			var isChecked = $(this).prop('checked');
			if(isChecked){
				$(this).closest("tr").remove();
			}
		});
	},
	getSelected = function(){
    	var ids = "";

    		$(".id-checkbox",rowSelectableTable).each(function(){
    			var oid = $(this).val();
    			var isChecked = $(this).prop('checked');
    		    if(isChecked){
    		    	if(ids.length > 0){
        				ids += ";";
        			}
        			ids += oid;
    		    }
    			
    		});
    	
    	return ids;
	},
	isExistSelected = function(sid){
		if(!sid){
			return false;
		}
		var existSelected = false;
		$(".lk-selected",rowSelectableTable).find("span.selected-result").each(function(){
			var oid = $(this).attr("oid");
			if($.trim(oid) == $.trim(sid)){
				existSelected = true;
				
			}
		});
		return existSelected;
	};
    
    if (this.length > 1){
        return this;
    }
    

    this.initialize = function () {

    	rowSelectableTable = this.$element;
		$('.lk-checkAll',rowSelectableTable).on("click",function(){checkedAll(this)});
		$("tbody ",rowSelectableTable).delegate(".id-checkbox","click",function(){
			 var isChecked = $(this).prop('checked');
			 if(!isChecked){
				 $('.lk-checkAll',rowSelectableTable).removeAttr("checked");
			 }
			selectedChange(this);
		});

		return this;
    };
    
    this.getSelectedIds = function (){
    	var selected = getSelected();
    	if(selected != null ){
    		return selected;
    	}
    	return;
    };
    this.removeSelected = function(){
    	removeSelected();
    };
    

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
				obj = new RowSelectableTable($this, opts);
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
			obj = new RowSelectableTable(elem, opts);
			$.data(elem, pluginName, obj);
		}
		return obj;
	};


	$.fn[pluginName].defaults = {
		expand: true
	};

	$(function() {
		$('[data-rowSelectableTable]')[pluginName]();
	});

}(jQuery));
