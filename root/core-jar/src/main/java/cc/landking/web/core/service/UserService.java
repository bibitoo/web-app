package cc.landking.web.core.service;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.domain.Specifications;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.dao.UserDao;
import cc.landking.web.core.entity.User;
import cc.landking.web.core.filter.SessionContext;
import cc.landking.web.core.utils.DateProvider;
import cc.landking.web.core.utils.Digests;
import cc.landking.web.core.utils.Encodes;
import cc.landking.web.core.utils.UserUtils;

/**
 * 用户管理类.
 * 
 * @author sunzhen
 */
@Component
@Transactional(readOnly = true)
public class UserService extends BaseService<User> implements IUserService, ApplicationContextAware{


	private static Logger logger = LoggerFactory.getLogger(UserService.class);

	private UserDao userDao;
	private DateProvider dateProvider = DateProvider.DEFAULT;

	public List<User> getAllUser() {
		return (List<User>) userDao.findAll();
	}
	/* （非 Javadoc）
	 * @see cc.landking.web.core.service.IUserService#getUsers(java.util.Map, int, int, java.lang.String, int)
	 */
	@Override
	public Page<User> getUsers( Map<String, Object> searchParams, int pageNumber, int pageSize,
			String sortType, int sortOrder) {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, sortType,  sortOrder);
		Specification<User> spec = buildSpecification(searchParams);
		Specifications<User> uspec = Specifications.where(spec).and(getDeletedUserSpec());
		return userDao.findAll(uspec, pageRequest);
	}
	  public static Specification<User> getDeletedUserSpec() {
		    return new Specification<User>(){
		    	@Override
				public Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
		        return builder.equal(root.get("deleted"), false);
		      }
		    };
	}
		  





	/* （非 Javadoc）
	 * @see cc.landking.web.core.service.IUserService#getUser(java.lang.String)
	 */
	@Override
	public User getUser(String id) {
		return userDao.findOne(id);
	}

	/* （非 Javadoc）
	 * @see cc.landking.web.core.service.IUserService#findUserByLoginName(java.lang.String)
	 */
	@Override
	public User findUserByLoginName(String loginName) {
		return userDao.findByLoginName(loginName);
	}

	/* （非 Javadoc）
	 * @see cc.landking.web.core.service.IUserService#registerUser(cc.landking.web.core.entity.User)
	 */
	@Override
	@Transactional(readOnly = false)
	public void registerUser(User user) {
		entryptPassword(user);
		user.setRoles("user");
		user.setRegisterDate(dateProvider.getDate());

		userDao.save(user);
	}

	/* （非 Javadoc）
	 * @see cc.landking.web.core.service.IUserService#updateUser(cc.landking.web.core.entity.User)
	 */
	@Override
	@Transactional(readOnly = false)
	public void updateUser(User user) {
		if (StringUtils.isNotBlank(user.getPlainPassword())) {
			entryptPassword(user);
		}
		userDao.save(user);
	}

	/* （非 Javadoc）
	 * @see cc.landking.web.core.service.IUserService#deleteUser(java.lang.String)
	 */
	@Override
	@Transactional(readOnly = false)
	public void deleteUser(String id) {
		User user = getUser(id);
		if (user.isAdmin()) {
			logger.warn("操作员{}尝试删除超级管理员用户", UserUtils.getCurrentUserName());
			throw new ServiceException("不能删除超级管理员用户");
		}
		userDao.delete(id);

	}





	/**
	 * 设定安全的密码，生成随机的salt并经过1024次 sha-1 hash
	 */
	private void entryptPassword(User user) {
		byte[] salt = Digests.generateSalt(SALT_SIZE);
		user.setSalt(Encodes.encodeHex(salt));

		byte[] hashPassword = Digests.sha1(user.getPlainPassword().getBytes(), salt, HASH_INTERATIONS);
		user.setPassword(Encodes.encodeHex(hashPassword));
	}

	@Autowired
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}


	public void setDateProvider(DateProvider dateProvider) {
		this.dateProvider = dateProvider;
	}
	@Override
	public BaseDao<User> getDao() {
		return userDao;
	}
	@Override
	public void resetUserRole(LandkingUser user) {
		if(user == null){
			return;
		}
		user.getRoles().clear();
		User sysuser = get(user.id);
		user.getRoles().addAll(sysuser.getRoleList());
		addRoles(user);
		for(Iterator<IUserRoleAware> it = ctx.getBeansOfType(IUserRoleAware.class).values().iterator(); it.hasNext(); ){
			IUserRoleAware userRoleAware =  it.next();
			userRoleAware.addRoles(user);
		}

		
		if(SessionContext.getContext().get(SessionContext.USER_COMPANY_ID_KEY) != null){
			if(!user.getCompanies().contains(SessionContext.getContext().get(SessionContext.USER_COMPANY_ID_KEY))){
				SessionContext.getContext().remove(SessionContext.USER_COMPANY_ID_KEY);
			}
		}
		if(SessionContext.getContext().get(SessionContext.USER_COMPANY_ID_KEY) == null){
			SessionContext.getContext().put(SessionContext.USER_COMPANY_ID_KEY, user.getCompanyId());
		}
	}
	
	ApplicationContext ctx;
	@Override
	public void setApplicationContext(ApplicationContext ctx)
			throws BeansException {
		this.ctx = ctx;
		
	}

	public void addRoles(LandkingUser user) {
		try{
			Class.forName("cc.landking.web.org.service.OrganizationService");
		}catch(Exception e){
			try{
				OrganizationSpiService spiService = getOrganizationSpiService();
				LandkingUser suser = spiService.getUser(user.getLoginName(), SessionContext.getContext().get(SessionContext.USER_COMPANY_ID_KEY) );
				suser.writeProperties(user);
				logger.debug("Get user "+user.getLoginName()+" role:"+user.getRoles().toString());
			}catch(Exception ex){
				User localUser = get(user.getId());
				user.getRoles().addAll(localUser.getRoleList());
			}
			
		}
		
	}
	public  Map<String,String>  findCurrentUserCompanies(){

		return getOrganizationSpiService().findCompanies(UserUtils.getCurrentUserId());
	}
	private OrganizationSpiService getOrganizationSpiService(){
		return ctx.getBean(OrganizationSpiService.class);
	}


}
