
	<legend><small>			<ul class="nav nav-pills">
             	<li <c:if test="${menuKey == 'Folder' }"> class="active"</c:if>><a href="${ctx}/file/folder"><fmt:message key="entity.folder" bundle="${file}"/></a></li>
             	<li<c:if test="${menuKey == 'Attachment' }"> class="active"</c:if>><a href="${ctx}/file/attachment"><fmt:message key="entity.attachment" bundle="${file}"/></a></li>

             </ul>
</small></legend>

