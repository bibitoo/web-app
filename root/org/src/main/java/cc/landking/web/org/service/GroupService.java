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
import cc.landking.web.org.dao.GroupDao;
import cc.landking.web.org.entity.Group;

@Component
@Transactional(readOnly = true)
public class GroupService extends TreeService<Group> {

	private GroupDao groupDao;

	@Override
	public BaseDao<Group> getDao() {
		return groupDao;
	}
	
	@Autowired
	@Qualifier("groupDao")
	public void setGroupDao(GroupDao groupDao) {
		this.groupDao = groupDao;
	}

	public List<Group> findByParent(String id){
		ITree parent = null;
		if(StringUtils.isNotEmpty(id)){
			parent = get(id);
		}
		return groupDao.findByParentAndDeleted(parent, false);
	}

	public List<Group> findByParent(String id, String companyId) {
		if(companyId ==null || companyId.trim().length() == 0){
			return findByParent(id);
		}else{
			return groupDao.findRoot(companyId);
		}
	}
}
