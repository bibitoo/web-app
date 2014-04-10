package cc.landking.web.core.service;

import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.entity.User;

public interface IUserService {
	public static final String HASH_ALGORITHM = "SHA-1";
	public static final int HASH_INTERATIONS = 1024;
	public static final int SALT_SIZE = 8;

	public abstract Page<User> getUsers(Map<String, Object> searchParams,
			int pageNumber, int pageSize, String sortType, int sortOrder);

	public abstract User getUser(String id);

	public abstract User findUserByLoginName(String loginName);

	public abstract void registerUser(User user);

	public abstract void updateUser(User user);

	public abstract void deleteUser(String id);
	
	public abstract void resetUserRole(LandkingUser user);

}