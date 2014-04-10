package cc.landking.web.org.dao;

import java.util.List;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.org.entity.Organization;
import org.springframework.data.jpa.repository.Query;

public interface OrganizationDao extends BaseDao<Organization> {

	public List<Organization> findByParentAndDeleted(ITree<?> parent, boolean deleted);
	
	
	@Query("SELECT TYPE(o) FROM Organization o WHERE o.id = ?1")
	public Class<?> getOrganizationType(String id);

}
