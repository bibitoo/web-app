package cc.landking.web.org.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.entity.User;
import cc.landking.web.core.service.IUserService;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.org.dao.EmployeeDao;
import cc.landking.web.org.entity.Company;
import cc.landking.web.org.entity.Employee;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.exception.UserAssociationException;

@Component
@Transactional(readOnly = true)
public class EmployeeService extends TreeService<Employee> {

	private EmployeeDao employeeDao;
	
	@Autowired
	private IUserService userService;
	
	@Autowired
	private OrganizationService organizationService;

	@Override
	public BaseDao<Employee> getDao() {
		return employeeDao;
	}
	
	@Autowired
	@Qualifier("employeeDao")
	public void setEmployeeDao(EmployeeDao employeeDao) {
		this.employeeDao = employeeDao;
	}

	public List<Employee> findByParent(String id){
		ITree parent = null;
		if(StringUtils.isNotEmpty(id)){
			parent = get(id);
		}
		return employeeDao.findByParentAndDeleted(parent, false);
	}
	
	public Employee getCurrentUser(){
		List<Employee> emps =  employeeDao.findByUserid(UserUtils.getCurrentUserId(), UserUtils.getUserCompanyId());
		if(emps != null && emps.size()>0){
			return emps.get(0);
		}
		return null;
	}
	public List<Company> findCompanyByUserId(String userId){
		List<Company> companies = new ArrayList<Company>();
		 List<Employee> emps = employeeDao.findByUserid(userId);
		 for(Iterator<Employee> it = emps.iterator();it.hasNext();){
			 Employee emp = it.next();
			 Company com=(Company)organizationService.getOriginalOrganization(emp.getCompanyId());
			 if(!companies.contains(com)){
				 companies.add(com);
			 }
			 
		 }
		 return companies;
	}

	public Employee getByUserid(String userid,String companyId) {
		
		List<Employee> emps = employeeDao.findByUserid(userid, companyId);
		if(emps != null && emps.size()>0){
			return emps.get(0);
		}
		return null;
	}
	@Transactional(readOnly = false)
	public void save(Employee entity) {
		User user = entity.getUser();
		if( user != null){
			User olduser = userService.getUser(user.getId());
			if(olduser == null){
					userService.registerUser(user);
			}
			entity.setUserid(user.getId());
		}
		
		super.save(entity);
	}
	@Transactional(readOnly = false)
	public void update(Employee entity,boolean update) {
		List<Employee> emps = employeeDao.findByUserid(entity.getUserid(), UserUtils.getUserCompanyId());
		for(Iterator<Employee> it = emps.iterator();it.hasNext();){
			Employee emp = it.next();
			if(!emp.getId().equals(entity.getId())){
				throw new UserAssociationException("User already associate with another employee.");
			}
		}
		User user = entity.getUser();
		if(update){
			if( user != null){
				User olduser = userService.getUser(user.getId());
					if(user.getName() == null || user.getName().trim().length() == 0){
						user.setName(entity.getName());
					}
					user.setDeleted(entity.getDeleted());
					user.setRegisterDate(new Date());
					if(olduser == null){
							userService.registerUser(user);
					}else{
						userService.updateUser(user);
					}
					entity.setUserid(user.getId());
	
			}
		}else{
			User olduser = userService.getUser(entity.getUserid());
			if(olduser != null){
				entity.setUser(olduser);
				entity.setUserid(olduser.getId());
			}else{
				entity.setUser(null);
				entity.setUserid(null);
			}
		}	
		super.save(entity);
	}
	public Employee get(String id){
		Employee emp = getDao().findOne(id);
		
		if(emp != null && emp.getUserid() != null){
			emp.setUser(userService.getUser(emp.getUserid()));
		}
		return emp;
	}

	public Company getUserCompany(String empid){
		Employee emp = get(empid);
		if(emp == null || emp.getParent() == null){
			return null;
		}
		Organization org = emp;
		
		while(org != null ){
			if(org instanceof Company){
				return (Company) org;
			}
			org = organizationService.getOriginalOrganization(org.getParent().getId());
		}
		return null;
	}


}
