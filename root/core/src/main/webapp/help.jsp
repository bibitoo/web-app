<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<title>HELP</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-store" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<link type="image/x-icon" href="${ctx}/static/images/favicon.ico" rel="shortcut icon">
            <link href="${ctx}/static/styles/default/bootstrap.min.css" rel="stylesheet">
 <link href="${ctx}/static/styles/jqueryui/bootstrap/jquery-ui-1.10.0.custom.css" type="text/css" rel="stylesheet" />
<link href="${ctx}/static/styles/default.css" type="text/css" rel="stylesheet" />

<link href="${ctx}/static/styles/default/tablesorter.css" rel="stylesheet">
            <!-- Le styles -->
            <link type="text/css" href="${ctx}/static/styles/default/font-awesome.min.css" rel="stylesheet" />
            <!--[if IE 7]>
            <link rel="stylesheet" href="${ctx}/static/styles/default/font-awesome-ie7.min.css">
            <![endif]-->
            <!--[if lt IE 9]>
            <link href="${ctx}/static/styles/jqueryui/bootstrap/jquery.ui.1.10.0.ie.css" type="text/css" rel="stylesheet" />
            <![endif]-->
            <link href="${ctx}/static/styles/default/docs.css" rel="stylesheet">
            <link href="${ctx}/static/javascript/google-code-prettify/prettify.css" rel="stylesheet">

            <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
            <!--[if lt IE 9]>
            <script src="${ctx}/static/javascript/html5.js"></script>
            <![endif]-->

<script src="${ctx}/static/javascript/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-migrate-1.2.1.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/bootstrap.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.validate.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/messages_bs_zh.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/google-code-prettify/prettify.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/tablesorter/jquery.tablesorter.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/tablesorter/jquery.tablesorter.widgets.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/tablesorter/widgets/widget-scroller.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/tablesorter/pager/jquery.tablesorter.pager.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.ba-bbq.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/docs.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/jquery-select-dialog.js" type="text/javascript"></script>


</head>

<body>
<div class="container"> 
 <script>
 $(function(){
	 $('body').attr('data-spy', 'scroll');
	 $('body').attr('data-target', '.bs-docs-sidebar');
	 $('#bs-docs-sidebar').scrollspy();
	 
 });
 </script>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<fmt:bundle basename="i18n.message">
        <!-- Navbar
        ================================================== -->
 <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="brand" href="http://doframe.com">DoFrame</a>
                    <div class="nav-collapse collapse">
                        <ul class="nav nav-pills">
                            <li class="active">
                                <a href="${ctx }/"><fmt:message key="nav.bar.home"/></a>
                            </li>
                            <li class="dropdown">
						        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><fmt:message key="nav.bar.navigation"/> <b class="caret"></b></a>
						        <%@ include file="/WEB-INF/layouts/menu.jsp"%>
						      </li>
                           
                            <li>
                                <a href="http://doframe.com/feedback.php"><fmt:message key="nav.bar.feedback"/></a>
                            </li>
                            <li>
                                <a href="http://doframe.com/contact"><fmt:message key="nav.bar.contack"/></a>
                            </li>
                        </ul>
                        
                        <div id="help" class="pull-right">
                        	
                        	 <ul class="nav nav-pills">
                        	    <li>
                        	    	<shiro:guest><a href="/cas/login?service=<tags:urlContext/>/shiro-cas"><fmt:message key="core.user.login"/></a></shiro:guest>
                        	    </li>
                        	 	<li  <shiro:user>class="dropdown"</shiro:user>>
                        	 		 <shiro:user>
											<a class=" dropdown-toggle" data-toggle="dropdown" href="#">
												<i class="icon-user"></i> <shiro:principal property="name"/>
												<span class="caret"></span>
											</a>
										
											<ul class="dropdown-menu">
												<shiro:hasRole name="admin">
													<li><a href="${ctx}/core/user/list"><fmt:message key="core.user.management"/></a></li>
													<li class="divider"></li>
												</shiro:hasRole>
												<li><a href="${ctx}/profile"><fmt:message key="user.profile" /></a></li>
												<li><a href="/cas/logout?service=<tags:urlContext/>/shiro-cas"><fmt:message key="user.logout"/></a></li>
											</ul>
									</shiro:user>
									<shiro:guest>
									<a href="${ctx }/register"><fmt:message key="core.user.registration"/></a>
									</shiro:guest>
                        	 	</li>
	                        	 <li class="dropdown">
							        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><fmt:message key="nav.bar.help"/> <b class="caret"></b></a>
							        <ul class="dropdown-menu">
							          <li><a href="${ctx }/help.jsp">JQuery UI Help</a></li>
							           <li><a href="http://wrongwaycn.github.io/bootstrap/docs/index.html" target="_blank">Bootstrap Help</a></li>
							        </ul>
							      </li>
						      </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</fmt:bundle>

        <!-- Subhead
        ================================================== -->
        <header class="jumbotron subhead" id="overview">
            <div class="container">
                <h1>jQuery UI Bootstrap</h1>
                <p class="lead">A Bootstrap-themed kickstart for jQuery UI widgets (v0.5).</p>
            </div>
        </header>


        <div class="container">
        <!-- Docs nav ================================================== -->
        <div class="row">
        <div class="span3 bs-docs-sidebar">
            <ul id="bs-docs-sidebar" class="nav nav-list bs-docs-sidenav">
                <li><a href="#download-bootstrap"><i class="icon-chevron-right"></i> Download</a></li>
                <li><a href="#button"><i class="icon-chevron-right"></i> Button</a></li>
                <li><a href="#accordion"><i class="icon-chevron-right"></i> Accordion</a></li>
                <li><a href="#dialog"><i class="icon-chevron-right"></i> Dialog</a></li>
                <li><a href="#tabs-simple"><i class="icon-chevron-right"></i> Tabs</a></li>
                <li><a href="#overlay"><i class="icon-chevron-right"></i> Overlay</a></li>
                <li><a href="#block-state"><i class="icon-chevron-right"></i> Highlight/Error</a></li>
                <li><a href="#calendar"><i class="icon-chevron-right"></i> Datepicker</a></li>
                <li><a href="#slider"><i class="icon-chevron-right"></i> Slider</a></li>
                <li><a href="#autocomplete"><i class="icon-chevron-right"></i> Autocomplete</a></li>
                <li><a href="#block-menu"><i class="icon-chevron-right"></i> Menu</a></li>
                <li><a href="#block-spinner"><i class="icon-chevron-right"></i> Spinner</a></li>
                <li><a href="#block-icons"><i class="icon-chevron-right"></i> Icons</a></li>
                <li><a href="#block-tooltip"><i class="icon-chevron-right"></i> Tooltip</a></li>
                <li><a href="#block-ckeditor"><i class="icon-chevron-right"></i> Ckeditor</a></li>
                 <li><a href="#block-icon"><i class="icon-chevron-right"></i> Font Icons</a></li>
            </ul>
        </div>
        
        <div class="span9">
            <!-- Download ================================================== -->
            <section id="download-bootstrap">
                <div class="page-header">
                    <h1>1. Download</h1>
                </div>
                <div class="row-fluid">
                    <p class="docs-lead">
                        Welcome! This is a live preview of the new jQuery UI Bootstrap theme - a project I started to bring the beauty of Twitter's <a href="http://twitter.github.com/bootstrap/">Bootstrap</a> to jQuery UI widgets.
                        With this theme, not only do you get the ability to use Bootstrap-themed widgets, but you can now also use (most) of Twitter Bootstrap side-by-wide with it without components breaking visually.
                        It's still a work-in-progress, but I hope you find it useful. Issues and pull requests are always welcome - <a href="http://twitter.com/addyosmani">@addyosmani</a></p>
                    </p>
                    <p>
                        <a class="download-btn ui-button-primary"href="https://github.com/addyosmani/jquery-ui-bootstrap/zipball/v0.23">Download stable (v0.23)</a>
                        <a class="download-btn" href="https://github.com/addyosmani/jquery-ui-bootstrap/zipball/master" >Download Latest (dev)</a>
                    </p>
                </div>
            </section>
            <div class="page-header">
                <h1>2. Documentation</h1>
            </div>
            <div class="alert alert-info">
                <span class="icon-info-sign"></span> This theme's support for more third-party widgets may improve over-time, based on requests and the popularity of the widgets.
            </div>
            <!-- Button -->
            <section id="button">
                <div class="page-header">
                    <h1>Button</h1>
                </div>
                <!-- Buttons -->
                <h2>Button default</h2>
                <p>
                    <button>Default</button>
                    <button class="ui-button-primary">Primary</button>
                    <button class="ui-button-success">Success</button>
                    </br>
                    </br>
                    <button class="ui-button-error">Danger</button>
                    <a class="button">Anchor</a>
                    <input type="submit" class="button" value="Submit"/>
                </p>

<pre class="prettyprint linenums">
// Button
$('button').button();
// Anchors, Submit
$('.button').button();
</pre>
                <!-- Button set-->
                <h2>Button set</h2>
                <p>
                    <form>
                        <div id="radioset">
                            <input type="radio" id="radio1" name="radio" /><label for="radio1">Choice 1</label>
                            <input type="radio" id="radio2" name="radio" checked="checked" /><label for="radio2">Choice 2</label>
                            <input type="radio" id="radio3" name="radio" /><label for="radio3">Choice 3</label>
                        </div>
                        </br>
                        <div id="format">
                            <input type="checkbox" id="check1" /><label for="check1">B</label>
                            <input type="checkbox" id="check2" /><label for="check2">I</label>
                            <input type="checkbox" id="check3" /><label for="check3">U</label>
                        </div>
                        </br>
                    </form>
                </p>
<pre class="prettyprint linenums">
// Buttonset
$('#radioset').buttonset();
$("#format").buttonset();
</pre>
            <h2>Simple toolbar</h2>
                <div id="toolbar" class="span4 ui-toolbar ui-widget-header ui-corner-all">

                <input type="checkbox" id="shuffle" /><label for="shuffle">Shuffle</label>
                
                <span id="repeat">
                  <input type="radio" id="repeat0" name="repeat" checked="checked" /><label for="repeat0">No Repeat</label>
                  <input type="radio" id="repeat1" name="repeat" /><label for="repeat1">Once</label>
                  <input type="radio" id="repeatall" name="repeat" /><label for="repeatall">All</label>
                </span>

              </div>
              <div class="clearfix"></div>
<pre class="prettyprint linenums">
//Toolbar
$("#play, #shuffle").button();
$("#repeat").buttonset();
</pre>
            </section>
            <!-- Accordion -->
            <section id="accordion">
                <div class="page-header">
                    <h1>Accordion</h1>
                </div>
                <div id="menu-collapse">
                    <div>
                        <h3><a href="#">First</a></h3>
                        <div>Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.</div>
                    </div>
                    <div>
                        <h3><a href="#">Second</a></h3>
                        <div>Phasellus mattis tincidunt nibh.</div>
                    </div>
                    <div>
                        <h3><a href="#">Third</a></h3>
                        <div>Nam dui erat, auctor a, dignissim quis.</div>
                    </div>
                </div>
<pre class="prettyprint linenums">
// Accordion
$("#menu-collapse").accordion({
    header: "h3"
});
</pre>
            </section>
            <!-- Dialog -->
            <section id="dialog">
                <div class="page-header">
                    <h1>Dialog</h1>
                </div>
                <p class="dialog-button">
                    <a href="#" id="dialog_link" class="ui-state-default ui-corner-all">
                        <span class="ui-icon ui-icon-newwin"></span>Open Dialog
                    </a>
                    &nbsp;
                    <a href="#" id="modal_link" class="ui-state-default ui-corner-all">
                        <span class="ui-icon ui-icon-newwin"></span>
                        Open Modal Dialog
                    </a>
                </p>
                <!-- ui-dialog -->
                <div id="dialog_simple" title="Dialog Simple Title">
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                </div>
                <!--static dialog-->
                <div id="dialog-message" title="Modal Dialog">
                    <p>
                        <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
                        Your files have downloaded successfully into the My Downloads folder.
                    </p>
                    <p>
                        Currently using <b>36% of your storage space</b>.
                    </p>
                </div>
                <!--end static dialog-->
<pre class="prettyprint linenums">
// Dialog Link
$('#dialog_link').click(function () {
    $('#dialog_simple').dialog('open');
    return false;
});

// Modal Link
$('#modal_link').click(function () {
    $('#dialog-message').dialog('open');
    return false;
});

// Dialog Simple
$('#dialog_simple').dialog({
    autoOpen: false,
    width: 600,
    buttons: {
        "Ok": function () {
            $(this).dialog("close");
        },
        "Cancel": function () {
            $(this).dialog("close");
        }
    }
});

// Dialog message
$("#dialog-message").dialog({
    autoOpen: false,
    modal: true,
    buttons: {
        Ok: function () {
            $(this).dialog("close");
        }
    }
});
</pre>
            </section>
            <!-- Tabs -->
            <section id="tabs-simple">
                <div class="page-header">
                    <h1>Tabs</h1>
                </div>
                <h2>Simple tabs</h2>
                <!--Demo-->
                <div id="tabs">
                    <ul>
                        <li><a href="#tabs-a">First</a></li>
                        <li><a href="#tabs-b">Second</a></li>
                        <li><a href="#tabs-c">Third</a></li>
                    </ul>
                    <div id="tabs-a">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
                    <div id="tabs-b">Phasellus mattis tincidunt nibh. Cras orci urna, blandit id, pretium vel, aliquet ornare, felis. Maecenas scelerisque sem non nisl. Fusce sed lorem in enim dictum bibendum.</div>
                    <div id="tabs-c">Nam dui erat, auctor a, dignissim quis, sollicitudin eu, felis. Pellentesque nisi urna, interdum eget, sagittis et, consequat vestibulum, lacus. Mauris porttitor ullamcorper augue.</div>
                </div>
                <!-- End demo -->
<pre class="prettyprint linenums">
// Simple tabs
$('#tabs').tabs();
</pre>
                <h2>Simple tabs adding and removing.</h2>
                <!-- Demo -->
                <div id="dialog2" title="Tab data">
                    <form>
                        <fieldset class="ui-helper-reset">
                            <label for="tab_title">Title</label>
                            <input type="text" name="tab_title" id="tab_title" value="" class="ui-widget-content ui-corner-all" />
                            <label for="tab_content">Content</label>
                            <textarea name="tab_content" id="tab_content" class="ui-widget-content ui-corner-all"></textarea>
                        </fieldset>
                    </form>
                </div>

                <button id="add_tab" class="ui-button-primary">Add Tab</button>

                <div id="tabs2">
                    <ul>
                        <li><a href="#tabs-1">Nunc tincidunt</a></li>
                    </ul>
                    <div id="tabs-1">
                        <p>Proin elit arcu, rutrum commodo, vehicula tempus, commodo a, risus. Curabitur nec arcu. Donec sollicitudin mi sit amet mauris. Nam elementum quam ullamcorper ante. Etiam aliquet massa et lorem. Mauris dapibus lacus auctor risus. Aenean tempor ullamcorper leo. Vivamus sed magna quis ligula eleifend adipiscing. Duis orci. Aliquam sodales tortor vitae ipsum. Aliquam nulla. Duis aliquam molestie erat. Ut et mauris vel pede varius sollicitudin. Sed ut dolor nec orci tincidunt interdum. Phasellus ipsum. Nunc tristique tempus lectus.</p>
                    </div>
                </div>
                <!-- End demo -->
<pre class="prettyprint linenums">
// Simple tabs adding and removing
$('#tabs2').tabs();

// Dynamic tabs
var tabTitle = $( "#tab_title" ),
    tabContent = $( "#tab_content" ),
    tabTemplate = "&lt;li&gt;&lt;a href='#{href}'>#{label}&lt;/a&gt; &lt;span class='ui-icon ui-icon-close'>Remove Tab&lt;/span&gt;&lt;/li&gt;",
    tabCounter = 2;

var tabs = $( "#tabs2" ).tabs();

// modal dialog init: custom buttons and a "close" callback reseting the form inside
var dialog = $( "#dialog2" ).dialog({
    autoOpen: false,
    modal: true,
    buttons: {
        Add: function() {
            addTab();
            $( this ).dialog( "close" );
        },
        Cancel: function() {
            $( this ).dialog( "close" );
        }
    },
    close: function() {
        form[ 0 ].reset();
    }
});

// addTab form: calls addTab function on submit and closes the dialog
var form = dialog.find( "form" ).submit(function( event ) {
    addTab();
    dialog.dialog( "close" );
    event.preventDefault();
});

// actual addTab function: adds new tab using the input from the form above
function addTab() {
    var label = tabTitle.val() || "Tab " + tabCounter,
        id = "tabs-" + tabCounter,
        li = $( tabTemplate.replace( /#\{href\}/g, "#" + id ).replace( /#\{label\}/g, label ) ),
        tabContentHtml = tabContent.val() || "Tab " + tabCounter + " content.";

    tabs.find( ".ui-tabs-nav" ).append( li );
    tabs.append( "&lt;div id='" + id + "&gt;&lt;/div&gt;&lt;p&gt;" + tabContentHtml + "&lt;/p&gt;&lt;/div&gt;" );
    tabs.tabs( "refresh" );
    tabCounter++;
}

// addTab button: just opens the dialog
$( "#add_tab" )
    .button()
    .click(function() {
        dialog.dialog( "open" );
    });

// close icon: removing the tab on click
$( "#tabs2" ).on( "click",'span.ui-icon-close', function() {

    var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
    $( "#" + panelId ).remove();
    tabs.tabs( "refresh" );
});
</pre>
                <h2>Combination examples</h2>
                <!--start combinations-->
                <div id="tabs3">
                    <ul>
                        <li><a href="#tabs3-1">First</a></li>
                        <li><a href="#tabs3-2">Second</a></li>
                        <li><a href="#tabs3-3">Third</a></li>
                    </ul>
                    <div id="tabs3-1">
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget diam nec urna hendrerit tempus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum aliquam ligula non nulla cursus volutpat. Aliquam malesuada felis nec turpis auctor interdum. Cras et lobortis dolor. Nam sodales, dolor eu cursus faucibus, justo leo vestibulum turpis, id malesuada erat ipsum et leo. Integer id aliquam augue. Proin quis risus magna.</p>
                        <a href="#" id="sampleButton">Change</a>
                    </div>
                    <div id="tabs3-2">Tab 2</div>
                    <div id="tabs3-3">Tab 3</div>
                </div>
                <!--end combinations-->
<pre class="prettyprint linenums">
//Combination examples (tabs) and open dialog
$('#sampleButton').on('click', function(event){
    event.preventDefault();
    $('#dialog_simple').dialog({
        autoOpen: true,
        modal: true,
        width: 600,
        buttons: {
            "Save": function () {
                $(this).dialog("close");
            },
            "Cancel": function () {
                $(this).dialog("close");
            }
        }
    });
});
</pre>
            <!-- End tabs -->
            </section>
            <section id="overlay">
                <div class="page-header">
                    <h1>Overlay and Shadow Classes</h1>
                </div>
                <div class="window-contain">
                    <p>Lorem ipsum dolor sit amet,  Nulla nec tortor. Donec id elit quis purus consectetur consequat. </p><p>Nam congue semper tellus. Sed erat dolor, dapibus sit amet, venenatis ornare, ultrices ut, nisi. Aliquam ante. Suspendisse scelerisque dui nec velit. Duis augue augue, gravida euismod, vulputate ac, facilisis id, sem. Morbi in orci. </p><p>Nulla purus lacus, pulvinar vel, malesuada ac, mattis nec, quam. Nam molestie scelerisque quam. Nullam feugiat cursus lacus.orem ipsum dolor sit amet, consectetur adipiscing elit. Donec libero risus, commodo vitae, pharetra mollis, posuere eu, pede. Nulla nec tortor. Donec id elit quis purus consectetur consequat. </p><p>Nam congue semper tellus. Sed erat dolor, dapibus sit amet, venenatis ornare, ultrices ut, nisi. Aliquam ante. Suspendisse scelerisque dui nec velit. Duis augue augue, gravida euismod, vulputate ac, facilisis id, sem. Morbi in orci. Nulla purus lacus, pulvinar vel, malesuada ac, mattis nec, quam. Nam molestie scelerisque quam. </p><p>Nullam feugiat cursus lacus.orem ipsum dolor sit amet, consectetur adipiscing elit. Donec libero risus, commodo vitae, pharetra mollis, posuere eu, pede. Nulla nec tortor. Donec id elit quis purus consectetur consequat. Nam congue semper tellus. Sed erat dolor, dapibus sit amet, venenatis ornare, ultrices ut, nisi. Aliquam ante. </p><p>Suspendisse scelerisque dui nec velit. Duis augue augue, gravida euismod, vulputate ac, facilisis id, sem. Morbi in orci. Nulla purus lacus, pulvinar vel, malesuada ac, mattis nec, quam. Nam molestie scelerisque quam. Nullam feugiat cursus lacus.orem ipsum dolor sit amet, consectetur adipiscing elit. Donec libero risus, commodo vitae, pharetra mollis, posuere eu, pede. Nulla nec tortor. Donec id elit quis purus consectetur consequat. Nam congue semper tellus. Sed erat dolor, dapibus sit amet, venenatis ornare, ultrices ut, nisi. </p>

                    <!-- ui-overlay -->
                    <div class="ui-overlay">
                        <div class="ui-widget-overlay"></div>
                        <div class="ui-widget-shadow ui-corner-all" style="width: 302px; height: 152px; position: absolute; left: 50px; top: 30px;"></div>
                    </div>
                    <div style="position: absolute; width: 280px; height: 130px;left: 50px; top: 30px; padding: 10px;" class="ui-widget ui-widget-content ui-corner-all">
                        <div class="ui-dialog-content ui-widget-content" style="background: none; border: 0;">
                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                        </div>
                    </div>

                </div>
            </section>
            <section id="block-state">
                <div class="page-header">
                    <h1>Highlight / Error</h1>
                </div>
                <!-- Highlight / Error -->
                <h2>Highlight</h2>
                <div class="ui-widget">
                  <div class="ui-state-highlight ui-corner-all">
                    <p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
                    <strong>Hey!</strong> Sample ui-state-highlight style.</p>
                  </div>
                </div>
                <h2>Error</h2>
                <div class="ui-widget">
                  <div class="ui-state-error ui-corner-all">
                    <p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                    <strong>Alert:</strong> Sample ui-state-error style.</p>
                  </div>
                </div>
                <h2>Default</h2>
                <div class="ui-widget">
                  <div class="ui-state-default ui-corner-all">
                    <p><span class="ui-icon ui-icon-mail-closed" style="float: left; margin-right: .3em;"></span>
                    <strong>Hello:</strong> Sample ui-state-default style.</p>
                  </div>
                </div>
            </section>
            <!--end highlights-->
            <!-- Datepicker -->
            <section id="calendar">
                <div class="page-header">
                    <h1>Datepicker</h1>
                </div>
                <div id="datepicker"></div>
<pre class="prettyprint linenums">
// Datepicker
$('#datepicker').datepicker({
    inline: true
});
</pre>
            </section>
            <!--end datepicker-->
            <!-- Slider -->
            <section id="slider">
                <div class="page-header">
                    <h1>Slider</h1>
                </div>
                <h2>Horizontal Slider</h2>
                <div id="h-slider"></div>
<pre class="prettyprint linenums">
// Horizontal slider
$('#h-slider').slider({
    range: true,
    values: [17, 67]
});
</pre>
                 <!-- Vertical Slider -->
                <h2>Vertical Slider</h2>
                <div class="row-fluid">
                    <div class="span6">
                        <p class="ui-state-default ui-corner-all ui-helper-clearfix" style="padding:4px;">
                        <span class="ui-icon ui-icon-volume-on" style="float:left; margin:-2px 5px 0 0;"></span>
                        Master volume
                        </p>
                        <p>
                          <label for="amount">Volume:</label>
                          <input type="text" id="amount" />
                        </p>
                    </div>
                    <div class="span6">
                        <div id="v-slider" style="height:200px;"></div>
                    </div>
                </div>
<pre class="prettyprint linenums">
// Vertical slider
$("#v-slider").slider({
    orientation: "vertical",
    range: "min",
    min: 0,
    max: 100,
    value: 60,
    slide: function (event, ui) {
        $("#amount").val(ui.value);
    }
});
$("#amount").val($("#v-slider").slider("value"));
</pre>
            </section>
            <!--end slider-->
            <!-- Autocomplete -->
            <section id="autocomplete">
                <div class="page-header">
                    <h1>Autocomplete</h1>
                </div>
                <div class="ui-widget">
                    <label for="tags">Tags: </label>
                    <input id="tags" />
                </div>
<pre class="prettyprint linenums">
// Autocomplete
var availableTags = ["ActionScript", "AppleScript", "Asp", "BASIC", "C", "C++", "Clojure", "COBOL", "ColdFusion", "Erlang", "Fortran", "Groovy", "Haskell", "Java", "JavaScript", "Lisp", "Perl", "PHP", "Python", "Ruby", "Scala", "Scheme"];

$("#tags").autocomplete({
    source: availableTags
});
</pre>
            </section>
            <!--end Autocomplete-->
            <!-- Menu -->
            <section id="block-menu">
                <div class="page-header">
                    <h1>Menu</h1>
                </div>
                <div class="clearfix">
                    <ul id="menu">
                      <li><a href="#">Aberdeen</a></li>
                      <li><a href="#">Ada</a></li>
                      <li><a href="#">Adamsville</a></li>
                      <li><a href="#">Addyston</a></li>
                      <li>
                          <a href="#">Delphi</a>
                          <ul>
                              <li><a href="#">Ada</a></li>
                              <li><a href="#">Saarland</a></li>
                              <li><a href="#">Salzburg</a></li>
                          </ul>
                      </li>
                      <li><a href="#">Saarland</a></li>
                      <li>
                          <a href="#">Salzburg</a>
                          <ul>
                              <li>
                                  <a href="#">Delphi</a>
                                  <ul>
                                      <li><a href="#">Ada</a></li>
                                      <li><a href="#">Saarland</a></li>
                                      <li><a href="#">Salzburg</a></li>
                                  </ul>
                              </li>
                              <li>
                                  <a href="?Delphi">Delphi</a>
                                  <ul>
                                      <li><a href="#">Ada</a></li>
                                      <li><a href="#">Saarland</a></li>
                                      <li><a href="#">Salzburg</a></li>
                                  </ul>
                              </li>
                              <li><a href="#">Perch</a></li>
                          </ul>
                      </li>
                    </ul>
                </div>
<pre class="prettyprint linenums">
//####### Menu
$("#menu").menu();
</pre>
            </section>
            <!--end Menu-->
            <!-- Spinner -->
            <section id="block-spinner">
                <div class="page-header">
                    <h1>Spinner</h1>
                </div>
                <h2>Spinner</h2>
                <p>
                  <label for="spinner">Select a value:</label>
                  <input id="spinner" name="value" />
                </p>

                <p>
                  <button id="disable">Toggle disable/enable</button>
                  <button id="destroy">Toggle widget</button>
                </p>

                <p>
                  <button id="getvalue">Get value</button>
                  <button id="setvalue">Set value to 5</button>
                </p>
<pre class="prettyprint linenums">
//####### Spinner

var spinner = $( "#spinner" ).spinner();

$( "#disable" ).click(function() {
    if ( spinner.spinner( "option", "disabled" ) ) {
        spinner.spinner( "enable" );
    } else {
        spinner.spinner( "disable" );
    }
});
$( "#destroy" ).click(function() {
    if ( spinner.data( "ui-spinner" ) ) {
        spinner.spinner( "destroy" );
    } else {
        spinner.spinner();
    }
});
$( "#getvalue" ).click(function() {
    alert( spinner.spinner( "value" ) );
});
$( "#setvalue" ).click(function() {
    spinner.spinner( "value", 5 );
});

</pre>
            </section>
            <!--end Spinner-->
            <!-- Icons -->
            <section id="block-icons">
                <div class="page-header">
                    <h1>Icons</h1>
                </div>
                <div class="clearfix">
                    <ul id="icons" class="ui-widget ui-helper-clearfix">
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-n"><span class="ui-icon ui-icon-carat-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-ne"><span class="ui-icon ui-icon-carat-1-ne"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-e"><span class="ui-icon ui-icon-carat-1-e"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-se"><span class="ui-icon ui-icon-carat-1-se"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-s"><span class="ui-icon ui-icon-carat-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-sw"><span class="ui-icon ui-icon-carat-1-sw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-w"><span class="ui-icon ui-icon-carat-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-1-nw"><span class="ui-icon ui-icon-carat-1-nw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-2-n-s"><span class="ui-icon ui-icon-carat-2-n-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-carat-2-e-w"><span class="ui-icon ui-icon-carat-2-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-n"><span class="ui-icon ui-icon-triangle-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-ne"><span class="ui-icon ui-icon-triangle-1-ne"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-e"><span class="ui-icon ui-icon-triangle-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-se"><span class="ui-icon ui-icon-triangle-1-se"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-s"><span class="ui-icon ui-icon-triangle-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-sw"><span class="ui-icon ui-icon-triangle-1-sw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-w"><span class="ui-icon ui-icon-triangle-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-1-nw"><span class="ui-icon ui-icon-triangle-1-nw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-2-n-s"><span class="ui-icon ui-icon-triangle-2-n-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-triangle-2-e-w"><span class="ui-icon ui-icon-triangle-2-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-n"><span class="ui-icon ui-icon-arrow-1-n"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-ne"><span class="ui-icon ui-icon-arrow-1-ne"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-e"><span class="ui-icon ui-icon-arrow-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-se"><span class="ui-icon ui-icon-arrow-1-se"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-s"><span class="ui-icon ui-icon-arrow-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-sw"><span class="ui-icon ui-icon-arrow-1-sw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-w"><span class="ui-icon ui-icon-arrow-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-1-nw"><span class="ui-icon ui-icon-arrow-1-nw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-2-n-s"><span class="ui-icon ui-icon-arrow-2-n-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-2-ne-sw"><span class="ui-icon ui-icon-arrow-2-ne-sw"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-2-e-w"><span class="ui-icon ui-icon-arrow-2-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-2-se-nw"><span class="ui-icon ui-icon-arrow-2-se-nw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowstop-1-n"><span class="ui-icon ui-icon-arrowstop-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowstop-1-e"><span class="ui-icon ui-icon-arrowstop-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowstop-1-s"><span class="ui-icon ui-icon-arrowstop-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowstop-1-w"><span class="ui-icon ui-icon-arrowstop-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-n"><span class="ui-icon ui-icon-arrowthick-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-ne"><span class="ui-icon ui-icon-arrowthick-1-ne"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-e"><span class="ui-icon ui-icon-arrowthick-1-e"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-se"><span class="ui-icon ui-icon-arrowthick-1-se"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-s"><span class="ui-icon ui-icon-arrowthick-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-sw"><span class="ui-icon ui-icon-arrowthick-1-sw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-w"><span class="ui-icon ui-icon-arrowthick-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-1-nw"><span class="ui-icon ui-icon-arrowthick-1-nw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-2-n-s"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-2-ne-sw"><span class="ui-icon ui-icon-arrowthick-2-ne-sw"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-2-e-w"><span class="ui-icon ui-icon-arrowthick-2-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthick-2-se-nw"><span class="ui-icon ui-icon-arrowthick-2-se-nw"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthickstop-1-n"><span class="ui-icon ui-icon-arrowthickstop-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthickstop-1-e"><span class="ui-icon ui-icon-arrowthickstop-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthickstop-1-s"><span class="ui-icon ui-icon-arrowthickstop-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowthickstop-1-w"><span class="ui-icon ui-icon-arrowthickstop-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturnthick-1-w"><span class="ui-icon ui-icon-arrowreturnthick-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturnthick-1-n"><span class="ui-icon ui-icon-arrowreturnthick-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturnthick-1-e"><span class="ui-icon ui-icon-arrowreturnthick-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturnthick-1-s"><span class="ui-icon ui-icon-arrowreturnthick-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturn-1-w"><span class="ui-icon ui-icon-arrowreturn-1-w"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturn-1-n"><span class="ui-icon ui-icon-arrowreturn-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturn-1-e"><span class="ui-icon ui-icon-arrowreturn-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowreturn-1-s"><span class="ui-icon ui-icon-arrowreturn-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowrefresh-1-w"><span class="ui-icon ui-icon-arrowrefresh-1-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowrefresh-1-n"><span class="ui-icon ui-icon-arrowrefresh-1-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowrefresh-1-e"><span class="ui-icon ui-icon-arrowrefresh-1-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrowrefresh-1-s"><span class="ui-icon ui-icon-arrowrefresh-1-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-4"><span class="ui-icon ui-icon-arrow-4"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-arrow-4-diag"><span class="ui-icon ui-icon-arrow-4-diag"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-extlink"><span class="ui-icon ui-icon-extlink"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-newwin"><span class="ui-icon ui-icon-newwin"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-refresh"><span class="ui-icon ui-icon-refresh"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-shuffle"><span class="ui-icon ui-icon-shuffle"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-transfer-e-w"><span class="ui-icon ui-icon-transfer-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-transferthick-e-w"><span class="ui-icon ui-icon-transferthick-e-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-folder-collapsed"><span class="ui-icon ui-icon-folder-collapsed"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-folder-open"><span class="ui-icon ui-icon-folder-open"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-document"><span class="ui-icon ui-icon-document"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-document-b"><span class="ui-icon ui-icon-document-b"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-note"><span class="ui-icon ui-icon-note"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-mail-closed"><span class="ui-icon ui-icon-mail-closed"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-mail-open"><span class="ui-icon ui-icon-mail-open"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-suitcase"><span class="ui-icon ui-icon-suitcase"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-comment"><span class="ui-icon ui-icon-comment"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-person"><span class="ui-icon ui-icon-person"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-print"><span class="ui-icon ui-icon-print"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-trash"><span class="ui-icon ui-icon-trash"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-locked"><span class="ui-icon ui-icon-locked"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-unlocked"><span class="ui-icon ui-icon-unlocked"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-bookmark"><span class="ui-icon ui-icon-bookmark"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-tag"><span class="ui-icon ui-icon-tag"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-home"><span class="ui-icon ui-icon-home"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-flag"><span class="ui-icon ui-icon-flag"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-calculator"><span class="ui-icon ui-icon-calculator"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-cart"><span class="ui-icon ui-icon-cart"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-pencil"><span class="ui-icon ui-icon-pencil"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-clock"><span class="ui-icon ui-icon-clock"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-disk"><span class="ui-icon ui-icon-disk"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-calendar"><span class="ui-icon ui-icon-calendar"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-zoomin"><span class="ui-icon ui-icon-zoomin"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-zoomout"><span class="ui-icon ui-icon-zoomout"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-search"><span class="ui-icon ui-icon-search"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-wrench"><span class="ui-icon ui-icon-wrench"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-gear"><span class="ui-icon ui-icon-gear"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-heart"><span class="ui-icon ui-icon-heart"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-star"><span class="ui-icon ui-icon-star"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-link"><span class="ui-icon ui-icon-link"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-cancel"><span class="ui-icon ui-icon-cancel"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-plus"><span class="ui-icon ui-icon-plus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-plusthick"><span class="ui-icon ui-icon-plusthick"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-minus"><span class="ui-icon ui-icon-minus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-minusthick"><span class="ui-icon ui-icon-minusthick"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-close"><span class="ui-icon ui-icon-close"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-closethick"><span class="ui-icon ui-icon-closethick"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-key"><span class="ui-icon ui-icon-key"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-lightbulb"><span class="ui-icon ui-icon-lightbulb"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-scissors"><span class="ui-icon ui-icon-scissors"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-clipboard"><span class="ui-icon ui-icon-clipboard"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-copy"><span class="ui-icon ui-icon-copy"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-contact"><span class="ui-icon ui-icon-contact"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-image"><span class="ui-icon ui-icon-image"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-video"><span class="ui-icon ui-icon-video"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-script"><span class="ui-icon ui-icon-script"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-alert"><span class="ui-icon ui-icon-alert"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-info"><span class="ui-icon ui-icon-info"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-notice"><span class="ui-icon ui-icon-notice"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-help"><span class="ui-icon ui-icon-help"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-check"><span class="ui-icon ui-icon-check"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-bullet"><span class="ui-icon ui-icon-bullet"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-radio-off"><span class="ui-icon ui-icon-radio-off"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-radio-on"><span class="ui-icon ui-icon-radio-on"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-pin-w"><span class="ui-icon ui-icon-pin-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-pin-s"><span class="ui-icon ui-icon-pin-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-play"><span class="ui-icon ui-icon-play"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-pause"><span class="ui-icon ui-icon-pause"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-seek-next"><span class="ui-icon ui-icon-seek-next"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-seek-prev"><span class="ui-icon ui-icon-seek-prev"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-seek-end"><span class="ui-icon ui-icon-seek-end"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-seek-first"><span class="ui-icon ui-icon-seek-first"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-stop"><span class="ui-icon ui-icon-stop"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-eject"><span class="ui-icon ui-icon-eject"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-volume-off"><span class="ui-icon ui-icon-volume-off"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-volume-on"><span class="ui-icon ui-icon-volume-on"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-power"><span class="ui-icon ui-icon-power"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-signal-diag"><span class="ui-icon ui-icon-signal-diag"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-signal"><span class="ui-icon ui-icon-signal"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-battery-0"><span class="ui-icon ui-icon-battery-0"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-battery-1"><span class="ui-icon ui-icon-battery-1"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-battery-2"><span class="ui-icon ui-icon-battery-2"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-battery-3"><span class="ui-icon ui-icon-battery-3"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-plus"><span class="ui-icon ui-icon-circle-plus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-minus"><span class="ui-icon ui-icon-circle-minus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-close"><span class="ui-icon ui-icon-circle-close"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-triangle-e"><span class="ui-icon ui-icon-circle-triangle-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-triangle-s"><span class="ui-icon ui-icon-circle-triangle-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-triangle-w"><span class="ui-icon ui-icon-circle-triangle-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-triangle-n"><span class="ui-icon ui-icon-circle-triangle-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-arrow-e"><span class="ui-icon ui-icon-circle-arrow-e"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-arrow-s"><span class="ui-icon ui-icon-circle-arrow-s"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-arrow-w"><span class="ui-icon ui-icon-circle-arrow-w"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-arrow-n"><span class="ui-icon ui-icon-circle-arrow-n"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-zoomin"><span class="ui-icon ui-icon-circle-zoomin"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-zoomout"><span class="ui-icon ui-icon-circle-zoomout"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circle-check"><span class="ui-icon ui-icon-circle-check"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circlesmall-plus"><span class="ui-icon ui-icon-circlesmall-plus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circlesmall-minus"><span class="ui-icon ui-icon-circlesmall-minus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-circlesmall-close"><span class="ui-icon ui-icon-circlesmall-close"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-squaresmall-plus"><span class="ui-icon ui-icon-squaresmall-plus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-squaresmall-minus"><span class="ui-icon ui-icon-squaresmall-minus"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-squaresmall-close"><span class="ui-icon ui-icon-squaresmall-close"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-grip-dotted-vertical"><span class="ui-icon ui-icon-grip-dotted-vertical"></span></li>

                        <li class="ui-state-default ui-corner-all" title=".ui-icon-grip-dotted-horizontal"><span class="ui-icon ui-icon-grip-dotted-horizontal"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-grip-solid-vertical"><span class="ui-icon ui-icon-grip-solid-vertical"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-grip-solid-horizontal"><span class="ui-icon ui-icon-grip-solid-horizontal"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-gripsmall-diagonal-se"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span></li>
                        <li class="ui-state-default ui-corner-all" title=".ui-icon-grip-diagonal-se"><span class="ui-icon ui-icon-grip-diagonal-se"></span></li>
                    </ul>
                </div>
            </section>
            <!--end Icons-->
            <!-- Datepicker -->
            <section id="block-tooltip">
                <div class="page-header">
                    <h1>Tooltip</h1>
                </div>
                <div id="tooltip">
                  <p><a href="#" title="That's what this widget is">Tooltips</a> can be attached to any element. When you hover
                      the element with your mouse, the title attribute is displayed in a little box next to the element, just like a native tooltip.</p>
                  <p>But as it's not a native tooltip, it can be styled. Any themes built with
                      <a href="http://themeroller.com" title="ThemeRoller: jQuery UI's theme builder application">ThemeRoller</a>
                      will also style tooltips accordingly.</p>
                  <p>Tooltips are also useful for form elements, to show some additional information in the context of each field.</p>
                  <p><label for="age">Your age:</label><input id="age" title="We ask for your age only for statistical purposes." /></p>
                  <p>Hover the field to see the tooltip.</p>
                </div>
<pre class="prettyprint linenums">
//####### Tooltip
$( "#tooltip" ).tooltip();
</pre>
            </section>
            <!--end datepicker-->
                        <!-- ckeditor -->
            <section id="block-ckeditor">
                <div class="page-header">
                    <h1>Ckeditor</h1>
                </div>
                <div id="tooltip">
                   <textarea cols="80" id="editor1" name="editor1" rows="10"></textarea> 
                </div>
                 <script src="${ctx}/static/javascript/ckeditor/ckeditor.js" type="text/javascript"></script>
<script>CKEDITOR.replace( 'editor1' );</script>
                 
<pre class="prettyprint linenums">
//####### Ckeditor
&lt;script src="${ctx}/static/javascript/ckeditor/ckeditor.js" type="text/javascript">&lt;/script>
&lt;script>CKEDITOR.replace( 'editor1' );&lt;/script>
</pre>
            </section>
            <!--end datepicker-->
            
                        <!-- Datepicker -->
            <section id="block-icon">
                <div class="page-header">
                    <h1>Font Icons</h1>
                </div>
                <div id="icon">
                  

  <div class="row">
    <div class="span3">
      <div class="well">
        <i class="icon-">&#xf000;</i> Glass
      </div>
    </div>
    <div class="span3">
      <div class="well">
        <i class="icon- icon-large">&#xf000;</i> Glass Large
      </div>
    </div>
    <div class="span3">
      <i class="icon-">&#xf000;</i> Glass
    </div>
    <div class="span3">
      <i class="icon- icon-large">&#xf000;</i> Glass Large
    </div>
  </div>
  <div class="row" style="font-size: 24px; line-height: 1.5em;">
    <div class="span4">
      <div class="well">
        <i class="icon-">&#xf000;</i> Glass
      </div>
    </div>
    <div class="span4">
      <div class="well">
        <i class="icon- icon-large">&#xf000;</i> Glass Large
      </div>
    </div>
    <div class="span4">
      <i class="icon- icon-large">&#xf000;</i> Glass Large
    </div>

                </div>
<pre class="prettyprint linenums">
//####### Tooltip
&lt;i class="icon- icon-large">&amp;#xf000;&lt;/i> Glass Large
</pre>
            </section>
            <!--end datepicker-->
        </div>
    </div>
</div>



<!-- Footer
================================================== -->
<footer class="footer">
    <div class="container">
        <p>
            jQuery UI Bootstrap &copy; Addy Osmani 2012 - 2013.
        </p>
        <p>
            Twitter Bootstrap &copy; Twitter 2012 - 2013
        </p>
        <ul class="footer-links">
            <li><a href="http://addyosmani.com/blog/">Blog</a></li>
            <li class="muted">&middot;</li>
            <li><a href="https://github.com/addyosmani/jquery-ui-bootstrap/issues?state=open">Issues</a></li>
        </ul>
    </div>
</footer>
<!-- Placed at the end of the document so the pages load faster -->

<script src="${ctx}/static/javascript/demo.js" type="text/javascript"></script>
</div>
</body>
</html>
<%
session.invalidate();
%>