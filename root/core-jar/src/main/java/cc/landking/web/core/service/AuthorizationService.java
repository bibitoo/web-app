package cc.landking.web.core.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.AuthorizationDao;
import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.Authorization;
import cc.landking.web.core.entity.Role;
import cc.landking.web.core.utils.UserUtils;

@Component
@Transactional(readOnly = true)
public class AuthorizationService extends BaseService<Authorization> {


	private AuthorizationDao authorizationDao;

	@Override
	public BaseDao<Authorization> getDao() {
		return authorizationDao;
	}
	
	@Autowired
	@Qualifier("authorizationDao")
	public void setAuthorizationDao(AuthorizationDao authorizationDao) {
		this.authorizationDao = authorizationDao;
	}
	
	public void deleteByRoles(List<Role> roles){
		if(UserUtils.getUserCompanyId() != null){
			authorizationDao.deleteByRoles(roles, UserUtils.getUserCompanyId());
		}else{
			authorizationDao.deleteByRoles(roles);
		}
	}

	public void deleteByRoleAndOrganization(Role role, String orgId) {
		authorizationDao.deleteByRoleAndOrganization(role,orgId);
		
	}


	public List<Role> findRolesByOrganizations(List<String> organizations){
		 List<Role> roles = new ArrayList<Role>();
		
		if(organizations != null && !organizations.isEmpty()){
			
				roles = authorizationDao.findRoleByOrganizations(organizations);

		}
		return roles;
		
	}
	


}
