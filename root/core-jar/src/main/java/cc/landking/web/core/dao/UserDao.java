package cc.landking.web.core.dao;

import cc.landking.web.core.entity.User;

public interface UserDao extends BaseDao<User> {
	User findByLoginName(String loginName);

}
