package cc.landking.web.core.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.entity.Authorization;
import cc.landking.web.core.entity.Role;

public interface AuthorizationDao extends BaseDao<Authorization> {
	
	  @Modifying
	@Query("delete from Authorization a where a.role in ?1 and a.companyId=?2")
	public void deleteByRoles(List<Role> roles,String companyId);
	  @Modifying
	@Query("delete from Authorization a where a.role in ?1 and a.companyId is null")
	public void deleteByRoles(List<Role> roles);

	  @Modifying
	 @Query("delete from Authorization a where a.role = ?1 and a.organizationId = ?2")
	public void deleteByRoleAndOrganization(Role role, String organizationId);
	  
	@Query("select a.role from Authorization a where a.organizationId in ?1")
	public List<Role> findRoleByOrganizations(List<String> organizations);
	  
	@Query("select count(a) from Authorization a where a.organizationId in ?1 and a.role.code = ?1")
	public int existRole(List<String> organizations,String roleCode);
}
