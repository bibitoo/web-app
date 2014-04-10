<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
	<title>新建文档</title>
	
	<script>
		

		
		//authors
	$(document).ready(function() {
		$("#commentForm").validate({
			debug:true
		});
	});
	var theDialog;
	
</script>
<script src="${ctx}/static/javascript/ckeditor/ckeditor.js" type="text/javascript"></script>

</head>

<body>

<form class="cmxform" id="commentForm" method="get" action="" class="form-horizontal">
	<fieldset>
		<legend>Please provide your name, email address (won't be published) and a comment</legend>
		<div class="control-group">
				<label for="subject" class="control-label">标题:</label>
				<div class="controls">
					<input type="text" id="subject" name="subject"  value="" class="input-large " required maxlength="200"/><font color="red">*</font>
				</div>
		</div>
		<p>
			<label for="cname">Name (required, at least 2 characters)</label>
			<input id="cname" name="name" minlength="2" type="text" required />
		<p>
			<label for="cemail">E-Mail (required)</label>
			<input id="cemail" type="email" name="email" required />
		</p>
		<p>
			<label for="curl">URL (optional)</label>
			<input id="curl" type="url" name="url" />
		</p>
		<p>
			<label for="ccomment">Your comment (required)</label>
			<textarea id="ccomment" name="comment" required></textarea>
		</p>
		<p>
			<input class="submit" type="submit" value="Submit"/>
		</p>
	</fieldset>
</form>

	 
</body>
</html>