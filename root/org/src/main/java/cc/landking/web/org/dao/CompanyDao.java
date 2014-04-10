package cc.landking.web.org.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.entity.Company;

public interface CompanyDao extends BaseDao<Company> {

	public List<Company> findByParentAndDeleted(ITree parent, boolean deleted);
	
}
