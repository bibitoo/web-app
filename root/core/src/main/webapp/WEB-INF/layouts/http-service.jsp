<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<title><sitemesh:title/></title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-store" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<link type="image/x-icon" href="${ctx}/static/images/favicon.ico" rel="shortcut icon">
            <link href="${ctx}/static/styles/default/bootstrap.min.css" rel="stylesheet">
 <link href="${ctx}/static/styles/jqueryui/bootstrap/jquery-ui-1.10.0.custom.css" type="text/css" rel="stylesheet" />

<link href="${ctx}/static/styles/default/tablesorter.css" rel="stylesheet">
<link href="${ctx}/static/styles/default/jquery.tablesorter.pager.css" rel="stylesheet">
<link href="${ctx}/static/styles/default/jquery-ui-timepicker-addon.css" rel="stylesheet">
<link href="${ctx}/static/styles/zTreeStyle/zTreeStyle.css" rel="stylesheet">
<link href="${ctx}/static/styles/default/jquery.toastmessage-min.css" rel="stylesheet">
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

<%-- <script src="${ctx}/static/javascript/jquery-1.9.1.min.js" type="text/javascript"></script> --%>
<script src="${ctx}/static/javascript/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-migrate-1.2.1.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/bootstrap.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.validate.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/google-code-prettify/prettify.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/tablesorter/jquery.tablesorter.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/tablesorter/jquery.tablesorter.widgets.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/tablesorter/widgets/widget-scroller.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/tablesorter/pager/jquery.tablesorter.pager.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.ba-bbq.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/docs.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/bootbox.min.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/jquery-select-dialog.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-list.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.timeago.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.dateFormat-1.0.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery.toastmessage-min.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/jquery.metadata.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-ui-timepicker-addon.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/jquery.ztree.all-3.5.min.js" type="text/javascript"></script>

<script src="${ctx}/static/javascript/i18n/jquery.ui.datepicker.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/i18n/jquery.ui.datepicker-<tags:locale/>.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/i18n/jquery-ui-timepicker.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/i18n/jquery-ui-timepicker-<tags:locale/>.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/i18n/messages.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/i18n/messages_<tags:locale/>.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/base64.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/porthole.min.js" type="text/javascript"></script>
<script src="${ctx}/static/javascript/jquery-row-selectable-table.js" type="text/javascript"></script>
<sitemesh:head/>
<script>
	var _lkc_ctx = '${requestScope["_lkc_ctx"]}';
	var _lkc_ctx_url = '_lkc_ctx='+encodeURIComponent(_lkc_ctx);
	$.ajaxSetup({ cache: false });
</script>
</head>

<body>
		<sitemesh:body/>
</body>
</html>