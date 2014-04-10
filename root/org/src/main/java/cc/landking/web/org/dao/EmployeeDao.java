package cc.landking.web.org.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.entity.User;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.entity.Employee;

public interface EmployeeDao extends BaseDao<Employee> {

	public List<Employee> findByParentAndDeleted(ITree parent, boolean deleted);

	
	@Query("select o from Employee o where o.userid = ?1 and o.companyId=?2" )
	public List<Employee> findByUserid(String userid, String companyId);
	@Query("select o from Employee o where o.userid = ?1 " )
	public List<Employee> findByUserid(String userid);
}
