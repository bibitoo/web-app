package cc.landking.web.org.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.entity.Post;

public interface PostDao extends BaseDao<Post> {

	public List<Post> findByParentAndDeleted(ITree parent, boolean deleted);
	
	@Query("SELECT o FROM Post o WHERE o.parent is null  and o.deleted = false and o.companyId = ?1")
	public List<Post> findRoot(String companyId);

}
