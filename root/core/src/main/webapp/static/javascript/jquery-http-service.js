(function ($) {
  "use strict";var pluginName = 'lkHttpService';
   function LkHttpService($element,opts) {
	  
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


		var lkHttpService;
		
		var $windowProxy;


    var settings = $.extend({
    	name:"lk_http_service",
    	serviceUrl:"",
    	deletedIds:null,
    	rows:null,
    	params:null,
    	proxyEventsListener:new Object()
    }, opts);

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
    var hasEventListener = function (key){
    	if(key in settings.proxyEventsListener){
    		return true;
    	}
    	return false;
    }
    if (this.length > 1){
        return this;
    };
    

    this.initialize = function () {
    	
    	lkHttpService = this.$element;
    	
		var purl = document.location.href;
		var proxyUrl = purl.replace( /([^:]+:\/\/[^\/]+\/[^\/]+).*/, '$1' );

		$windowProxy = new Porthole.WindowProxy(
	    		proxyUrl+'/proxy.html');

	    // Register an event handler to receive messages;
		$windowProxy.addEventListener(function(event) { 
	        // handle event
	        if(event.data.if_key && event.data.if_key == "_func"){
	        	window[event.data.func]();
	        }else if(event.data.if_key){
	        	 settings.proxyEventsListener[event.data.if_key](event);
	        };
	       
	    });

		$(document).bind('DOMSubtreeModified', function(e) {
			$this[0].setHeight();
			
		});
		if ($.browser.msie && (eval(parseInt($.browser.version))<9)) {
			$(document).bind("propertychange", function() {
				$this[0].setHeight();
			});  
			window.setTimeout(function() {
				$this[0].setHeight();
			},1000);
		};
    	 
    	 
		return this;
    };
    

    this.setEventListener = function(key,listener){
    	if(key   && handler ){
    		settings.proxyEventsListener[key] = handler;
    	};
    };
	this.setHeight = function () {
		$windowProxy.post({ if_height: $('body').outerHeight( true ) });
	};
	this.toastmessage = function (key,msg){
		$windowProxy.post({if_key: "_toast", key:key,value:msg});
	} ;
	this.confirm = function(message,funcName,cancelFuncName){
		$windowProxy.post({if_key: "_confirm", "func": funcName,"message":message,cancelFunc:cancelFuncName});
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
				obj = new LkHttpService($this, opts);
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
			obj = new LkHttpService(elem, opts);
			$.data(elem, pluginName, obj);
		}
		return obj;
	};


	$.fn[pluginName].defaults = {
		expand: true
	};

	$(function() {
		$('[data-lkHttpService]')[pluginName]();
	});

}(jQuery));
