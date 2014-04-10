package cc.landking.web.file.service;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;

import cc.landking.web.core.utils.UserUtils;

public class FileAuthFilter extends AuthorizationFilter {

	@Override
	protected boolean isAccessAllowed(ServletRequest request,
			ServletResponse response, Object mappedValue) throws Exception {
		if(UserUtils.isAdmin()){
			return true;
		}
		if(UserUtils.hasRole("fileadmin")){
			return true;
		}

		HttpServletRequest req = (HttpServletRequest)request;
		String owner = request.getParameter("o");
		String searchOwner = request.getParameter("search_EQ_owner");
		if((StringUtils.isNotEmpty(owner) && owner.equals(UserUtils.getCurrentUserId()))||
				(StringUtils.isNotEmpty(searchOwner) && searchOwner.equals(UserUtils.getCurrentUserId()))){
			if(UserUtils.getUserCompanyId()!= null){
				if(!(StringUtils.isNotEmpty(owner)&&owner.equals(UserUtils.getUserCompanyId()))||
						!(StringUtils.isNotEmpty(searchOwner)&&owner.equals(UserUtils.getUserCompanyId()))){
					return false;
				}
			}
		}
		return true;
	}
}
