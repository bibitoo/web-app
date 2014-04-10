
	<legend><small>			<ul class="nav nav-pills">
             	<li <c:if test="${menuKey == 'Organization' }"> class="active"</c:if>><a href="${ctx}/org/organization?orgType=Employee"><fmt:message key="entity.organization" bundle="${org}"/></a></li>
              	<li<c:if test="${menuKey == 'Group' }"> class="active"</c:if>><a href="${ctx}/org/group"><fmt:message key="entity.group" bundle="${org}"/></a></li>
             		<li<c:if test="${menuKey == 'Post' }"> class="active"</c:if>><a href="${ctx}/org/post"><fmt:message key="entity.post" bundle="${org}"/></a></li>
             		<shiro:hasAnyRoles name="orgadmin,admin">
             		<li<c:if test="${menuKey == 'DeletedOrganization' }"> class="active"</c:if>><a href="${ctx}/org/organization/listdeleted"><fmt:message key="entity.organization.deleted" bundle="${org}"/></a></li>
             		</shiro:hasAnyRoles>
             </ul>
</small></legend>

