package cc.landking.web.core.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Value;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.dao.RoleDao;
import cc.landking.web.core.entity.Role;
import cc.landking.web.core.utils.TransactionUtils;

@Component
@Transactional
public class RoleService extends BaseService<Role> {
	
	private @Value("${sysCode}") String sysCode;
	

	@Autowired
	private ShiroRoleService shiroRoleService;

	@Autowired
	private PlatformTransactionManager transactionManager;


	private RoleDao roleDao;

	@Override
	public BaseDao<Role> getDao() {
		return roleDao;
	}
	
	@Autowired
	@Qualifier("roleDao")
	public void setRoleDao(RoleDao roleDao) {
		this.roleDao = roleDao;
	}
	
	public List<Role> findAuthorizableRoles(){
		return roleDao.findAuthorizableRoles(sysCode);
	}	
//	
//	  public List<Role> findOrgRoles(){
//		  return roleDao.findOrgRoles();
//	  }

	@PostConstruct
	public void afterPropertiesSet() throws Exception {;
		TransactionUtils transactionUtils = new TransactionUtils(transactionManager);
		TransactionStatus status =  transactionUtils.beginTransaction();
		try{
			List<String> roles = shiroRoleService.findRoles();
			if(roles.isEmpty()){
				return;
			}
			List<Role> notExistRole = roleDao.findNotExistByCodes(roles,sysCode);
			//delete notExistRole authorize

			//delete notExistRole
			for(Role role:notExistRole){
				try{
					roleDao.deleteByCode(role.getCode(),sysCode);
				}catch(Exception ex){
					//if can't delete, ignore.
				}
			}
			//add or update role
			for(String code : roles){
				Role role = roleDao.findByCodeAndSysCode(code, sysCode);
				if(role == null){
					role = new Role();
					String id = Role.getRoleHash(sysCode+"."+code);
					if(id.length()> 36){
						id = id.substring(0,35);
					}
					role.setId(id);
					role.setCode(code);
					role.setSysCode(sysCode);
					role.setName("core.user.role."+code);
					role.setCreateTime(new Date());
					role.setLastModifyTime(new Date());
					roleDao.save(role);
				}
			}
			transactionUtils.commit(status);
		}catch(Exception ex){
			ex.printStackTrace();
			transactionUtils.rollback(status);
		}
	}
	
}
