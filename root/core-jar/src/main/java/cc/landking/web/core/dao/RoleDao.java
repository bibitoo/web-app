package cc.landking.web.core.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.entity.Role;

public interface RoleDao extends BaseDao<Role> {
	
	@Query("select o from Role o where o.code not in ?1 and o.sysCode=?2")
	public List<Role> findNotExistByCodes(List<String> codes,String sysCode);
	
	  @Modifying
	@Query("delete from Role a where a.code = ?1 and a.sysCode=?2")
	public void deleteByCode(String code,String sysCode);
	  
	  public Role findByCodeAndSysCode(String code,String sysCode);
	  
	  @Query("select a from Role a where  a.sysCode=?1")
	  public List<Role> findAuthorizableRoles(String sysCode);


}
