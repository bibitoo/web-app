// NOTICE!! DO NOT USE ANY OF THIS JAVASCRIPT
// IT'S ALL JUST JUNK FOR OUR DOCS!
// ++++++++++++++++++++++++++++++++++++++++++

!function ($) {

    $(function(){

        var $window = $(window);

        // Disable certain links in docs
        $('section [href^=#]').click(function (e) {
            e.preventDefault()
        });

        // side bar
        $('.bs-docs-sidenav').affix({
            offset: {
                top: function () { return $window.width() <= 980 ? 290 : 210 }
                , bottom: 270
            }
        });
        // Buttons download
        $('.download-btn').button();

        // make code pretty
        window.prettyPrint && prettyPrint();

        $('.anchor-button, ul#icons li').hover(
                function () {
                    $(this).addClass('ui-state-hover');
                }, function () {
                    $(this).removeClass('ui-state-hover');
                }
            );

    })
}(window.jQuery);

$.urlParam = function(name){
	return decodeURI(
	        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
	    );
}

$.extend($.tablesorter.themes.bootstrap, {
    // these classes are added to the table. To see other table classes available,
    // look here: http://twitter.github.com/bootstrap/base-css.html#tables
    table      : 'table table-bordered',
    header     : 'bootstrap-header', // give the header a gradient background
    footerRow  : '',
    footerCells: '',
    icons      : '', // add "icon-white" to make them white; this icon class is added to the <i> in the header
    sortNone   : 'bootstrap-icon-unsorted',
    sortAsc    : 'icon-chevron-up',
    sortDesc   : 'icon-chevron-down',
    active     : '', // applied when column is sorted
    hover      : '', // use custom css here - bootstrap class may not override it
    filterRow  : '', // filter row class
    even       : '', // odd row zebra striping
    odd        : ''  // even row zebra striping
  });

$.tablesorter.defaults.theme = "bootstrap"; 
$.tablesorter.defaults.dateFormat = "yyyy-MM-dd HH:mm:ss"; 
$.tablesorter.defaults.widthFixed = true; 
$.tablesorter.defaults.headerTemplate = '{content} {icon}'; 
$.tablesorter.defaults.widgets = [ "uitheme", "stickyHeaders", "zebra" ]; 
$.tablesorter.defaults.widgetOptions = {zebra : ["even", "odd"], filter_reset : ".reset"}; 

Array.prototype.contains = function(obj) {  
    var i = this.length;  
    while (i--) {  
        if (this[i] === obj) {  
            return true;  
        }  
    }  
    return false;  
}  ;

var pagerOptions = {

	    // target the pager markup - see the HTML block below
	    container: $(".pager"),

	    // use this url format "http:/mydatabase.com?page={page}&size={size}&{sortList:col}"
	    ajaxUrl: null,

	    // modify the url after all processing has been applied
	    customAjaxUrl: function(table, url) { return url; },

	    // process ajax so that the data object is returned along with the total number of rows
	    // example: { "data" : [{ "ID": 1, "Name": "Foo", "Last": "Bar" }], "total_rows" : 100 }
	    ajaxProcessing: function(ajax){
	      if (ajax && ajax.hasOwnProperty('data')) {
	        // return [ "data", "total_rows" ];
	        return [ ajax.total_rows, ajax.data ];
	      }
	    },

	    // output string - default is '{page}/{totalPages}'
	    // possible variables: {page}, {totalPages}, {filteredPages}, {startRow}, {endRow}, {filteredRows} and {totalRows}
	    output: '{startRow} to {endRow} ({totalRows})',

	    // apply disabled classname to the pager arrows when the rows at either extreme is visible - default is true
	    updateArrows: true,

	    // starting page of the pager (zero based index)
	    page: 0,

	    // Number of visible rows - default is 10
	    size: 15,

	    // if true, the table will remain the same height no matter how many records are displayed. The space is made up by an empty
	    // table row set to a height to compensate; default is false
	    fixedHeight: true,

	    // remove rows from the table to speed up the sort of large tables.
	    // setting this to false, only hides the non-visible rows; needed if you plan to add/remove rows with the pager enabled.
	    removeRows: false,

	    // css class names of pager arrows
	    cssNext: '.next', // next page arrow
	    cssPrev: '.prev', // previous page arrow
	    cssFirst: '.first', // go to first page arrow
	    cssLast: '.last', // go to last page arrow
	    cssGoto: '.gotoPage', // select dropdown to allow choosing a page

	    cssPageDisplay: '.pagedisplay', // location of where the "output" is displayed
	    cssPageSize: '.pagesize', // page size selector - select dropdown that sets the "size" option

	    // class added to arrows when at the extremes (i.e. prev/first arrows are "disabled" when on the first page)
	    cssDisabled: 'disabled', // Note there is no period "." in front of this class name
	    cssErrorRow: 'tablesorter-errorRow' // ajax error information row

	  };

$.validator.setDefaults({ 
    ignore: [],
    errorElement: "span"
    // any other default options and/or rules
});



var datepicker_i18n = {  
        showOn: 'both',
        timeFormat: 'HH:mm:ss'
        };

function lk_expandAjaxTreeNode(treeNode,paths,treeObj){
	if(paths.length > 1 && paths[1] != ""){
		
		if(treeNode == null){
			  var node = treeObj.getNodeByParam("id", paths[1], null);
			  
			  if(node){
				  if(paths.length == 2){
					  treeObj.selectNode(node);
					  treeObj.setting.treeObj.trigger("expandToLeaf.zTree");
				  }else{
					  treeObj.expandNode(node,true);
				  }
			  }
			
		}else{
			var idIndex = $.inArray(treeNode.id,paths);
			if( idIndex > -1 && idIndex < paths.length){
				var node = treeObj.getNodeByParam("id", paths[idIndex+1], null);
				if(idIndex < paths.length-2 ){
					treeObj.expandNode(node,true);
				  }else{
					  treeObj.selectNode(node);
					  treeObj.setting.treeObj.trigger("expandToLeaf.zTree");
				  }
			}
		}
		
				
	}
}
function refreshTree(ids, treeObj){
	if(treeObj && ids){
		var idsa = ids.split(";");
		var nodes =  treeObj.transformToArray(treeObj.getNodes());
		//ztree.reAsyncChildNodes(null,"refresh");
		
		for (var i=0, l=nodes.length; i<l; i++) {
			if(idsa.contains(nodes[i].id)){
				treeObj.reAsyncChildNodes(nodes[i].getParentNode(),"refresh");
			}
		}
	}
}

function readablizeBytes(bytes) {
	  var s = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
	  var e = Math.floor(Math.log(bytes)/Math.log(1024));
	  return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
}
;

;(function($, undefined) {
	"use strict";
	var pluginName = 'togglepanels';

	function Togglepanels($element, options) {
		
		this.options = $.extend({}, $.fn[pluginName].defaults, options);
		this.$element = $element;
		if (this.hasInitialized === true) {
			return (this.options && this.options.debug) ? log('stopping initialization! No thead, tbody or tablesorter has already been initialized') : '';
		}

		this.$element.addClass("ui-accordion ui-accordion-icons ui-widget ui-helper-reset")
  	  .find("h3")
  	    .addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-top ui-corner-bottom")
  	    .hover(function() { $(this).toggleClass("ui-state-hover"); })
  	    .prepend('<span class="ui-icon ui-icon-triangle-1-e"></span>')
  	    .click(function() {
  	      $(this)
  	        .toggleClass("ui-accordion-header-active ui-state-active ui-state-default ui-corner-bottom")
  	        .find("> .ui-icon").toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s").end()
  	        .next().slideToggle();
  	      return false;
  	    })
  	    .next()
  	      .addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom")
  	      .hide();
  	    if(this.options.expand){
  	    	this.$element.find("h3").click();
  	    }
  	    this.hasInitialized = true;
	};

	$.extend(Togglepanels.prototype, {
		setSelected: function(sindex,id,name) {
			var $this = this.$element;
			this.$element.find(">div").each(function(index){
        		if(index == sindex){
        			$(this).find("h3>a .selected-result").remove();
        			$(this).find("h3>a").append('<span class="selected-result" oid="'+id+'"><button type="button" data-dismiss="alert"  class="close">×</button>'+name+'</span>')
        			.find(".close").click(function(event){
        				event.stopPropagation();
        				$(this).parents(".selected-result").remove();
        				$this.trigger("removeSelected",index,id,name);
        			});
        		}
        	});
		}
	});


	$.fn[pluginName] = function(options) {
		return this.each(function() {
			var obj;
			if (!(obj = $.data(this, pluginName))) {
				
				var $this = $(this)
					,data = $this.data()
					,opts = $.extend({}, $.fn[pluginName].defaults, options, data)
					;
				obj = new Togglepanels($this, opts);
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
			obj = new Togglepanels(elem, opts);
			$.data(elem, pluginName, obj);
		}
		return obj;
		//return new Togglepanels(elem, options);
	};


	$.fn[pluginName].defaults = {
		expand: true
	};

	$(function() {
		$('[data-togglepanels]')[pluginName]();
	});
})(jQuery);

(function ($) {
    "use strict";
    $.fn.inputClear = function(options) {
	var settings = $.extend({
         'exclude':'.no-clear',
        },options);
    	return this.each(function() {
	        // add private event handler to avoid conflict
                $(this).not(settings.exclude)
                .unbind("clear-focus")
                .bind("clear-focus", (
                    function () {
                        if ($(this).data("clear-button")) return;
                        var x = $("<a class='clear-text' style='cursor:pointer;color:#888;'><i class='icon-remove'></i></a>");
                        $(x).data("text-box", this);
                        $(x).mouseover(function () { $(this).addClass("over"); }).mouseleave(function () { $(this).removeClass("over"); });
                        $(this).data("clear-button", x);
                        $(x).css({ "position": "absolute", "left": ($(this).position().right), "top": $(this).position().top, "margin": "3px 0px 0px -20px" });
                        $(this).after(x);
                    //$(this));
                    }))
                .unbind("clear-blur").bind("clear-blur", (
                    function (e){
                        var x = $(this).data("clear-button");
                        if (x) {
                            if ($(x).hasClass("over")) {
                                $(x).removeClass("over");
                                $(x).hide().remove();
                                $(this).val("");
                                $(this).removeData("clear-button");
                                var txt = this;
                                e.stopPropagation();
                                e.stopImmediatePropagation();
                                setTimeout($.proxy(function () { $(this).trigger("focus"); $(this).trigger("input"); }, txt), 50);
                                return false;
                            }
                        }
                        if (x && !$(x).hasClass("over")) {
                            $(this).removeData("clear-button");
                            $(x).remove();
                        }
                    }));
	        // add private event to the focus/unfocus events as branches
                $(this).on("focus", function () {
                    $(this).trigger("clear-focus");
                }).on("blur", function () {
                    $(this).trigger("clear-blur");
                });
            });
       };
})(jQuery);
(function ($) {
    "use strict";
    function enableInputClearOption() {
	// add private event handler to avoid conflict
        $("input[type=text]").not(".no-clear").unbind("clear-focus").bind("clear-focus", (function () {
            if ($(this).data("clear-button")) return;
            var x = $("<a class='clear-text' style='cursor:pointer;color:#888;'><i class='icon-remove'></i></a>");
            $(x).data("text-box", this);
            $(x).mouseover(function () { $(this).addClass("over"); }).mouseleave(function () { $(this).removeClass("over"); });
            $(this).data("clear-button", x);
            $(x).css({ "position": "absolute", "left": ($(this).position().right), "top": $(this).position().top, "margin": "3px 0px 0px -20px" });
            $(this).after(x);
            //$(this));
        })).unbind("clear-blur").bind("clear-blur", (function (e) {
            var x = $(this).data("clear-button");
            if (x) {
                if ($(x).hasClass("over")) {
                    $(x).removeClass("over");
                    $(x).hide().remove();
                    $(this).val("");
                    $(this).removeData("clear-button");
                    var txt = this;
                    e.stopPropagation();
                    e.stopImmediatePropagation();
                    setTimeout($.proxy(function () { $(this).trigger("focus"); }, txt), 50);
                    return false;

                }
            }
            if (x && !$(x).hasClass("over")) {
                $(this).removeData("clear-button");
                $(x).remove();
            }
        }));
	// add private event to the focus/unfocus events as branches
        $("input[type=text]").on("focus", function () {
            $(this).trigger("clear-focus");
        }).on("blur", function () {
            $(this).trigger("clear-blur");
        });
    }
    window.enableInputClearOption = enableInputClearOption;
})(jQuery);



;(function($, undefined) {
	"use strict";
	var pluginName = 'treebreadcrumb';

	function Treebreadcrumb($element, options) {
		var idsarray = new Array();
		var namesarray = new Array();
		var selectedIndex = -1;
		
		this.options = $.extend({}, $.fn[pluginName].defaults, options);
		this.$element = $element;
		if (this.hasInitialized === true) {
			return (this.options && this.options.debug) ? log('stopping initialization! No thead, tbody or tablesorter has already been initialized') : '';
		}
		var getHeararchyId = function(index){
			var str = "";
			for (var i = 1; i < idsarray.length; i++) {
				str += "/"+idsarray[i];
			}
			return str;
		};
		var getIndexById = function(id){
			for (var i = 1; i < idsarray.length; i++) {
				if(id == idsarray[i]){
					return i;
				}
			}
			return -1;
		};
		var idsstr = this.options.ids;
		if(idsstr != null && idsstr != ""){
			if(idsstr.substring(0,1) == this.options.divider){
				idsstr = idsstr.substring(1,idsstr.length);
			}
			if(idsstr.substring(idsstr.length-1,idsstr.length) == this.options.divider){
				idsstr = idsstr.substring(0,idsstr.length-1);
			}
			idsarray = idsstr.split(this.options.divider);
		}
		var namesstr = this.options.names;
		if(idsstr != null && idsstr != ""){
			if(namesstr.substring(0,1) == this.options.divider){
				namesstr = namesstr.substring(1,namesstr.length);
			}
			if(namesstr.substring(namesstr.length-1,namesstr.length) == this.options.divider){
				namesstr = namesstr.substring(0,namesstr.length-1);
			}
			namesarray = namesstr.split(this.options.divider);
		}
		
		selectedIndex = idsarray.length -1;

		var breadcrumb = "";
    	for (var i = 0; i < idsarray.length; i++) {
    		if(i == idsarray.length -1){
    	   		 breadcrumb += "<li oid=\""+idsarray[i]+"\" oname=\""+namesarray[i]+"\" oindex=\""+i+"\"  class=\"active\"><span class=\"active\">"+namesarray[i]+"</span> <span class=\"divider\">"+this.options.divider+"</span></li>"   			
    		}else{
    	   		 breadcrumb += "<li oid=\""+idsarray[i]+"\"  oname=\""+namesarray[i]+"\" oindex=\""+i+"\" ><a href=\"#\">"+namesarray[i]+"</a> <span class=\"divider\">"+this.options.divider+"</span></li>"
    		}
     	}
    	
    	var home = "";
    	if(selectedIndex >= 0){
    		home += "<li oid='' oname='' oindex='0' class=\"lk-breakcrumb-root\"> <a href=\"#\">"+this.options.root+"</a>";
    	}else{
    		home += "<li class='lk-breakcrumb-root active'  oid='' oname='' oindex='0'> <span class='active'>"+this.options.root+"</span>";
    	}
    	
		this.$element.prepend("<ul class=\"breadcrumb\" >"+home+" <span class=\"divider\">"+this.options.divider+"</span></li>"+breadcrumb+"</ul>")
  	  .delegate("li>a","click",function(e){
  		$element.find("li.active>span.active").each(function(index){
  			var text = $(this).text();
  			var p=$(this).closest("li");
  			$(this).remove();
  			p.prepend("<a href=\"#\">"+text+"</a>");
  			
 		});
  		var text = $(this).text();
  		var pli=$(this).closest("li");
  		pli.addClass("active").prepend("<span class=\"active\">"+text+"</span>");
		var index = pli.attr("oindex");
		selectedIndex = index;
		$element.trigger("nodeclick.treebreadcrumb",pli.attr("oid"),pli.attr("oname"),getHeararchyId(index),index);
		$(this).remove();
  	  });

  	    this.hasInitialized = true;
  	  this.changeRoot = function(name){
  		  var rootActive = $element.find("li.lk-breakcrumb-root").hasClass("active");
  		  if(rootActive){
  			$element.find("li.active>span.active").text(name);
  		  }else{
  			$element.find("li.lk-breakcrumb-root>a").text(name);
  		  }
  	  };
  	  this.activeRoot = function(){
  		$element.find("li.lk-breakcrumb-root").nextAll("li").remove();
		  var rootActive = $element.find("li.lk-breakcrumb-root").hasClass("active");
  		  if(rootActive){
  		  }else{
  			  var $athis = $element.find("li.lk-breakcrumb-root>a");
    			var text = $athis.text();
      			var p=$athis.closest("li");
      			$athis.remove();
      			p.addClass("active").prepend("<span class=\"active\">"+text+"</span>");
	    		selectedIndex =-1;
  		  }
  		 idsarray = new Array();
		 namesarray = new Array();

	  		$element.trigger("nodeclick.treebreadcrumb","",this.options.root,"",-1);
  		  
  	  };
  	    this.linkNode = function(id,name){
  	    	var idindex = getIndexById(id);
  	    	if(idindex < 0){
  	    		//delete
  	    		$element.find("li.active>span.active").closest("li").nextAll("li").remove();
  	    		var active = $element.find("li.active>span.active");
  	    		var text = active.text();
  	    		var p=active.closest("li");
  	    		p.removeClass("active");
  	    		active.remove();
  	    		p.prepend("<a href=\"#\">"+text+"</a>");
  	    		idsarray.splice(selectedIndex+1,idsarray.length-selectedIndex);
  	    		namesarray.splice(selectedIndex+1,idsarray.length-selectedIndex);
  	    		idsarray.push(id);
  	    		namesarray.push(name);
  	    		//append
  	    		selectedIndex ++;
  	    		var breadcrumb1 = "<li oid=\""+id+"\" oname=\""+name+"\" oindex=\""+(selectedIndex)+"\"  class=\"active\"><span class=\"active\">"+name+"</span> <span class=\"divider\">"+this.options.divider+"</span></li>"  ; 			
   	   		 	$element.find("ul").append(breadcrumb1);
   	   		 	$element.trigger("nodeclick.treebreadcrumb",id,name,getHeararchyId(selectedIndex),selectedIndex);
  	    	}else if(idindex > selectedIndex){
  	    		//switch
  	    		var active = $element.find("li.active>span.active");
  	    		
  	    		var text =active.text();
  	    		var p = active.closest("li"); var pli =  p.next();
  	    		p.removeClass("active");
  	    		active.remove();
  	  			p.prepend("<a href=\"#\">"+text+"</a>");
  	  			
  	  			var newactive = pli.find("a");
  	  			var text = newactive.text();
  	    		var pli=newactive.closest("li");
  	    		pli.addClass("active").prepend("<span class=\"active\">"+text+"</span>");
  	    		selectedIndex ++;
  	    		newactive.remove();
	  	  		$element.trigger("nodeclick.treebreadcrumb",id,name,getHeararchyId(selectedIndex),selectedIndex);
	  	  		
  	    	}
  	    };
	};




	$.fn[pluginName] = function(options) {
		return this.each(function() {
			var obj;
			if (!(obj = $.data(this, pluginName))) {
				
				var $this = $(this)
					,data = $this.data()
					,opts = $.extend({}, $.fn[pluginName].defaults, options, data)
					;
				obj = new Treebreadcrumb($this, opts);
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
			obj = new Treebreadcrumb(elem, opts);
			$.data(elem, pluginName, obj);
		}
		return obj;
		//return new Togglepanels(elem, options);
	};


	$.fn[pluginName].defaults = {
			divider:"/",
			root: "Home",
			ids:"",
			names:""
		};

	$(function() {
		$('[data-treebreadcrumb]')[pluginName]();
	});
})(jQuery);