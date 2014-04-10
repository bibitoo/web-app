package cc.landking.web.org.service;

import java.util.Collections;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.org.dao.DepartmentDao;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.entity.Organization;

@Component
@Transactional(readOnly = true)
public class DepartmentService extends TreeService<Department> {

	private DepartmentDao departmentDao;

	@Override
	public BaseDao<Department> getDao() {
		return departmentDao;
	}
	
	@Autowired
	@Qualifier("departmentDao")
	public void setDepartmentDao(DepartmentDao departmentDao) {
		this.departmentDao = departmentDao;
	}

	public List<Department> findByParent(String id){
		ITree parent = null;
		if(StringUtils.isNotEmpty(id)){
			parent = get(id);
		}

		
		return departmentDao.findByParentAndDeleted(parent,false);
		
	}


}
