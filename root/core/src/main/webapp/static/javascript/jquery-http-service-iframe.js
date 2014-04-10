(function ($) {
  "use strict";var pluginName = 'lkHttpServiceIframe';
   function LkHttpServiceIframe($element,opts) {
	  
	  var $this = $(this); // The current object
	  this.$element = $element;
		if (this.hasInitialized === true) {
			return (this.options && this.options.debug) ? log('stopping initialization! No thead, tbody or tablesorter has already been initialized') : '';
		};
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


		var lkHttpServiceIframe;
		
		var proxyEvents = new Object();

    var settings = $.extend({
    	name:"lk_http_service_iframe",
    	targetIframeId:"lk_iframe_"+randomString(8),
    	serviceProxyUrl:"/proxy.html",
    	serviceUrl:"",
    	deletedIds:null,
    	rows:null,
    	params:null,
    	proxyEvents:proxyEvents
    }, opts);
    var $windowProxy;
    var $iframe;
    var if_height;
    var onIFrameMessage = function(e){
    	if(e.data.if_height){
    		 var h = Number( e.data.if_height );

    		    if ( !isNaN( h ) && h > 0 && h !== if_height ) {
    		      // Height has changed, update the iframe.
    		    	$iframe.height( if_height = h );
    			    console.log("recieve message:"+settings.targetIframeId+" height:"+h);
    		    }
    	}
	   else{
		    var if_key = e.data.if_key;
		    if(if_key){
		    	settings.proxyEvents[if_key](e);
		    }
	    	
	    }

    };
    var hasEventHandler = function (key){
    	if(key in settings.proxyEvents){
    		return true;
    	}
    	return false;
    }
    if (this.length > 1){
        return this;
    };
    

    this.initialize = function () {
    	
    	lkHttpServiceIframe = this.$element;
    	$iframe = $("<IFRAME/>").attr({
		    id: settings.targetIframeId,
		    name:settings.targetIframeId,
		    frameborder: 0,
		    scrolling:"no",
		    width:"100%"
		}).appendTo(lkHttpServiceIframe);  

    	$windowProxy = new Porthole.WindowProxy(
   	         settings.serviceProxyUrl, settings.targetIframeId);
    	 $windowProxy.addEventListener(onIFrameMessage);
    	 //proxy toast and confirm 
    	 if(!hasEventHandler("_toast")){
    		 this.setEventHandler("_toast",function(e){
        		 $().toastmessage(e.data["key"], e.data["value"]);
        	 });
    	 }
    	 if(!hasEventHandler("_confirm")){
    		 this.setEventHandler("_confirm",function(e){
        		 var msg = e.data.message;
        		 var func = e.data.func;
        		 var cancelFunc = e.data.cancelFunc;
        		 bootbox.confirm(msg, function(result) { 
        			 if (result) { 
        				 $windowProxy.post({if_key: "_func", "func": func});
        			 }else if(cancelFunc){
        				 $windowProxy.post({if_key: "_func", "func": cancelFunc});
        			 }
        		 });
        	 }); 
    	 }
    	
    	 //post iframe
    	 var postForm = $("<form/>").attr({
    		    method: "post",
    		    action: settings.serviceUrl,
    		    target: settings.targetIframeId
    		});
    	 $("<input type='hidden' name='deletedIds'/>").val(settings.deletedIds).appendTo(postForm);
    	 $("<input type='hidden' name='rows'/>").val(settings.rows).appendTo(postForm);
    	 for(var key in settings.params){
    		 $("<input type='hidden' name='"+key+"'/>").val(settings.params[key]).appendTo(postForm);
    	 }

    	 $("body").append(postForm);
    	 postForm.submit();
    	 
    	 
		return this;
    };
    
    this.getIframe = function (){
    	
    	return $iframe;
    };
    this.setEventHandler = function(key,handler){
    	if(key   && handler ){
    		proxyEvents[key] = handler;
    	};
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
				obj = new LkHttpServiceIframe($this, opts);
				$.data(this, pluginName, obj);
			};
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
			obj = new LkHttpServiceIframe(elem, opts);
			$.data(elem, pluginName, obj);
		}
		return obj;
	};


	$.fn[pluginName].defaults = {
		expand: true
	};

	$(function() {
		$('[data-lkHttpServiceIframe]')[pluginName]();
	});

}(jQuery));
