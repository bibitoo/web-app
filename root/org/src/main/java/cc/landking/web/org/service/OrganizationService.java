package cc.landking.web.org.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.entity.Role;
import cc.landking.web.core.entity.User;
import cc.landking.web.core.service.AuthorizationService;
import cc.landking.web.core.service.IUserRoleAware;
import cc.landking.web.core.service.LandkingUser;
import cc.landking.web.core.service.OrganizationData;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.core.service.UserService;
import cc.landking.web.core.utils.Collections3;
import cc.landking.web.org.dao.CompanyDao;
import cc.landking.web.org.dao.DepartmentDao;
import cc.landking.web.org.dao.GroupDao;
import cc.landking.web.org.dao.OrganizationDao;
import cc.landking.web.org.dao.PostDao;
import cc.landking.web.org.entity.Company;
import cc.landking.web.org.entity.Department;
import cc.landking.web.org.entity.Employee;
import cc.landking.web.org.entity.Group;
import cc.landking.web.org.entity.Organization;
import cc.landking.web.org.entity.Post;

@Component@Service
@Transactional(readOnly = true)

public class OrganizationService extends TreeService<Organization> implements  IUserRoleAware {


	@Autowired
	private DepartmentDao departmentDao;
	
	private @Autowired UserService userService;
	private @Autowired EmployeeService employeeService;
	
	private @Autowired AuthorizationService authorizationService;
	
	@Autowired
	private CompanyDao companyDao;
	
	@Autowired
	private GroupDao groupDao;
	
	@Autowired
	private PostDao postDao;
	

	public void setCompanyDao(CompanyDao companyDao) {
		this.companyDao = companyDao;
	}

	public void setGroupDao(GroupDao groupDao) {
		this.groupDao = groupDao;
	}

	public void setPostDao(PostDao postDao) {
		this.postDao = postDao;
	}

	@Autowired
	private OrganizationDao organizationDao;


	@Override
	public BaseDao<Organization> getDao() {
		return organizationDao;
	}
	
	@Autowired
	@Qualifier("organizationDao")
	public void setOrganizationDao(OrganizationDao organizationDao) {
		this.organizationDao = organizationDao;
	}

	public List<Organization> findByParent(String id){
		ITree parent = null;
		if(StringUtils.isNotEmpty(id)){
			parent = get(id);
		}
		return organizationDao.findByParentAndDeleted(parent, false);
	}
	
	public Organization getOriginalOrganization(String id){
		Organization org = get(id);
		try{
			if(org.getOrgType() != null && org.getOrgType().equals("Company")){
				org = companyDao.findOne(id);
			}else if(org.getOrgType() != null && org.getOrgType().equals("Department")){
				org =  departmentDao.findOne(id);
			}else if(org.getOrgType() != null && org.getOrgType().equals("Employee")){
				org =  employeeService.get(id);
			}else if(org.getOrgType() != null && org.getOrgType().equals("Group")){
				org =  groupDao.findOne(id);
			}else if(org.getOrgType() != null && org.getOrgType().equals("Post")){
				org =  postDao.findOne(id);
			}
			
			
		}catch(Exception ex){
			ex.printStackTrace();
		}

		return org;
	}
	
	public List<Organization> findParents(Organization organization){
		List<Organization> organizations = new ArrayList<Organization>();
		if(organization != null){
			organizations.add(organization);
			Organization parent = organization.getParent();
			while(parent != null && !Company.class.getSimpleName().equals(parent.getOrgType())){
				organizations.add(organization);
				parent = parent.getParent();
			}
		}
		return organizations;
	}

	@Override
	public void addRoles(LandkingUser suser) {
		if (suser.getCompanyId()==null){
			List<Company> list=employeeService.findCompanyByUserId(suser.getId());
			if(list.size()>0){
				suser.setCompanyId(list.get(0).getId());
			}
		}
		Employee employee = employeeService.getByUserid(suser.getId(),suser.getCompanyId());
		if(employee != null){
			suser.getRoles().add("orguser");
			
			Company com = null;
			if(suser.getCompanyId()!= null){
				com =  (Company) getOriginalOrganization(suser.getCompanyId());
			}else{
				com =  employeeService.getUserCompany(employee.getId());
				if(com != null){
					suser.setCompanyId(com.getId());
				}
			}
			LandkingUser theUser = getUser(suser.getLoginName(),suser.getCompanyId());
			theUser.writeProperties(suser);
			
			
			List<String> organizations = findOrganizations(employee.getId());

			organizations.add(employee.getId());
			if(suser.getCompanyId()!=null && !organizations.contains(suser.getCompanyId())){
				organizations.add(suser.getCompanyId());
			}
			suser.setOrganizations(organizations);
			
		}
		
	}

	
	public LandkingUser getUser(String loginName, String companyId) {
		User user = userService.findUserByLoginName(loginName);
		LandkingUser suser = new LandkingUser(user.getId(),user.getLoginName(),user.getName());

		suser.setCompanyId(companyId);
		if (suser.getCompanyId()==null){
			suser.setCompanyId(user.getDefaultOrganization());
			List<Company> list=employeeService.findCompanyByUserId(suser.getId());
			if(list.size()>0){
				suser.setCompanies(Collections3.extractToList(list, "id"));
				if(suser.getCompanyId() == null){
					suser.setCompanyId(list.get(0).getId());
				}
			}
		}
		List<Company> userCompanies = employeeService.findCompanyByUserId(suser.getId());
		if(userCompanies != null && userCompanies.size()>0){
			for(Iterator<Company> it = userCompanies.iterator();it.hasNext();){
				suser.getCompanies().add(it.next().getId());
			}
		}
		Employee employee = employeeService.getByUserid(suser.getId(),suser.getCompanyId());
		if(employee != null){
			suser.setCurrentEmployeeId(employee.getId());
			suser.getRoles().add("orguser");
			List<String> organizations =  findOrganizations(employee.getId());
			List<Role> roles = authorizationService.findRolesByOrganizations(organizations);
			suser.getRoles().addAll(Collections3.extractToList(roles, "code"));
			Company com = null;
			if(suser.getCompanyId()!= null){
				com =  (Company) getOriginalOrganization(suser.getCompanyId());
			}else{
				com =  employeeService.getUserCompany(employee.getId());
				if(com != null){
					suser.setCompanyId(com.getId());
				}
			}

			organizations.add(employee.getId());
			if(suser.getCompanyId()!=null && !organizations.contains(suser.getCompanyId())){
				organizations.add(suser.getCompanyId());
			}
			suser.setOrganizations(organizations);
			
		}
		return suser;
	}
	public List<String> findOrganizations(String orgId){
		Organization org = get(orgId);
		HashSet<String> orgset = new HashSet<String>();
		// parents
		List<Organization> orgs = findParents(org);
		orgset.addAll(Collections3.extractToList(orgs, "id"));
		// groups
		Set<Group> empgroups = org.getGroups();
		for(Group group : empgroups){
			orgs = findParents(group);
			orgset.addAll(Collections3.extractToList(orgs, "id"));
		}
		//leaders
		if(org.getOrgType().equals("Employee")){
			Employee employee = (Employee) this.getOriginalOrganization(org.getId());
			List<Department> empDepts = employee.getManageDepartment();
			for(Department group : empDepts){
				orgs = findParents(group);
				orgset.addAll(Collections3.extractToList(orgs, "id"));
			}
			//posts
			Post post = employee.getPost();
			orgs = findParents(post);
			orgset.addAll(Collections3.extractToList(orgs, "id"));
		}
		List<String> organizations = new ArrayList<String>();
		organizations.addAll(orgset);
		return organizations;

	}
	public OrganizationData getById(String id){
		Organization org = get(id);
		if(org == null){
			return null;
		}
		return org.getOrganizationData();
	}


	public List<OrganizationData> findCompanies(String userid) {
		List<OrganizationData> retval = new ArrayList<OrganizationData>();
		List<Company> userCompanies = employeeService.findCompanyByUserId(userid);
		if(userCompanies != null && userCompanies.size()>0){
			for(Iterator<Company> it = userCompanies.iterator();it.hasNext();){
				Company company = it.next();
				retval.add(company.getOrganizationData());
			}
		}

		return retval;
	}


	public List<OrganizationData> findCompaniesByUser(String userid) {
		 List<OrganizationData> retval = new ArrayList<OrganizationData>();
		List<Company> userCompanies = employeeService.findCompanyByUserId(userid);
		if(userCompanies != null && userCompanies.size()>0){
			for(Iterator<Company> it = userCompanies.iterator();it.hasNext();){
				Company company = it.next();
				retval.add(company.getOrganizationData());
			}
		}
		return retval;
	}
}
