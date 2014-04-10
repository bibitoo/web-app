package cc.landking.web.org.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.org.entity.Group;

public interface GroupDao extends BaseDao<Group> {

	public List<Group> findByParentAndDeleted(ITree parent, boolean deleted);
	
	@Query("SELECT o FROM Group o WHERE o.parent is null  and o.deleted = false and o.companyId = ?1")
	public List<Group> findRoot(String companyId);
}
