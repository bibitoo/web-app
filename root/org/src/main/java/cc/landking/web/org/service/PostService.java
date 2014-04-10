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
import cc.landking.web.org.dao.PostDao;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.entity.Post;

@Component
@Transactional(readOnly = true)
public class PostService extends TreeService<Post> {

	private PostDao postDao;

	@Override
	public BaseDao<Post> getDao() {
		return postDao;
	}
	
	@Autowired
	@Qualifier("postDao")
	public void setPostDao(PostDao postDao) {
		this.postDao = postDao;
	}

	public List<Post> findByParent(String id){
		ITree parent = null;
		if(StringUtils.isNotEmpty(id)){
			parent = get(id);
		}
		return postDao.findByParentAndDeleted(parent, false);
	}
	public List<Post> findByParent(String id, String companyId) {
		if(companyId ==null || companyId.trim().length() == 0){
			return findByParent(id);
		}else{
			return postDao.findRoot(companyId);
		}
	}
}
