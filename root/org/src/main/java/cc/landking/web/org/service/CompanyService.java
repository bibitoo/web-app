package cc.landking.web.org.service;

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
import cc.landking.web.org.dao.CompanyDao;
import cc.landking.web.org.entity.Company;

@Component
@Transactional(readOnly = true)
public class CompanyService extends TreeService<Company> {

	private CompanyDao companyDao;

	@Override
	public BaseDao<Company> getDao() {
		return companyDao;
	}
	
	@Autowired
	@Qualifier("companyDao")
	public void setCompanyDao(CompanyDao companyDao) {
		this.companyDao = companyDao;
	}

	public List<Company> findByParent(String id){
		ITree parent = null;
		if(StringUtils.isNotEmpty(id)){
			parent = get(id);
		}
		return companyDao.findByParentAndDeleted(parent,false);
	}
}
