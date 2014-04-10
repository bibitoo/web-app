package cc.landking.web.org.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.org.entity.Department;


public interface DepartmentDao extends BaseDao<Department> {

	public List<Department> findByParentAndDeleted(ITree parent,boolean deleted);
	
	@Query("SELECT o FROM Department o WHERE o.parent = ?1  and o.deleted = false")
	public List<Department> findByParent(ITree parent);

	@Query("SELECT o FROM Department o WHERE o.parent is null  and o.deleted = false")
	public List<Department> findRoot();
}
